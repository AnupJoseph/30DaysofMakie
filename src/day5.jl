using CSV
using DataFrames
using CairoMakie

df = DataFrame(CSV.File("data/league_table.csv"))

df[!, :Year] = repeat(2022:-1:2018, inner=20)
ranked = unstack(df[!, [:Squad, :Year, :Rk]], :Year, :Rk)
# show(ranked)


f = Figure()
Axis(f[1, 1])


for row in eachrow(ranked)

    x = 2018:2022
    y = 21 .- reverse!(collect(row[2:end]))

    scatterlines!(x,y)
end

f
CairoMakie.activate!(type = "png")
save("plots/slope.png",f)