using CSV, DataFrames
using CairoMakie

df = DataFrame(CSV.File(raw"data/endangered_elephants.csv"))
rename!(df, "Asian elephant population (AsESG, 2019)" => "asian_elephants")
elephants = filter(row -> row.Entity == "India", df)
elephants = elephants[!, ["Entity", "Year", "asian_elephants"]]


k_suffix(x) = map(i -> i >= 10000 ? string(i)[1:2] * "K" : string(i)[1] * "K", x)
layout_color = "#e8edd9"
ys = [i for i in collect(elephants[!, :asian_elephants])]


f = Figure(backgroundcolor=layout_color,resolution=(1000,600))
ax = Axis(f[1, 1], yticks=8000:2000:30000, ytickformat=k_suffix, ygridcolor="white", ygridwidth=0.5, backgroundcolor=layout_color, xticks=1980:2017, xticklabelrotation=pi / 2, xgridvisible=false)
ylims!(8000, 30000)
hidespines!(ax)

scatterlines!(elephants[!, :Year], elephants[!, :asian_elephants], linewidth=5, color=ys,colormap=:Greens_9,markercolor="black",markersize=8)

CairoMakie.activate!(type = "png")
save("plots/flora_and_fauna.png",f)