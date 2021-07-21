export new_entry, new_pkg, new_snippet, reorder!

"""
    new_entry(pkg, kind, cmd, description, tags)

Create a new entry on `TLDR.data` adding it in the correct order.
You probably want `new_pkg` or `new_snippet` instead.

Some rules:

- All entries should be strings, except for `tags` which is an array of strings.
- `pkg` should be the case sensitive package name (no .jl), e.g. "TLDR".
- `kind` should be either `header` or `snippet`.
- `tags` shouldn't be empty.
- If `kind` is `header` then `cmd` should be "".
"""
function new_entry(pkg, kind, cmd, description, tags::Vector)
  if !(kind in ["header", "snippet"])
    error("kind \"$kind\" not accepted. It should be \"header\" or \"snippet\"")
  elseif length(tags) == 0
    error("Please pass some tags.")
  elseif kind == "header" && cmd != ""
    error("For kind=\"header\", cmd should be \"\"")
  end
  D = OrderedDict{String,Any}(
    "command" => cmd,
    "description" => description,
    "kind" => kind,
    "package" => pkg,
    "tags" => sort(tags)
  )
  if D in data
    @warn("Entry already exists, ignoring")
    return
  end
  push!(data, D)
  reorder!()
end

"""
    new_pkg(pkg, description, tags)

Create a new entry for a package on `TLDR.data` adding it in the correct order.

Some rules:

- All entries should be strings, except for `tags` which is an array of strings.
- `pkg` should be the case sensitive package name (no .jl), e.g. "TLDR".
- `tags` shouldn't be empty.
"""
new_pkg(pkg, desc, tags) = new_entry(pkg, "header", "", desc, tags)

"""
    new_snippet(cmd, description, tags)
    new_snippet(pkg, cmd, description, tags)

Create a new snippet entry on `TLDR.data` adding it in the correct order.
If the snippet depends on a package to work, then `pkg` should be passed.

Some rules:

- All entries should be strings, except for `tags` which is an array of strings.
- `pkg` should be the case sensitive package name (no .jl), e.g. "TLDR".
- `tags` shouldn't be empty.
"""
new_snippet(cmd, desc, tags) = new_entry("", "snippet", cmd, desc, tags)
new_snippet(pkg, cmd, desc, tags) = new_entry(pkg, "snippet", cmd, desc, tags)

"""
    reorder!()

Reorder `TLDR.data`. Only useful if you manually modify `TLDR.data`, for instance after a Pull Request
review. Using `new_pkg` and `new_snippet` will add everything in the correct place.
"""
function reorder!()
  p(x) = x["package"]
  o(x) = Dict("header" => 1, "snippet" => 2)[x["kind"]]
  ℓ(x) = length(x["description"])
  sort!(data, by=x->(p(x), o(x), ℓ(x)))
  open(joinpath(@__DIR__, "..", "data.json"), "w") do io
    JSON.print(io, data, 2)
  end
end