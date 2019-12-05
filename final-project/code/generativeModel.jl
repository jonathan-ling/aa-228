function generativeModel(p::multiFareDynamicPricingProblem, f::Symbol,
    ticketsAvailable::Int, t::Int, a::Real, customersWithoutTicketsByFareClass::Set)

    # Initialize variables
    ticketsSold = 0   # u

    fareClass = p.fareClasses[f]
    customerArrivalDistribution = Poisson(fareClass.customerArrivalSlope*(p.timeHorizon - t) + fareClass.customerArrivalIntercept) # n-distribution
    wtpThresholdDistribution    = Normal( fareClass.wtpThresholdMean,         fareClass.wtpThresholdStandardDeviation)             # w-distribution
    wtpFlexibilityDistribution  = Uniform(fareClass.wtpFlexibilityLowerBound, fareClass.wtpFlexibilityUpperBound)                  # k-distribution

    # Sample the number of new customers from the Poisson distribution
    newCustomers = rand(customerArrivalDistribution) # n

    # @show newCustomers

    # Add new customers for this time step
    for newCustomer in 1:newCustomers

        # get WTP parameters
        wtpThreshold   = rand(wtpThresholdDistribution  ) # w
        wtpFlexibility = rand(wtpFlexibilityDistribution) # k

        c = customer(wtpThreshold, wtpFlexibility)
        push!(customersWithoutTicketsByFareClass, c)

    end

    # Check to see which customers will purchase tickets

    customersWithPurchase = Set{customer}()

    for c in deepcopy(customersWithoutTicketsByFareClass)

        # Compute the purchase probability and sample from its Bernoulli distribution
        purchaseProbability  = a <= c.wtpThreshold ? 1 :
                ccdf(Logistic(c.wtpThreshold, c.wtpFlexibility), a) # ϕ value
        purchaseDistribution = Bernoulli(purchaseProbability)
        purchase             = Bool(rand(purchaseDistribution))

        if purchase

            ticketsSold += 1
            push!(customersWithPurchase, c)

        end
    end

    # Calculate current reward
    revenue = a * ticketsSold

    # Return results
    return ticketsAvailable - ticketsSold, ticketsSold, revenue, newCustomers,
                customersWithoutTicketsByFareClass, customersWithPurchase

end
