const title_crayon    = Crayon(foreground = :light_cyan, bold = true, underline = true)
const desc_crayon     = Crayon(foreground = :light_cyan, bold = true, underline = false)
const cmd_desc_crayon = Crayon(foreground = :green, bold = false)
const cmd_crayon      = Crayon(foreground = :blue)

"""
    build_unformatted_output(output)

Internal function. Build the output of the internal `pkg_` commands, without formatting the output with color and syntax highlighting.
"""
function build_unformatted_output(output)
  # Build output
  s = ""
  for entry in output
    if entry["kind"] == "header"
      s *= entry["package"] * "\n\n" * entry["description"] * "\n\n"
    else
      s *= "- " * entry["description"] * "\n  `" * entry["command"] * "`\n\n"
    end
  end
  s
end

"""
    build_formatted_output(output)

Internal function. Build the output of the internal `pkg_` commands, formatting it.
"""
function build_formatted_output(output)
  # Build output
  for entry in output
    if entry["kind"] == "header"
      println(title_crayon, entry["package"])
      println("")
      println(desc_crayon,  entry["description"])
      println("")
    else
      println(cmd_desc_crayon, "- ", entry["description"])
      println(cmd_crayon,      "  ", entry["command"])
      println("")
    end
  end
end
