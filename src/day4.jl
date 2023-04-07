using CairoMakie
using CSV, DataFrames

df = DataFrame(CSV.File("./data/total-ghg-emissions.csv"))

countries = ["China", "United States", "India", "Russia", "Japan", "Iran", "Germany"]
rename!(df, Dict("Annual greenhouse gas emissions" => "emissions"))
filter!(row -> row.Year >= 1950 && row.Entity ∈ countries, df)

xs = 1950:2021
lower_ys = filter(row -> row.Entity == countries[1], df).emissions
upper_ys = lower_ys .+ lower_ys

f = Figure()
ax = Axis(f[1, 1])
hidedecorations!(ax)
hidespines!(ax)
band!(xs, lower_ys, upper_ys)
for i in 2:7
    global lower_ys, upper_ys, xs
    lower_ys = upper_ys
    upper_ys = lower_ys .+ filter(row -> row.Entity == countries[i], df).emissions
    band!(xs, lower_ys, upper_ys)
end

CairoMakie.activate!(type = "png")
save("plots/historical.png",f)