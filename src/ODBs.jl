module ODBs

export ODB

export run_with_odb_env
export create_ioassign
export merge

const version=v"0.18.1"
const moduledir=dirname(pathof(ODBs))

const INSTALLDIR="$moduledir/../deps/odb_api_bundle-$version-Source/"
const BINDIR="$INSTALLDIR/bin/"
const INCLUDEDIR="$INSTALLDIR/bin/"

const ODBDICT=Dict("OBS_SYSPATH"   => INCLUDEDIR,
                   "ODB_BEBINPATH" => BINDIR,
                   "ODB_FEBINPATH" => BINDIR,
                   "ODB_BINPATH"   => BINDIR,
                   "ODB_ROOT"      => INSTALLDIR)

const ODBENV = merge(copy(ENV),ODBDICT)                  # Merge ODBDICT in ENV
const ODBENV["PATH"]="$(ODBENV["PATH"]):$BINDIR"   # Append BINDIR to PATH

struct ODB
    file::String
end
Base.show(io::IO,odb::ODB) = print(io, odb.file)

"""
    run_with_odb_env(cmd)

Run cmd command in an ODB environment.
"""
run_with_odb_env(cmd) = run(Cmd(cmd,env=ODBENV))

"""    
    create_ioassign(;dbname, npools=0, tasks=[])

Run create_ioassign. 

"""
function create_ioassign(;dbname,npools=0,tasks=[])
    if isempty(tasks)
        run_with_odb_env(`create_ioassign -l $dbname -d . -n $npools`)
    else
        taskstr=join(tasks, " -t ")
        run_with_odb_env(`create_ioassign -l $dbname -d . -n $npools -t $taskstr -x`)
    end
end

"""
     merge(odbs::Array{ODB,1}, out::ODB) 

Merge the ODB's in the odbs array
"""
Base.merge(odbs::Array{ODB,1},out::ODB) = run_with_odb_env(`odb merge -o $out $(join(odbs," "))`)


end # module