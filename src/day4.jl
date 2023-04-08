using CairoMakie
using CSV, DataFrames

df = DataFrame(CSV.File("./data/total-ghg-emissions.csv"))

countries = ["China", "United States", "India", "Russia", "Japan", "Iran", "Germany"]
c_order(x) = Dict(((key, i) for (i, key) in enumerate(countries)))[x]
colors = ["#519795", "#fbb555", "#d45334", "#5cbbb3", "#446a74", "#dd735c", "#353638"]

rename!(df, Dict("Annual greenhouse gas emissions" => "emissions"))
filter!(row -> row.Year >= 1950 && row.Entity ∈ countries, df)
sort!(df, order(:Entity, by=c_order))

y = Matrix(unstack(df, :Year, :emissions)[!, 3:end])
stacked = cumsum(y, dims=1)

println(size(stacked))


xs = 1950:2021

m = 7
first_line = -sum(y, dims=1) * 0.5
stacked .+= first_line
upper_bound = vec(stacked[1, :])

f = Figure(resolution=(850, 1000))
# Legend(f[1, 1], [PolyElement(color=color, strokecolor=:transparent)
#                  for color in colors], countries)

ax = Axis(f[1, 1],xgridvisible=true)
hidedecorations!(ax)
hidespines!(ax)
band!(xs, vec(first_line), upper_bound, color=colors[1])
axislegend(ax, [PolyElement(color=color, strokecolor=:transparent) for color in colors], countries, position=:lt,framevisible=false)

for i in 2:7
    global stacked
    band!(xs, stacked[i-1, :], stacked[i, :], color=colors[i])
end
f

CairoMakie.activate!(type = "png")
save("plots/historical.png",f)