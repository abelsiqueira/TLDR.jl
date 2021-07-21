using GitHub, TLDR, JSON

cmts = GitHub.comments("abelsiqueira/TLDR.jl", 26, :issue)[1]
cmt = cmts[end]
inum = length(cmts)
D = JSON.parse(cmt.body)
TLDR.new_entry(D["package"], D["kind"], D["command"], D["description"], D["tags"])
cimsg = ":robot: New entry: "
if D["package"] != ""
  cimsg *= D["package"] * " - "
end
cimsg *= D["description"]
println("::set-output name=cimsg::$cimsg")
println("::set-output name=inum::$inum")