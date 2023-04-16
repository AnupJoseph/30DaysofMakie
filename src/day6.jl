using CSV
using DataFrames
using CairoMakie

expectancy = DataFrame(CSV.File("data/life-expectancy-of-women-vs-life-expectancy-of-women.csv"))
rename!(expectancy, Dict("Estimates, 1950 - 2020: Annually interpolated demographic indicators - Life expectancy at birth, females (years)" => "female_life_expectancy", "Estimates, 1950 - 2020: Annually interpolated demographic indicators - Life expectancy at birth, males (years)" => "male_life_expectancy"))
asia_countries = ["Afghanistan", "Bahrain", "Bangladesh", "Bhutan", "Brunei", "Cambodia", "China", "Cyprus", "Georgia", "India", "Indonesia", "Iran", "Iraq", "Israel", "Japan", "Jordan", "Kazakhstan", "Kuwait", "Kyrgyzstan", "Laos", "Lebanon", "Malaysia", "Maldives", "Mongolia", "Myanmar", "Nepal", "North Korea", "Oman", "Pakistan", "Palestine", "Philippines", "Qatar", "Russia", "Saudi Arabia", "Singapore", "South Korea", "Sri Lanka", "Syria", "Taiwan", "Tajikistan", "Thailand", "Timor-Leste", "Turkey", "Turkmenistan", "United Arab Emirates", "Uzbekistan", "Vietnam", "Yemen"]



filter!(row -> row.Year == 2020 && !ismissing(row.Code) && !ismissing(row.female_life_expectancy) && !ismissing(row.male_life_expectancy) && row.Entity != "World", expectancy)


# show(expectancy)
function arcplot()
    f = Figure(fonts=(; body="fonts/Cabin-VariableFont_wdth,wght.ttf", weird="fonts/Outfit-Bold.ttf"), resolution=(800, 1000))
    ax = Axis(f[1, 1], backgroundcolor=:black, title="Life Expectancy by Sex", subtitle="In every country the life expectancy of women is higher than the life expectancy of men", titlecolor=:white, titlesize=60, titlefont=:weird, titlealign=:left, subtitlefont=:body, subtitlesize=20)

    for row in eachrow(expectancy)
        male_color = row.Entity == "India" ? "#57cc42" : "#a2a1a1"
        female_color = row.Entity == "India" ? "#b22fb1" : "#a2a1a1"
        row_vec = Vector(row)

        arc!(Point2f(row[4], -3), row[4], 0, -π, color=female_color)
        arc!(Point2f(row[5], 3), row[5], 0, π, color=male_color)
    end
    hidespines!(ax)
    hidedecorations!(ax)
    f
end

fig = with_theme(arcplot, theme_black())
CairoMakie.activate!(type = "png")
save("plots/historical.png",fig)
