# Adapted from:
# SOSDEMO10 --- Set containment
# Section 3.10 of SOSTOOLS User's Manual

@testset "SOSDEMO10 with $solver" for solver in sdp_solvers
  @polyvar x1 x2
  x = [x1, x2]

  eps = 1e-6
  p = x1^2+x2^2
  gamma = 1
  g0 = 2*x1
  theta = 1

  m = SOSModel(solver = solver)

  # FIXME s should be sos ?
  # in SOSTools doc it is said to be SOS
  # but in the demo it is not constrained so
  Z = monomials(x, 0:4)
  @polyvariable m s Z

  Z = monomials(x, 2:3)
  @polyvariable m g1 Z

  Sc = [theta^2-s*(gamma-p) g0+g1; g0+g1 1]

  @polyconstraint m eps * eye(2) ⪯ Sc

  status = solve(m)

  # Program is feasible, { x |((g0+g1) + theta)(theta - (g0+g1)) >=0 } contains { x | p <= gamma }
  @test status == :Optimal || (iscsdp(solver) && status == :Suboptimal)

  #@show getvalue(s)
  #@show getvalue(g1)
end
