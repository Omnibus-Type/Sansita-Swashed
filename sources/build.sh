#!/bin/sh
set -e



echo "Generating Static fonts"
mkdir -p ../fonts/ttf/
rm -rf ../fonts/ttf/*.ttf
fontmake -g Sansita-Swashed.glyphs -i -o ttf --output-dir ../fonts/ttf/

echo "Post processing"
ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
	gftools fix-dsig -f $ttf;
	ttfautohint $ttf $ttf.fix;
	mv $ttf.fix $ttf;
	gftools fix-hinting $ttf
	mv $ttf.fix $ttf;
done



echo "Generating VFs"
mkdir -p ../fonts/vf/
rm -rf ../fonts/vf/*.ttf
fontmake -g Sansita-Swashed.glyphs -o variable --output-path ../fonts/vf/SansitaSwashed-Italic\[wght\].ttf

echo "Post processing"
vfs=$(ls ../fonts/vf/*.ttf)
for vf in $vfs
do
	gftools fix-dsig -f $vf;
	gftools fix-unwanted-tables $vf
	gftools fix-nonhinting $vf $vf.fix
	mv $vf.fix $vf;
done

gftools fix-vf-meta $vfs;
for vf in $vfs
do
	mv "$vf.fix" $vf;
done

rm ../fonts/vf/*backup*.ttf



echo "QAing"
gftools qa -f ../fonts/vf/*.ttf -fb ../fonts/vf/*.ttf -o ../qa --fontbakery --diffenator --diffbrowsers

rm -rf master_ufo/ instance_ufo/
