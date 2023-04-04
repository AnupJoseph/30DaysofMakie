using DataFrames, JSONTables, HTTP, CairoMakie, StatsBase

r = HTTP.get("https://raw.githubusercontent.com/AnupJoseph/30DaysofMakie/main/data/endangered_sharks.json");

df = DataFrame(jsontable(r.body))
counts = countmap(df[!, :redlistCategory])
percentages = Dict()
for (key, value) in counts
    percentages[key] = round(value * 100 / length(df[!, :redlistCategory]))
end
println(percentages)

i = 0


xs = repeat(1:10, 10)
ys = repeat(1:10, inner=10)

points = Point2f.(xs, ys)
colors = zeros(100)

i = 1
state = 1
for (key, value) in percentages
    global state
    for _ in 1:value
        global i, state
        colors[i] = state
        i += 1
        if i > 100
            break
        end
    end
    state += 1

end
f = Figure()
ax = Axis(f[1, 1], yreversed=true,
    xautolimitmargin=(0.15, 0.15),
    yautolimitmargin=(0.15, 0.15), aspect=1
)
hidespines!(ax)
hidedecorations!(ax)
scatter!(points, marker=:rect, markersize=75, color=colors)