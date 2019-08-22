

tarfilename="swig-4.0.0.tar.gz"

url="http://prdownloads.sourceforge.net/swig/$tarfilename"

println("Downloading $tarfilename")
 
download(url,"$depsdir/downloads/$tarfilename") 

cd("$depsdir/src/") 
run(`tar xzf $depsdir/downloads/$tarfilename`)
