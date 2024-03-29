export tldr, tldr_pkg, tldr_snippet, tldr_snippet_in, @tldr_str

macro tldr_str(kw)
  tldr(kw, true)
end

"""
    tldr_pkg(pkg_name)

Return all entries for which its package field matches `pkg_name`.
"""
function tldr_pkg(pkg_name, should_print=true)
  output = []
  i = 0
  for entry in data
    if lowercase(entry["package"]) == lowercase(pkg_name)
      push!(output, entry)
    elseif StringDistances.compare(lowercase(entry["package"]), lowercase(pkg_name), TokenMax(Levenshtein())) > 0.7
      push!(output, entry)
      i = i+1
    end
  end
  if i > 0
    println("Closest Result to $(pkg_name) is:")
    i = 0
  end
  if should_print
    build_formatted_output(output)
  else
    build_unformatted_output(output)
  end
end

"""
    tldr_snippet(kw)

Return all entries that match the `kw` in either the description or the command of the entry.
"""
function tldr_snippet(kw, should_print=true)
  output = []
  kw = lowercase(kw)
  i = 0
  for entry in data
    for tag in entry["tags"]
      if kw == lowercase(tag) || StringDistances.compare(kw, lowercase(tag), TokenMax(Levenshtein())) > 0.6
        i = i+1
      end
    end
    if occursin(kw, lowercase(entry["command"])) ||
       occursin(kw, lowercase(entry["description"])) || i > 0
      push!(output, entry)
      i = 0
    end
  end
  if should_print
    build_formatted_output(output)
  else
    build_unformatted_output(output)
  end
end

"""
    tldr_snippet_in(kw, pkg_name)

Return all entries part of `pkg_name` that match the `kw` in either the description or the command of the entry.
"""
function tldr_snippet_in(kw, pkg_name, should_print=true)
  output = []
  kw = lowercase(kw)
  i = 0
  pkg_name = lowercase(pkg_name)
  for entry in data
    for tag in entry["tags"]
      if kw == lowercase(tag) || StringDistances.compare(kw, lowercase(tag), TokenMax(Levenshtein())) > 0.6
        i = i+1
      end
    end
    if (lowercase(entry["package"]) == pkg_name || StringDistances.compare(entry["package"], lowercase(pkg_name), TokenMax(Levenshtein())) > 0.7) &&
       (occursin(kw, lowercase(entry["command"])) ||
       occursin(kw, lowercase(entry["description"])) ||
       i > 0)
      push!(output, entry)
      i = 0
    end
  end
  if should_print
    build_formatted_output(output)
  else
    build_unformatted_output(output)
  end
end

"""
    tldr(str, print=true)

The main function of `tldr`, called when the `tldr>` REPL or `tldr"str"` are used.
The passed `str` determines what kind of search is made.

- `str` is either `?` or `help`: equivalent to `tldr> pkg:tldr`.

- `str = pkg:something`: searches for commands associated to the package `something`.

- `str = cmd:something`: searches for commands matching `something`.

- `str = something`: Equivalent to `cmd:something`.
"""
function tldr(str, should_print=true)
  s = split(str, ":")
  if length(s) == 1
    if str == "?" || str == "help"
      tldr_pkg("tldr", should_print)
    else
      tldr_snippet(str, should_print)
    end
  elseif length(s) == 2
    kind = s[1]
    arg = s[2]
    if kind in ["pkg", "package"]
      tldr_pkg(arg, should_print)
    elseif kind in ["cmd", "command", "snippet"]
      tldr_snippet(arg, should_print)
    else
      error("Unexpected action $kind. See tldr's help")
    end
  # Currently supported searches with more than a single ':' come in the form of either `pkg:Package cmd:Command` or `cmd:Command pkg:Package`
  elseif length(s) == 3
    first = findfirst(':', str)
    last = findlast(':', str)
    sep = findlast(' ', str[1:last])

    kind = [str[1:first-1], str[sep+1:last-1]]
    kws = [str[first+1:sep-1], str[last+1:end]]

    if kind[1] in ["pkg", "package"] &&
       kind[2] in ["cmd", "command", "snippet"]
      tldr_snippet_in(kws[2], kws[1], should_print)
    elseif kind[2] in ["pkg", "package"] &&
           kind[1] in ["cmd", "command", "snippet"]
      tldr_snippet_in(kws[1], kws[2], should_print)
    else
      error("Unexpected compound action `$(kind[1]):... $(kind[2]):...`. Maybe you meant `pkg:$(kws[1]) cmd:$(kws[2])`?")
    end
  else
    error("Unexpected number of actions. See tldr's help")
  end
end
