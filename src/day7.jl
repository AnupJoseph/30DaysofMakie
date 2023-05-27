using DataFrames
using CSV
using CairoMakie

df = DataFrame(CSV.File("data/disasters_dataset.csv"))
disasters = df[!, ["Year", "Disaster Group", "Disaster Type", "Country", "Total Deaths"]]

target_disasters = ["Volcanic activity", "Storm", "Landslide", "Flood", "Extreme temperature", "Earthquake", "Drought"]
filter!(row -> row."Disaster Group" == "Natural" && row."Disaster Type" ∈ target_disasters && !ismissing(row."Total Deaths"), disasters)
f = Figure()
ax = Axis(f[1, 1])

for (i, d) in enumerate(target_disasters)
    curr_ds = filter(row -> row."Disaster Type" == d, disasters)
    x = 1950:2020
    y = repeat([i * 100000000], length(curr_ds.Year))
    scatter!(curr_ds.Year, y, markersize=log.(curr_ds."Total Deaths"))
end
# show(disasters)
f