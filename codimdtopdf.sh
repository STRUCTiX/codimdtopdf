#!/bin/bash

if [ $# != 2 ]; then
  echo "Usage: $0 inputfile.md outputfile.pdf"
  exit
fi

pandocConvert() {
  mkdir -p temp
  echo $1
  pandoc -s -V geometry:margin=1in -o temp/tempfile.tex $1
}

convertHyperlinks() {
  sed -i 's/\\hyperlink{.*}{.*}/\L&/g' temp/tempfile.tex
  sed -i 's/{\[}TOC{\]}/\\tableofcontents/g' temp/tempfile.tex
}

compilepdf() {
  pushd ./temp
  xelatex tempfile.tex
  xelatex tempfile.tex
  xelatex tempfile.tex
  popd
}

cleanup() {
  mv ./temp/tempfile.pdf $1
  rm -r temp
}

echo "Converting with Pandoc"
pandocConvert $1
echo "Changing Hyperlinks"
convertHyperlinks
echo "Compile PDF with XeLaTeX"
compilepdf
echo "Cleanup"
cleanup $2
echo "Done"
