using Jet
using Test

function tests()
  @testset "Basic functionality" begin
    @test jet("pkg:Jet", false) == jet_pkg("Jet", false) == """Jet

A package for fast help and snippets.

- Enter `jet>` mode.
  `}`

- Search for commands and packages related to the `keyword`.
  `jet"keyword"`

"""

    @test jet("cmd:}", false) == jet_snippet("}", false) == """- Enter `jet>` mode.
  `}`

"""
  end

  @testset "Data is sorted" begin
    p(x) = x["package"]
    o(x) = Dict("header" => 1, "command" => 2)[x["kind"]]
    ℓ(x) = length(x["description"])
    sorted_data = sort(sort.(Jet.data), by=x->(p(x),o(x),ℓ(x)))
    @test Jet.data == sorted_data
    for (x,y) in zip(Jet.data, sorted_data)
      for (p,q) in zip(x, y)
        @test p == q
      end
    end
  end
end

tests()