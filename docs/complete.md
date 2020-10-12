@def title = "Complete list"
@def hascode = true
@def rss = "Complete list of TLDR packages"
@def rss_title = "Complete list"
@def rss_pubdate = Date(2019, 5, 1)

@def tags = ["syntax", "code", "image"]

# Complete list

The complete list of packages currently available on TLDR is below.

\toc

<!-- {{tldrdata}} -->

```julia:./complete.jl
# hideall
using DataStructures, JSON, Pkg, TLDR
path = joinpath(dirname(pathof(TLDR)), "../data.json")
data = JSON.parsefile(path, dicttype = OrderedDict)
opened = false
curr_pkg = ""
for entry in data
  global curr_pkg
  if entry["kind"] == "header"
    curr_pkg = entry["package"]
    println("## ", curr_pkg)
    println(entry["description"])
  else
    if curr_pkg != entry["package"]
      curr_pkg = entry["package"]
      println("## ", curr_pkg)
    end
    println("- ", entry["description"])
    lines = strip.(split(entry["command"], "\n"))
    println("```julia")
    for line in lines
      println(line)
    end
    println("```")
  end
end
```

\textoutput{./complete.jl}