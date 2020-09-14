# Jet

_A package for fast help and snippets._

## Work in progress, let me know your opinion

Expected interface:

```
julia> using Jet
julia> # Press }
jet>
```

Commands:

- `jet> topic` or `jet> snippet:topic`: Show snippets for a given `topic`
- `jet> pkg:SomePackage`: Show `SomePackage` Information and some snippets
- `jet> topic pkg:SomePackage`: Search for snippets for a given `topic` inside `SomePackage`.