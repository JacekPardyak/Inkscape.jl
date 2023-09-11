import Pkg; Pkg.add(["ArchGDAL", "DataFrames", "Pipe", "GeoDataFrames", "Luxor"])
using Plots, ArchGDAL, DataFrames, Pipe, Printf, GeoDataFrames, Luxor

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
  text = @sprintf "ECHO OFF \ncd \"%s\" \npython.exe \"%s\" --output=\"%s\" \"%s\"\n" inkscape_python_home inkscape_extension_path dxf svg
  text
  open(bat, "w") do file
    write(bat, text)
  end
  run(`$bat`)
  replace(dxf, "\\"=>"//")
end

function make_poly(x, s, e)
  local res =  ArchGDAL.createlinestring()
  for i in s:e
    res = ArchGDAL.union(res, x[i, "geometry"])
  end
  res = ArchGDAL.polygonize(res)
#  res = ArchGDAL.getgeom(res, 0)
  res
end

df = @pipe "https://upload.wikimedia.org/wikipedia/commons/2/26/Nicolaus_Copernicus_Signature.svg" |>
  svg2dxf(_) |> 
  ArchGDAL.read(_) |>
  ArchGDAL.getlayer(_, 0) |>
  DataFrame(_) |> 
  _.""  |>
  DataFrame(geometry=_)
df
@pipe df |> GeoDataFrames.write("out.shp", _, geom_column = :geometry)