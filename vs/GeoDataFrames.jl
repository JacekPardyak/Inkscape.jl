using DataFrames
import GeoDataFrames as GDF
coords = zip(rand(10), rand(10))
df = DataFrame(geometry=createpoint.(coords), name="test");
GDF.write("./vs/test_points.shp", df)
