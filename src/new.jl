export new_entry, new_pkg, new_snippet

"""
    new_entry(pkg, kind, cmd, description, tags)

Create a new entry on `Jet.data` adding it in the correct order.
You probably want `new_pkg` or `new_snippet` instead.

Some rules:

- All entries should be strings, except for `tags` which is an array of strings.
- `pkg` should be the case sensitive package name (no .jl), e.g. "Jet".
- `kind` should be either `header` or `snippet`.
- `tags` shouldn't be empty.
- If `kind` is `header` then `cmd` should be "".
"""
function new_entry(pkg, kind, cmd, description, tags::Vector)
  if !(kind in ["header", "command"])
    error("kind \"$kind\" not accepted. It should be \"header\" or \"command\"")
  elseif length(tags) == 0
    error("Please pass some tags.")
  elseif kind == "header" && cmd != ""
    error("For kind=\"header\", cmd should be \"\"")
  end
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

"""
    new_pkg(pkg, description, tags)

Create a new entry for a package on `Jet.data` adding it in the correct order.

Some rules:

- All entries should be strings, except for `tags` which is an array of strings.
- `pkg` should be the case sensitive package name (no .jl), e.g. "Jet".
- `tags` shouldn't be empty.
"""
new_pkg(pkg, desc, tags) = new_entry(pkg, "header", "", desc, tags)

"""
    new_snippet(cmd, description, tags)
    new_snippet(pkg, cmd, description, tags)

Create a new snippet entry on `Jet.data` adding it in the correct order.
If the snippet depends on a package to work, then `pkg` should be passed.

Some rules:

- All entries should be strings, except for `tags` which is an array of strings.
- `pkg` should be the case sensitive package name (no .jl), e.g. "Jet".
- `tags` shouldn't be empty.
"""
new_snippet(cmd, desc, tags) = new_entry("", "snippet", cmd, desc, tags)
new_snippet(pkg, cmd, desc, tags) = new_entry(pkg, "snippet", cmd, desc, tags)