using DataFrames, JSONTables, HTTP, CairoMakie, StatsBase, ColorSchemes

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

order = ["Critically Endangered", "Endangered", "Vulnerable", "Near Threatened", "Least Concern", "Data Deficient"]
i = 1
state = 1
for key in order
    global state
    for _ in 1:percentages[key]
        global i, state
        colors[i] = state
        i += 1
        if i > 100
            break
        end
    end
    state += 1

end
f = Figure(aspect=1)
ax = Axis(f[1:3, 1:3], yreversed=true,
    xautolimitmargin=(0.15, 0.15),
    yautolimitmargin=(0.15, 0.15),aspect=1
)
hidespines!(ax)
hidedecorations!(ax)


scatter!(points, marker=:rect, markersize=55, color=colors, colormap=Reverse(:OrRd_7))
elements = [PolyElement(polycolor=reverse(colorschemes[:OrRd_7])[i]) for i in 1:length(order)]
l = Legend(f[4, 2], elements, order, framevisible=false)
CairoMakie.activate!(type = "png")
save("plots/waffle.png",f)