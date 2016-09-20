#!/bin/sh

mkdir -p /tmp/rules

for x in $(find rules/*/xsl -type f); do

	echo "Generate table for $(basename $x)"

	saxon-xslt -s:$x -xsl:tools/svrlxslt2schematron.xsl -o:$x.sch
	saxon-xquery -s:$x.sch -q:tools/rules_asciidoc.xquery -o:/tmp/rules/$(basename $x).adoc

done

for x in $(find rules/*/sch -type f); do

	echo "Generate table for $(basename $x)"

	saxon-xquery -s:$x -q:tools/rules_asciidoc.xquery -o:/tmp/rules/$(basename $x).adoc

done
