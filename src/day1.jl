using DataFrames
using CSV
using CairoMakie
# using FileIO

df = DataFrame(CSV.File("data/access-drinking-water-stacked.csv"))

rename!(df, Dict(:wat_sm => "Safely managed", :wat_bas_minus_sm => "Basic", :wat_lim => "Limited", :wat_unimp => "Unimproved", :wat_sur => "No Access (surface water only)"))
filter!(row -> row.Year == 2020 && row.Entity ∈ ["High income", "North America and Europe",
              "Western Asia and Northern Africa",
              "Upper-middle income",
              "Latin America and the Caribbean",
              "World",
              "Central and Southern Asia",
              "Lower-middle income",
              "Sub-Saharan Africa",
              "Low income"], df)

tbl = (x=df.Entity,
       height=[100 for _ in 1:10],
       grp=[1, 2, 3, 1, 2, 3, 1, 2, 3],
)

x = repeat(1:10, inner=5)



height = df[:, ["Safely managed", "Basic", "Limited", "Unimproved", "No Access (surface water only)"]]
height = collect(Iterators.flatten(eachrow(height)))
grp = repeat(1:5, 10)

label_maker(x) = x > 10 ? "$x" : ""
labels = floor.(Int, height)
labels = label_maker.(labels)

f = Figure()
ax1 = Axis(f[1, 1], yticks=(1:10, df.Entity),
       title="Only 29% have access to safe drinking water in Low Income Countries, 2020", xticks=(1:100, ["" for i = 1:100]))
hidespines!(ax1)
hidexdecorations!(ax1)
barplot!(x, height,
       stack=grp,
       color=grp,
       direction=:x,
       bar_labels=labels,
       label_offset=-30,
)
f
# CairoMakie.activate!(type = "png")
# save("plots/part_of_whole.png",fig)