#import Pkg; Pkg.add(["ArchGDAL", "DataFrames", "Pipe", "GeoDataFrames", "Luxor"])
add https://github.com/evetion/GeoDataFrames.jl
using Plots, ArchGDAL, DataFrames, Pipe, Printf, GeoDataFrames

function svg2dxf(url)
  svg = tempname() * ".svg"
  download(url, svg)
  inkscape = "inkscape"
  command = "--system-data-directory"
  path = read(`$inkscape $command`, String)
  path = replace(path, "\n"=>"")
  inkscape_python_home  = replace(path, "\\share\\inkscape"=>"") * "\\bin"
  inkscape_extension_name = "dxf12_outlines.py"
  inkscape_extension_path = path * "\\extensions\\" * inkscape_extension_name 
  dxf = tempname() * ".dxf"
  bat = tempname() * ".bat"
  text = @sprintf "@ECHO OFF \n cd \"%s\" \n python.exe \"%s\" --output=\"%s\" \"%s\"\n" inkscape_python_home inkscape_extension_path dxf svg
  text
  open(bat, "w") do file
    write(bat, text)
  end
  run(`$bat`)
  replace(dxf, "\\"=>"//")
end

@pipe "https://upload.wikimedia.org/wikipedia/commons/1/1f/Julia_Programming_Language_Logo.svg" |>
  svg2dxf(_) |> 
  ArchGDAL.read(_) |>
  ArchGDAL.getlayer(_, 0) |>
  DataFrame(_) |> 
  _.""  |>
  DataFrame(geometry=_) #|> GeoDataFrames.write("output.geojson", _)

