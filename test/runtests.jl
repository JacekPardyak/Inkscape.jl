using Inkscape
using Test

@testset "Inkscape.jl" begin
    @test Inkscape.greet_your_package_name() == "Hello Inkscape!"
    @test Inkscape.greet_your_package_name() != "Hello world!"
end
end
