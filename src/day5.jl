using CSV
using DataFrames
using CairoMakie



df = DataFrame(CSV.File("data/population-and-demography.csv"))
rename!(df, Dict("Country name" => "country"))
populations = df[!, ["country", "Year", "Population"]]
filter!(row -> row.Year ∈ [1950, 2021] && row.country ∈ ["United States", "India", "China", "India", "Russia", "Nigeria", "Bangladesh", "Brazil", "Indonesia", "Mexico", "Pakistan"], populations)
populations = unstack(populations, :Year, :Population)

# show(populations)
f = Figure(fonts=(; body="fonts/Cabin-VariableFont_wdth,wght.ttf", weird="fonts/Outfit-Bold.ttf"), resolution=(600, 1000))
ax = Axis(f[1, 1], title="POPULATION", subtitle="Slope graph displaying the world's top\n 10 countries in terms of population\n growth from 1950 to 2021", titlealign=:left, titlefont=:weird, titlesize=70, subtitlegap=10, subtitlefont=:body, subtitlesize=30)
lines!([1950 for i = 1:7000], 1:100000:700000000, color="black", linewidth=0.5)
lines!([2021 for i = 1:15000], 1:100000:1500000000, color="black", linewidth=0.5)


for row in eachrow(populations)
    country = row.country
    ys = Vector(row[2:end])

    scatterlines!([1950, 2021], ys, linewidth=3)
end
hidespines!(ax)
hidedecorations!(ax)

f