function getPolicy(p::MultiFareDynamicPricingProblem, Q::Array)

   # Initialize state space
   stateSpace, 𝖲  = stateSpaceAttributes(p)
   actionSpace, _  = actionSpaceAttributes(p)

   # Extract joint policy
   policyIndices = argmax(Q, dims=2)

   U             = Q[policyIndices]
   jointPolicy   = [policyIndices[s][2] - 6*( sum(Q[s,:]) == 0 ) for s in 1:𝖲]

   # Return joint policy, value function and size of ticketsAvailable space
   return jointPolicy, U, p.totalTickets + 1

end
