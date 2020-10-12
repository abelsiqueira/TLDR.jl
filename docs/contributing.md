@def title = "TLDR"
@def tags = ["syntax", "code"]
@def hascode = true
@def lang = "julia"

# Contributing

**Help us create the database!**

While working, if you find a snippet that you think will be useful, simply enter `submit()`.
Same thing for a new package header.
You'll be asked for all information interactively.

*Be aware that we'll use your GitHub credentials*, so if you don't want to be associated with the likes of us, you better stop now.

Here's an example:

```julia-repl
julia> TLDR.submit()
┌ Warning: TLDR uses your GitHub credentials to post on GitHub.
│
│   #######################################
│   #  If you don't want that, stop now!  #
│   #######################################
│
│ You can write the issue on GitHub directly here:
│     https://github.com/abelsiqueira/TLDR.jl/issues/26
└ @ TLDR ~/projetos/TLDR.jl/src/submit.jl:4
kind (snippet or header): snippet
command (use \n to split lines): mkdir("dir")
package:
description (shorter is better): Create folder "dir"
tag (leave empty to end): folder
tag (leave empty to end): path
tag (leave empty to end):
```

This creates a tasty comment on [abeliqueira/TLDR.jl](https://github.com/abelsiqueira/TLDR.jl): Click [here](https://github.com/abelsiqueira/TLDR.jl/issues/26#issuecomment-889567902) to see.

```plaintext
GitHub.Comment (all fields are Union{Nothing, T}):
  body: "{\n  \"kind\": \"snippet\",\n  \"command\": \"mkdir(\\\"dir\\\")\",\n  \"package\": \"\",\n  \"tags\": [\n    \"folder\",\n    \"path\"\n  ],\n  \"description\": \"Create folder \\\"dir\\\"\"\n}\n"
  id: 889567902
  created_at: DateTime("2021-07-30T01:45:24")
  updated_at: DateTime("2021-07-30T01:45:24")
  url: URI("https://api.github.com/repos/abelsiqueira/TLDR.jl/issues/comments/889567902")
  html_url: URI("https://github.com/abelsiqueira/TLDR.jl/issues/26#issuecomment-889567902")
  issue_url: URI("https://api.github.com/repos/abelsiqueira/TLDR.jl/issues/26")
  user: Owner("abelsiqueira")
```

From that comment, an automatic pull request is created. Click [here](https://github.com/abelsiqueira/TLDR.jl/pull/30) to see it.
You should be tagged on the pull request.

**You can edit the comment to fix any mistakes!**

### Wait a minute, can't this be abused?

Probably. Help is needed making sure it isn't.

### What about repeated/similar entries?

Also an issue. Ideal here would be a fuzzy search for the pull request information so it's easier to verify.

## Advanced

If you want to create entries directly, you can use commands below.
Notice that you'll need to follow the usual steps of forking, and creating a pull request to submit your entries.

*Note: We use `rebase` and `squash` merges, so `fetch` this repo from time to time and update your `main` branch related to this one. Always branch from `main`.*

### `new_pkg(pkg, description, tags)`

Create a new entry for `pkg` using the `description` and some `tags`.

### `new_snippet([pkg=""], cmd, description, tags)`

Create a new entry (that can be associated to a `pkg`) for a snippet `cmd`.

