# Choice-Syllabus-Latest — retired, and deliberately kept alive

The syllabus now lives in **[`ccarrollATjhuecon/Choice`](https://github.com/ccarrollATjhuecon/Choice)**,
under `Syllabus/`, and is published at
**<https://ccarrollatjhuecon.github.io/Choice/Syllabus/>**.

This repository holds nothing but a redirect. Its full history came across with
the move (`git subtree`, no rewriting), so every commit from 2017 onward is in
`Choice`.

## Do not archive, delete, or rename this repository

Not tidiness — the redirect stops working:

- **Archiving a repository stops GitHub Pages rebuilding it.** The redirect
  would go stale and eventually stop being served.
- **Renaming or transferring does not carry the Pages URL.** GitHub forwards
  repository URLs after a move; it does not forward `*.github.io` ones.
- **`www.econ2.jhu.edu/people/ccarroll/courses/Choice/Syllabus/` redirects
  here**, on a JHU server we do not control the release schedule of.
- **The old address was emailed to students** during the Fall 2026 term.

Leave the Pages source exactly as it is: branch `master`, path `/docs`.

## What is here

| | |
|---|---|
| `docs/index.html` | canonical link, meta refresh, and a script redirect that **preserves the fragment** — the syllabus is one long page of anchors |
| `docs/404.html` | rewrites `/Choice-Syllabus-Latest/X` to `/Choice/Syllabus/X`, so deep links land on their counterpart rather than the front page |
| `docs/Syllabus.html` | the old site exposed this name as well as `index.html` |
| `docs/_config.yml` | required for Pages to serve the directory at all |

The build workflow has been removed: with no `Syllabus.tex` here it could only
fail, forever, and mail someone about it every time.
