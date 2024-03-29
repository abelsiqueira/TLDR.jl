module TLDR

using Crayons
using DataStructures
using InteractiveUtils
using GitHub
using JSON
using Markdown
using ReplMaker
using StringDistances

function __init__()
  global data = JSON.parsefile(joinpath(@__DIR__, "..", "data.json"), dicttype=OrderedDict{String,Any})
end

include("actions.jl")
include("format.jl")
include("new.jl")
include("repl.jl")
include("submit.jl")

end # module