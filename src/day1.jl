using DataFrames
using CSV
using CairoMakie

df = DataFrame(CSV.File("data/access-drinking-water-stacked.csv"))

rename!(df,Dict(:wat_sm=>"Safely managed",:wat_bas_minus_sm=>"Basic",:wat_lim=>"Limited",:wat_unimp=>"Unimproved",:wat_sur=>"No Access (surface water only)"))
filter!(row->row.Year == 2020 && row.Entity ∈ ["High income", "North America and Europe",
"Western Asia and Northern Africa",
"Upper-middle income",
"Latin America and the Caribbean",
"World",
"Central and Southern Asia",
"Lower-middle income",
"Sub-Saharan Africa",
"Low income"],df)
# show(df)

tbl = (x = df.Entity,
       height = [100 for _ in 1:10],
       grp = [1, 2, 3, 1, 2, 3, 1, 2, 3],
       )

o = repeat(df.Entity,10)

# barplot(tbl.x, tbl.height,
#         stack = tbl.grp,
#         color = tbl.grp,
#         axis = (xticks = (1:3, ["left", "middle", "right"]),
#                 title = "Stacked bars"),
#         )

height = df[:,["Safely managed","Basic","Limited","Unimproved","No Access (surface water only)"]]
println(height)
height = Matrix(height)
println(height)
# height = Matrix(height)[:]
# height  = vcat(height)
height = [i for i in hcat(height...)]
println(height)