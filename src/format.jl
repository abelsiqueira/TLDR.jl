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
        print(Crayon(foreground = :light_cyan, bold = true, underline = true),entry["package"] * "\n\n",Crayon(foreground = :light_cyan, bold = true, underline = false), entry["description"] * "\n\n")
      end
    else
      s *= "- " * entry["description"] * "\n  `" * entry["command"] * "`\n\n"
      if should_print
        print(Crayon(foreground = :green, bold = false),"- " * entry["description"] * "\n " ,Crayon(foreground = :blue), "`"*entry["command"] , "`\n\n")
      end
    end
  end
  if !should_print
    s
  end
end