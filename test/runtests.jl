using DataStructures
using TLDR
using JSON
using Test

include("output.jl")

function tests()
  @testset "Basic functionality" begin
    @test tldr("pkg:TLDR", false) == tldr("package:TLDR", false) == tldr_pkg("TLDR", false) == tldr_pkg_TLDR
    @test tldr("cmd:}", false) == tldr("command:}", false) == tldr("}", false) == tldr_snippet("}", false) == tldr_snippet_repl
    @test tldr("pkg:TLDR cmd:for", false) == tldr("cmd:for pkg:TLDR", false) == tldr_snippet_in("for", "TLDR", false) == tldr_search_for
    @test tldr("?", false) == tldr("help", false) == tldr_snippet_help
    @test tldr("?", true) === tldr("?") === tldr_pkg("TLDR") === tldr_snippet("?") === tldr_snippet_in("?", "TLDR") === nothing
  end

  @testset "Fuzzy Search" begin
    @test tldr_pkg("datafarmes", false) == tldr_pkg("DataFrames", false)
    @test tldr("pkg:datafarm4es", false) == tldr("pkg:DataFrames", false)
    @test tldr("bopxlot", false) == tldr("boxplot", false)
  end

  @testset "Data is sorted" begin
    p(x) = x["package"]
    o(x) = Dict("header" => 1, "snippet" => 2)[x["kind"]]
    ℓ(x) = length(x["description"])
    sorted_data = sort(sort.(deepcopy(TLDR.data)), by=x->(p(x),o(x),ℓ(x)))
    @test TLDR.data == sorted_data
    for (x,y) in zip(TLDR.data, sorted_data)
      sort!(y["tags"])
      for (p,q) in zip(x, y)
        @test p == q
      end
    end
  end

  @testset "Errors" begin
    @test_throws ErrorException("Unexpected number of actions. See tldr's help") tldr("pkg:Foo cmd:Bar cmd:FooBar")
    @test_throws ErrorException("Unexpected action what. See tldr's help") tldr("what:now")
    @test_throws ErrorException("Unexpected compound action `potato:... tomato:...`. Maybe you meant `pkg:tomato cmd:potato`?") tldr("potato:tomato tomato:potato")
    @test_throws ErrorException("kind \"wrong\" not accepted. It should be \"header\" or \"snippet\"") new_entry("", "wrong", "", "", [])
    @test_throws ErrorException("Please pass some tags.") new_entry("", "header", "", "", [])
    @test_throws ErrorException("For kind=\"header\", cmd should be \"\"") new_entry("", "header", "empty", "", ["tags"])
  end

  @testset "Creating data" begin
    original_data = deepcopy(TLDR.data)
    manual_data = deepcopy(TLDR.data)
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
    @test TLDR.data == manual_data
    for (x,y) in zip(TLDR.data, manual_data)
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
