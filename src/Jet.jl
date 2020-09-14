module Jet

export jet, @jet_str

using JSON
using Markdown
using ReplMaker

function __init__()
  global data = JSON.parsefile(joinpath(@__DIR__, "..", "data.json"))
end

macro jet_str(kw)
  jet(kw, true)
end

function jet(kw, should_print=false)
  # All relevant entries
  output = []
  for entry in data
    if lowercase(entry["package"]) == lowercase(kw)
      push!(output, entry)
    end
  end

  # Build output
  s = join([
    if entry["type"] == "header"
      entry["package"] * "\n\n" * entry["description"] * "\n\n"
    else
      "- " * entry["description"] * "\n  `" * entry["command"] * "`\n\n"
    end for entry in output
  ], "")
  if should_print
    print(s)
  else
    s
  end
end

isdefined(Base, :active_repl) && initrepl(
  s -> jet(s, true),
  prompt_text = "jet> ",
  prompt_color = :black,
  start_key = '}',
  mode_name = "Jet_mode"
)

end # module