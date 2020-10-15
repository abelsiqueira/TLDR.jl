const title_crayon  = Crayon(foreground = :light_cyan, bold = true, underline = true)
const desc_crayon = Crayon(foreground = :light_cyan, bold = true, underline = false)
const cmd_desc_crayon = Crayon(foreground = :green, bold = false)
const cmd_crayon = Crayon(foreground = :blue)

"""
    format(output, print)

Internal function. Formats the output of the internal `pkg_` commands.
"""
function format(output, should_print)
  # Build output
  s = ""
  for entry in output
    if entry["kind"] == "header"
      s *= entry["package"] * "\n\n" * entry["description"] * "\n\n"
      if should_print
        print(title_crayon, entry["package"] * "\n\n", desc_crayon, entry["description"] * "\n\n")
      end
    else
      s *= "- " * entry["description"] * "\n  `" * entry["command"] * "`\n\n"
      if should_print
        print(cmd_desc_crayon, "- " * entry["description"] * "\n ", cmd_crayon, "`"*entry["command"], "`\n\n")
      end
    end
  end
  if !should_print
    s
  end
end