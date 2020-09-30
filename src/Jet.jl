module Jet

using DataStructures
using JSON
using Markdown
using ReplMaker

function __init__()
  global data = JSON.parsefile(joinpath(@__DIR__, "..", "data.json"), dicttype=OrderedDict)
end

include("actions.jl")
include("format.jl")
include("new.jl")
include("repl.jl")

end # module