export file_submit, submit

function warn_github_usage()
  @warn("""TLDR uses your GitHub credentials to post on GitHub.

    #######################################
    #  If you don't want that, stop now!  #
    #######################################

  You can write the issue on GitHub directly here:
      https://github.com/abelsiqueira/TLDR.jl/issues/26""")
end

function submit()
  warn_github_usage()
  print("kind (snippet or header): ")
  kind = readline()
  if !(kind ∈ ["snippet", "header"])
    error("$kind is not valid, use snippet or header")
  end

  if kind == "snippet"
    print("command (use \\n to split lines): ")
    cmd = readline()
  end

  print("package: ")
  pkg = readline()

  print("description (shorter is better): ")
  desc = readline()

  tags = String[]
  tag = "a"
  while tag != ""
    print("tag (leave empty to end): ")
    tag = readline()
    push!(tags, tag)
  end
  tags = tags[1:end-1]

  D = Dict(
    "kind" => kind,
    "package" => pkg,
    "description" => desc,
    "command" => cmd,
    "tags" => tags
  )
  write_issue(JSON.json(D, 2))
end


function file_submit()
  warn_github_usage()
  V = Base.active_repl.mistate.current_mode.hist.history
  tmp_file, io = mktemp()
  println(io, """
{
  "command": "$(V[end-1])"
  "description": "[FILL]",
  "kind": "[snippet or header]",
  "package": "[FILL]",
  "tags": ["like", "this"]
}

# To abort, write #ABORT or delete everything
# Lines starting with # will be ignored.
# If submitting a new package leave "command" empty and use "header" kind.
# Otherwise, use kind "snippet".
  """)
  close(io)

  # Manually edit the result
  # TODO: Allow other editors
  tmp_editor = ENV["JULIA_EDITOR"]
  ENV["JULIA_EDITOR"] = "nano"
  edit(tmp_file)
  ENV["JULIA_EDITOR"] = tmp_editor

  # Delete comment lines and check for #ABORT
  lines = readlines(tmp_file)
  if any(match.(r"^\s*#\s*ABORT", lines) .!== nothing)
    @warn "Aborting due to #ABORT found"
    return
  end
  I = findall(match.(r"^\s*#", lines) .== nothing)
  write_issue(join(lines[I]))
end

function write_issue(msg)
  token = get(ENV, "GITHUB_AUTH", nothing)
  if token === nothing
    token = get(ENV, "GITHUB_TOKEN", nothing)
  end
  if token === nothing
    println("GITHUB_AUTH or GITHUB_TOKEN were not found.")
    print("Enter your GitHub token (will be visible): ")
    token = readline()
  end
  myauth = GitHub.authenticate(token)
  msg = Dict("body" => msg)
  GitHub.create_comment("abelsiqueira/TLDR.jl", 26, :issue, auth=myauth, params=msg)
end