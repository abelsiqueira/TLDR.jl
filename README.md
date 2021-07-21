# TLDR

_A package for fast help and snippets._

TLDR means Too Long, Didn't Read. This package is inspired by [tldr-pages](https://tldr.sh), but focused on Julia. They probably don't overlap.

[![CI](https://github.com/abelsiqueira/TLDR.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/abelsiqueira/TLDR.jl/actions/workflows/ci.yml)
[![Coveralls](https://img.shields.io/coveralls/abelsiqueira/TLDR.jl.svg?style=flat-square)](https://coveralls.io/github/abelsiqueira/TLDR.jl?branch=main)
[![GitHub](https://img.shields.io/github/release/abelsiqueira/TLDR.jl.svg?style=flat-square)](https://github.com/abelsiqueira/TLDR.jl/releases)


**Work in progress, let me know your opinion**

```julia
julia> using TLDR
julia> tldr_repl()
julia> # Press }
tldr>
```

Can also be used with `tldr(str)` or `tldr"str"`.

## Actions

### `tldr> pkg:something`

Returns all snippets associated with package `something`.

```
tldr> pkg:DataFrames
DataFrames

Tools for working with tabular data.

- Create a new DataFrame by passing the column headers and contents
  `df = DataFrame(A = 1:3, B = [:odd, :even, :odd])`
```

Instead of `pkg`, `package` can also be used.

### `tldr> cmd:something`

```
tldr> cmd:chol
- Solve a linear system `Ax = b` using the Cholesky factorization
  `F = cholesky(A)
  F \ b`
```

Instead of `cmd`, `command` or `snippet` can also be used. The argument can also be ignored.

### `tldr> ?`

Same as `pkg:TLDR`.

```
tldr> cmd:?
TLDR

A package for fast help and snippets.

- Enter `tldr>` mode.
  `}`

- Search for commands and packages related to the `keyword`.
  `tldr"keyword"`
```

## Contributing

The main need of the package right now is to create a useful database. For that, we have created a couple of commands:

### `new_pkg(pkg, description, tags)`

Create a new entry for `pkg` using the `description` and some `tags`.

### `new_snippet([pkg=""], cmd, description, tags)`

Create a new entry (that can be associated to a `pkg`) for a snippet `cmd`.

### Short guide

- Fork this repo
- Clone your repo, create a branch for your contribution(s)
- Go inside, run `julia --project`
- Instantiate the project: `]` becomes `pkg>`, then `pkg> instantiate`
- `using TLDR`
- Use `new_pkg` or `new_snippet`
- Commit with a message like "New package: ..." or "New snippet for how to ..."
- Push to your repo, and create a PR to our `main` branch

You can watch a asciinema recording below (But I forgot to commit):

[![asciicast](https://asciinema.org/a/362685.svg)](https://asciinema.org/a/362685)

Note: We use `rebase` and `squash` merges, so `fetch` this repo from time to time and update your `main` branch related to this one. Always branch from `main`.