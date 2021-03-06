# Example 3.77 and 3.79 of
# Blekherman, G., Parrilo, P. A., & Thomas, R. R. (Eds.).
# Semidefinite optimization and convex algebraic geometry SIAM 2013
@testset "Example 3.77 and 3.79 with $solver" for solver in sdp_solvers
    @polyvar x
    P = [x^2-2x+2 x; x x^2]
    # Example 3.77
    m = SOSModel(solver=solver)
    @polyconstraint m P >= 0
    status = solve(m)
    @test status == :Optimal
    # Example 3.79
    @polyvar y[1:2]
    M = SOSModel(solver=solver)
    @polyconstraint M dot(y, P*y) >= 0
    status = solve(M)
    @test status == :Optimal
end
