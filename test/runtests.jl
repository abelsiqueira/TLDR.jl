using Jet
using Test

function tests()
  @testset "Basic functionality" begin
    @test jet("jet", false) == """Jet

A package for fast help and snippets.

- Enter `jet>` mode.
  `?`

- Search for commands and packages related to the `keyword`.
  `jet"keyword"`

"""
  end

  @testset "Data is sorted" begin
    pkg(x) = x["package"]
    type_order(x) = Dict("header" => 1, "command" => 2)[x["type"]]
    desclen(x) = length(x["description"])
    sorted_data = sort(Jet.data, by=x->(pkg(x),type_order(x),desclen(x)))
    @test Jet.data == sorted_data
  end
end

tests()