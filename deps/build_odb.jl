
"""
This script will download and build ODB  

Note GCC 5.4 will give an internal compiler error. 
Use 

module use /lustre/storeB/users/yuriib/opt/modules
module load gcc/6.2.0

"""

println("Building ODB")

const version="1.0.2"
const filename="odb-$version-Source"
const tarfilename="$filename.tar.gz"

const url="https://confluence.ecmwf.int/display/shareit/27406481/MRSa50e7b069bd840239f6cd8d2815dc01fYXF/$tarfilename?version=1"

const depsdir      = pwd()
const installdir   ="$depsdir/install/odb"
const builddir     ="$depsdir/build/odb"
const downloadsdir ="$depsdir/downloads"
const srcdir       ="$depsdir/src/$filename"

println("Downloading $tarfilename")
download(url,"$downloadsdir/$tarfilename") 

cd("$depsdir/src/") 
run(`tar xzf $depsdir/downloads/$tarfilename`) 

cd(builddir) 

# configure 
run(`cmake -DCMAKE_INSTALL_PREFIX=$installdir  $srcdir`)

println("building")
run(`cmake  --build . -- -j32 `)
run(`make install`)

println("testing")
run(`ctest`)



println("Build succesful")
