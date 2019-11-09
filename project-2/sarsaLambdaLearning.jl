function sarsaLambdaLearning(𝖲::Int, 𝖠::Int, dataset::DataFrame,
    α::Float64=0.9, γ::Float64=1.0, λ::Float64=0.9)

    # initialize Q and N
    Q = zeros(𝖲, 𝖠)
    N = zeros(𝖲, 𝖠)

    # loop over the dataset
    for i in 1:size(dataset)[1]

        if mod(i, 1000) == 0
            @show i
        end

        # if we are at the end of an episode, reset the counts for next episode
        # and skip the last sarsa iteration
        if i == size(dataset)[1] || dataset.sp[i] ≠ dataset.s[i+1]
            N = zeros(𝖲, 𝖠)
            continue
        end

        s   = dataset.s[i]
        a   = dataset.a[i]
        r   = dataset.r[i]
        sp  = dataset.s[i+1]
        ap  = dataset.a[i+1]

        N[s, a] += 1
        δ       =  r + γ*Q[sp, ap] - Q[s, a]

        # for s in 1:𝖲, a in 1:𝖠
        Q += α*δ*N
        N *= γ*λ

    end

    πInd = argmax(Q, dims=2)

    U = Q[πInd]
    π = collect(πInd[i][2] for i in 1:𝖲)

    return U, π

end
