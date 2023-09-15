using Inkscape
using Test

@testset "Inkscape.jl" begin
    @test Inkscape.inx_install() != "Hello Inkscape!"
    @test Inkscape.inx_version() != "Hello Inkscape!"
    @test Inkscape.inx_version() != "Hello world!"
end