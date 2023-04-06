using CSV, DataFrames
using CairoMakie

df = DataFrame(CSV.File(raw"data/endangered_elephants.csv"))
rename!(df, "Asian elephant population (AsESG, 2019)" => "asian_elephants")
elephants = filter(row -> row.Entity == "India", df)
elephants = elephants[!, ["Entity", "Year", "asian_elephants"]]

y_tick_format(x) = string(x) * "K"
ytick_labels = y_tick_format.(8:2:30)

f = Figure()
Axis(f[1, 1], yticks=ytick_labels)
lines!(elephants[!, :Year], elephants[!, :asian_elephants])
f
# elephants = df[,:]