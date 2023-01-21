#!/bin/bash
make4ht --utf8 --config Syllabus.cfg --format html5 Syllabus "svg" "-cunihtf -utf8"
cat page-style.css | cat - Syllabus-generated-by-make4ht.css > Syllabus-page-style.css && mv Syllabus-page-style.css Syllabus.css
cp Syllabus.html index.html
