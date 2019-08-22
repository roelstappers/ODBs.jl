
"""
This script will download and build the ODB API 
"""

println("Building ODB API")
const version="0.18.1"
const filename="odb_api_bundle-$version-Source"
const tarfilename="$filename.tar.gz"

const depsdir     = pwd()
const builddir    = mkpath("$depsdir/build/$filename/")
const srcdir      = mkpath("$depsdir/src/$filename/")
const installdir  = mkpath("$depsdir/install/$filename/")
const downloaddir = mkpath("$depsdir/downloads/")
const url="https://confluence.ecmwf.int/download/attachments/61117379/$tarfilename?api=v2"
 
# download
download(url,"$downloaddir/$tarfilename") 

# extract 
run(`tar xzf $downloaddir/$tarfilename  --directory $depsdir/src`) 

# build using cmake 
cd(builddir)
run(`cmake -DCMAKE_INSTALL_PREFIX=$installdir -DENABLE_ODB_API_SERVER_SIDE=ON -DENABLE_FORTRAN=ON -DENABLE_GRIB=OFF -DENABLE_ODB_SERVER_TIME_FORMAT_FOUR_DIGITS=ON -DENABLE_PYTHON=OFF -DENABLE_ODB=ON -DODB_SCHEMAS="ECMA;CCMA" $srcdir`)

println("Building ODB this may take a while. See deps/build.log" )
run(`cmake  --build $builddir -- -j32 `)
run(`make install`)

#println("testing")
#run(`ctest`)

# Clean up deprecated binaries from bin dir 
files=readdir("$installdir/bin")
for file in files
   if islink(file) && readlink(file)==".odb_deprecated.sh"
     rm(file)
   end    
end 

println("Build succesful")
