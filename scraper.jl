#!/usr/bin/env julia

#= To perform web scraping, Julia offers three libraries for the job, and these are Cascadia.jl, Gumbo.jl and HTTP.jl. HTTP.jl is used to download the frontend source code of the website, which then is parsed by Gumbo.jl into a hierarchical structured object and Cascadia.jl provides a CSS selector API for easy navigation. =#

using Cascadia
using DataFrames
using Gumbo
using HTTP
using Dates
using JLD

url = "https://www.erzgebirgskreis.de/index.php?id=1126" 
res = HTTP.get(url) 

body = String(res.body) 

html = parsehtml(body)

qres = eachmatch(sel"td", html.root)

#= Initialize an empty string array: =#
arr = String[]

for elem in qres
    #= println(replace(text(elem[1]), r"\n|\t|\s" => s"")) =#
    push!(arr, replace(text(elem[1]), r"\n|\t|\s" => s""))
end

#= print(arr) =#
#= print(qres) =#

currentDate = Dates.now()
newFile = "$currentDate-data.jld"
save(newFile, "data", arr)
