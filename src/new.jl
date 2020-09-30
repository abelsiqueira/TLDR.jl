export new_entry, new_pkg, new_snippet

"""
    new_pkg(pkg, description, tags)
    new_snippet(cmd, description, tags; pkg="")
    new_entry(pkg, kind, cmd, description, tags)

Create a new entry on `Jet.data` adding it in the correct order.
All entries should be strings, except for `tags` which is an array of strings.
"""
function new_entry(pkg, kind, cmd, description, tags::Vector)
  push!(data,
    OrderedDict{String,Any}(
      "command" => cmd,
      "description" => description,
      "kind" => kind,
      "package" => pkg,
      "tags" => tags
    )
  )
  p(x) = x["package"]
  o(x) = Dict("header" => 1, "command" => 2)[x["kind"]]
  ℓ(x) = length(x["description"])
  sort!(data, by=x->(p(x), o(x), ℓ(x)))
  open(joinpath(@__DIR__, "..", "data.json"), "w") do io
    JSON.print(io, data, 2)
  end
end
