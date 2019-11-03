using CSV
using DataFrames
using Plots
using Printf

include("inferTransitionAndReward.jl")

# load the dataset
dataset = CSV.read("data/large.csv")

# compute state space and action space
𝒮  = collect(1:320000) #312020
𝒜  = collect(1:9)
𝖲  = size(𝒮)[1]
𝖠  = size(𝒜)[1]

T, R = inferTransitionAndReward(dataset, 𝖲, 𝖠)

