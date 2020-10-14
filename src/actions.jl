export jet, jet_pkg, jet_snippet, @jet_str

macro jet_str(kw)
  jet(kw, true)
end

"""
    jet_pkg(pkg_name)

Return all entries for which its package field matches `pkg_name`.
"""
function jet_pkg(pkg_name, should_print=false)
  output = []
  for entry in data
    if lowercase(entry["package"]) == lowercase(pkg_name)
      push!(output, entry)
    end
  end
  format(output, should_print)
end

"""
    jet_snippet(kw)

Return all entries that match the `kw` in either the description or the command of the entry.
"""
function jet_snippet(kw, should_print=false)
  output = []
  kw = lowercase(kw)
  for entry in data
    if occursin(kw, lowercase(entry["command"])) ||
       occursin(kw, lowercase(entry["description"])) ||
       kw in entry["tags"]
      push!(output, entry)
    end
  end
  format(output, should_print)
end

"""
    jet(str, print=false)

The main function of `jet`, called when the `jet>` REPL or `jet"str"` are used.
The passed `str` determines what kind of search is made.

- `str` is either `?` or `help`: equivalent to `jet> pkg:Jet`.

- `str = pkg:something`: searches for commands associated to the package `something`.

- `str = cmd:something`: searches for commands matching `something`.

- `str = something`: Equivalent to `cmd:something`.
"""
function jet(str, should_print=false)
  s = split(str, ":")
  println(length(s))
  if length(s) == 1
    if str == "?" || str == "help"
      jet_pkg("Jet", should_print)
    else
      jet_snippet(str, should_print)
    end
  elseif length(s) == 2
    kind = s[1]
    arg = s[2]
    if kind in ["pkg", "package"]
      jet_pkg(arg, should_print)
    elseif kind in ["cmd", "command", "snippet"]
      jet_snippet(arg, should_print)
    else
      error("Unexpected action $kind. See Jet's help")
    end
  # Currently supported searches with more than a single ':' come in the form of `pkg:Package cmd:Command`
  elseif length(s) == 3
    first = findfirst(':', str)
    last = findlast(':', str)
    sep = findlast(' ', str[begin:last])

    kind = [str[begin:first-1], str[sep+1:last-1]]
    arg = [str[first+1:sep-1], str[last+1:end]]

    if kind[1] in ["pkg", "package"] &&
       kind[2] in ["cmd", "command", "snippet"]
      println(kind)
      println(arg)
    else
      error("Unexpected compound action `$(kind[1]):... $(kind[2]):...`. Maybe you meant `pkg:$(arg[1]) cmd:$(arg[2])`?")
    end
  else
    error("Unexpected number of actions. See Jet's help")
  end
end
