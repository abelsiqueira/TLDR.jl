@def title = "TLDR"
@def tags = ["syntax", "code"]
@def hascode = true
@def lang = "julia"

# TLDR.jl

TLDR provides a easy way to find Julia snippets.

\tableofcontents <!-- you can use \toc as well -->

## Usage

```julia-repl
julia> using TLDR
julia> tldr_repl()
julia> # press }
tldr>
```

You can also use `tldr("...")` or `tldr"..."` to enter these comments.

### `tldr> something`

```julia-repl
tldr> data
```

```julia:./usage1.jl
# hideall
using TLDR
lines = split(tldr("data", false), "\n")
println(join(lines[1:10], "\n"))
println("...")
```

\output{./usage1.jl}

### `tldr> pkg:something`

Returns all snippets associated with package `something`.

```julia-repl
tldr> pkg:CSV
```

```julia:./usage2.jl
# hideall
using TLDR
lines = split(tldr("pkg:CSV", false), "\n")
println(join(lines[1:10], "\n"))
println("...")
```

\output{./usage2.jl}

Instead of `pkg`, `package` can also be used.

### `tldr> cmd:something`

```julia-repl
tldr> cmd:chol
```

```julia:./usage3.jl
# hideall
using TLDR
lines = tldr("cmd:chol", false)
println(lines)
```

\output{./usage3.jl}

Instead of `cmd`, `command` or `snippet` can also be used. The argument can also be ignored.

### `tldr> ?`

Same as `pkg:TLDR`.

```julia-repl
tldr> ?
```

```julia:./usage1.jl
# hideall
using TLDR
tldr("?", false) |> println
```

\output{./usage1.jl}
