#!/bin/sh
# This is a generated file. Please make sure to edit source files.
trigger_asciidoctor() (
test ! -e .preasciidoctor.sh || . .preasciidoctor.sh
params=""
if [ "$DIAGRAM" = "true" ]; then
params="$params -r asciidoctor-diagram"
fi
for adoc in $(find . -name main.adoc -type f | sort); do
if [ ! -e "$(dirname $adoc)/.adocignore" ]; then
echo "Document: $adoc"
mkdir -p /target/$(dirname $adoc)
asciidoctor $params $adoc -o /target/$(dirname $adoc)/index.html
fi
done
find . -name .adocassets -type f | sort > /tmp/assets
while read assets; do
echo "Assets: $(dirname $assets)"
mkdir -p /target/$(dirname $(dirname $assets))
cp -r $(dirname $assets) /target/$(dirname $assets)
rm /target/$assets
done < /tmp/assets
test ! -e .postasciidoctor.sh || . .postasciidoctor.sh
)
trigger_environment() (
rm -f /target/env
append() {
echo export $1=\"$2\" >> /target/env
}
test ! -d /src/.git || append GIT $(git rev-parse HEAD)
append IDENTIFIER "$IDENTIFIER"
append RELEASE "$RELEASE"
append TIMESTAMP "$(date -u +"%Y-%m-%d %H:%Mz")"
append TITLE "$TITLE"
test ! -r /src/tools/script/environment.sh || . /src/tools/script/environment.sh
)
trigger_examples() (
test ! -r /target/env || . /target/env
rm -rf /target/examples
mkdir -p /target/examples /target/site/files
test ! -r /src/tools/template/examples-readme || cat /src/tools/template/examples-readme | envsubst > /target/examples/README
for folder in $(find /src/rules -mindepth 2 -maxdepth 2 -name example -type d | sort); do
cp -r $folder/* /target/examples/
done
test ! -r /src/tools/script/examples.sh || . /src/tools/script/examples.sh
cd /target/examples
rm -rf /target/examples.zip
zip -9 -r /target/examples.zip *
cp /target/examples.zip /target/site/files/examples.zip
)
trigger_schematron() (
test ! -r /target/env || . /target/env
rm -rf /target/schematron
mkdir -p /target/schematron /target/site/files
test ! -r /src/tools/template/schematron-readme || cat /src/tools/template/schematron-readme | envsubst > /target/schematron/README
for sch in $(ls /src/rules/*/sch/*.sch | sort); do
echo "Prepare: $sch"
schematron prepare $sch /target/schematron/$(basename $sch)
done
test ! -r /src/tools/script/schematron.sh || . /src/tools/script/schematron.sh
cd /target/schematron
rm -rf /target/schematron.zip
zip -9 -r /target/schematron.zip *
cp /target/schematron.zip /target/site/files/schematron.zip
)
trigger_xsd() (
test ! -r /target/env || . /target/env
rm -rf /target/xsd
mkdir -p /target/xsd /target/site/files
for folder in $(find /src/xsd -mindepth 1 -maxdepth 1 -type d | sort); do
name=$(basename $folder)
echo "Packaging $name"
cp -r $folder /tmp/$name
cd /tmp/$name
test ! -e prepare.sh || . prepare.sh
rm -rf prepare.sh
zip -9 -r /target/xsd/$name.zip *
cp /target/xsd/$name.zip /target/site/files/xsd-$name.zip
done
)
trigger_scripts() (
test ! -r /target/env || . /target/env
for file in $(find /src/scripts/$1 -type f -name *.sh -maxdepth 1 | sort); do
echo "> $(basename $file)"
. $file
done
)
trigger_static() (
cp -rv . /target
)
$*
