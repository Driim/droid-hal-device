if [ -f ./out/target/product/${DEVICE}/system/lib64/libdroidmedia.so ]; then
	DROIDLIB=lib64
elif [ -f ./out/target/product/${DEVICE}/system/lib/libdroidmedia.so ]; then
	DROIDLIB=lib
else
	echo "Please build droidmedia as per HADK instructions"
	exit 1
fi

pkg=droidmedia-"${1:-0.0.0}"
fold=hybris/mw/$pkg
rm -rf $fold
mkdir $fold

mkdir -p $fold/out/target/product/${DEVICE}/system/${DROIDLIB}
mkdir -p $fold/out/target/product/${DEVICE}/system/bin
mkdir -p $fold/external/droidmedia

cp ./external/droidmedia/*.h $fold/external/droidmedia/
cp ./external/droidmedia/hybris.c $fold/external/droidmedia/
# Remove droidmedia bits from out/ (otherwise it would cause a conflict within droid-hal-$DEVICE):
mv ./out/target/product/${DEVICE}/system/${DROIDLIB}/libdroidmedia.so $fold/out/target/product/${DEVICE}/system/${DROIDLIB}/
mv ./out/target/product/${DEVICE}/system/bin/minimediaservice $fold/out/target/product/${DEVICE}/system/bin/
mv ./out/target/product/${DEVICE}/system/bin/minisfservice $fold/out/target/product/${DEVICE}/system/bin/

tar -cjvf $fold.tgz -C $(dirname $fold) $pkg

rm -rf $fold

