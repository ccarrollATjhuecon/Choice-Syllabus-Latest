#!/bin/bash
# Rebuild the syllabus PDF and the web version in docs/.
#
#   ./build-web.sh
#
# THE ONE RULE: the top-level Syllabus.tex is the only source you edit.
# docs/ is BUILD OUTPUT. This script overwrites it from the top level, so
# anything edited inside docs/ is destroyed. That is not a bug -- it is the
# point. The published syllabus spent 2023-02-27 to 2026-09-06 stale, naming a
# long-departed TA, purely because this step depended on someone remembering to
# run it. It now also runs in CI on every push (.github/workflows/build-web.yml).
#
# Both humans and CI call THIS script, so the two cannot drift apart.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOC=Syllabus
cd "$ROOT"

# Use the texmf tree vendored in the repo, so the build does not depend on
# whatever happens to be installed on the machine. Locally this is usually also
# present under /usr/local/texlive/texmf-local; in CI it is only here.
export TEXMFHOME="$ROOT/texmf-local"

echo "==> PDF"
latexmk -quiet "$DOC.tex"

echo "==> syncing top-level sources into docs/"
# Mirror what the original tooling did with 'cp -Rf . ../Web', minus the noise.
mkdir -p docs
# $DOC.bbl matters: \bibliography{system} pulls system.bib out of texmf-local,
# and it is BIBTEX that turns that into $DOC.bbl. latexmk ran bibtex for the PDF
# above; make4ht never runs it. Without the .bbl copied in, every \cite in the
# HTML renders as a bare "?" -- 55 of them, the whole reading list, while the PDF
# stays perfect. Verified broken on the live page 2026-09-07.
for f in "$DOC.tex" "$DOC.sty" "$DOC.bbl" econtexRoot.texinput latexmkrc *.bib; do
    [ -e "$f" ] && cp -f "$f" docs/ || true
done
for d in Sections Resources texmf-local; do
    [ -d "$d" ] && { rm -rf "docs/$d"; cp -R "$d" "docs/$d"; }
done

echo "==> HTML"
cd docs
export TEXMFHOME="$ROOT/docs/texmf-local"
# _config.yml is required for GitHub Pages to serve the directory at all.
[ -e _config.yml ] || echo 'theme: jekyll-theme-minimal' > _config.yml
# Syllabus.sh is itself an artifact emitted by makeWeb-simple.sh; it replays the
# make4ht + CSS-merge + index.html steps without redoing the .cfg generation.
bash "$DOC.sh"

cd "$ROOT"

# tex4ht renders an unresolved \cite as a bold "?" -- <span class="...">?</span>.
# Fail rather than publish that: a syllabus whose every reading reads "?" still
# builds, still deploys, and still looks fine to whoever pushed it.
if grep -q '>?</span>' docs/index.html; then
    echo "ERROR: $(grep -c '>?</span>' docs/index.html) unresolved citations in docs/index.html." >&2
    echo "       $DOC.bbl did not reach docs/, or bibtex did not run. Not publishing." >&2
    exit 1
fi

echo "==> done"
echo "    PDF : $(ls -la $DOC.pdf | awk '{print $5}') bytes"
echo "    HTML: $(ls -la docs/index.html | awk '{print $5}') bytes"
grep -q 'Teaching Assistant' docs/index.html \
    && echo "    TA in HTML: $(grep -oE 'Teaching Assistant.{0,60}' docs/index.html | head -1 | sed 's/<[^>]*>//g')"
