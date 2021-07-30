# This file was generated, do not modify it. # hide
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