using DataStructures
using Jet
using JSON
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
    o(x) = Dict("header" => 1, "snippet" => 2)[x["kind"]]
    ℓ(x) = length(x["description"])
    sorted_data = sort(sort.(deepcopy(Jet.data)), by=x->(p(x),o(x),ℓ(x)))
    @test Jet.data == sorted_data
    for (x,y) in zip(Jet.data, sorted_data)
      sort!(y["tags"])
      for (p,q) in zip(x, y)
        @test p == q
      end
    end
  end

  @testset "Creating data" begin
    original_data = deepcopy(Jet.data)
    manual_data = deepcopy(Jet.data)
    new_pkg("FAKE", "FAKE description", ["A", "B"])
    new_snippet("FAKE", "1 = 0", "FAKE snippet", ["C", "D"])
    new_snippet("1 < 0", "Another FAKE snippet", ["C", "E"])
    push!(manual_data, OrderedDict(
      "command" => "",
      "description" => "FAKE description",
      "kind" => "header",
      "package" => "FAKE",
      "tags" => ["A", "B"]
    ))
    push!(manual_data, OrderedDict(
      "command" => "1 = 0",
      "description" => "FAKE snippet",
      "kind" => "snippet",
      "package" => "FAKE",
      "tags" => ["C", "D"]
    ))
    push!(manual_data, OrderedDict(
      "command" => "1 < 0",
      "description" => "Another FAKE snippet",
      "kind" => "snippet",
      "package" => "",
      "tags" => ["C", "E"]
    ))
    p(x) = x["package"]
    o(x) = Dict("header" => 1, "snippet" => 2)[x["kind"]]
    ℓ(x) = length(x["description"])
    sort!(manual_data, by=x->(p(x),o(x),ℓ(x)))
    @test Jet.data == manual_data
    for (x,y) in zip(Jet.data, manual_data)
      for (p,q) in zip(x, y)
        @test p == q
      end
    end
    # Writing back the correct data
    open(joinpath(@__DIR__, "..", "data.json"), "w") do io
      JSON.print(io, original_data, 2)
    end
  end
end

tests()