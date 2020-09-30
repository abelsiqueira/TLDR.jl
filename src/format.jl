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
    else
      s *= "- " * entry["description"] * "\n  `" * entry["command"] * "`\n\n"
    end
  end
  if should_print
    print(s)
  else
    s
  end
end