# OdeInt

A swift implementation of explict runge-kutta ODE integration using the Dormond Price 
RK5(4) method, also known as the DOPRI method. This uses adaptive time-stepping, and 
dense output to the times specified by the user.

The original method is documented in [[1]](#1) as method 7M, and the dense output is 
documented in [[2]](#2), Section 4.

# Usage 

The protocol `OdeVector` defines a state vector to be used in the integration, and both 
the standard `SIMD` types as well as the `Double` and `Float`  types have been extended 
to conform to this protocol. Thus you can solve the ODE given by $dy/dx = -y$ with 
initial condition $y(0) = 1.0$ with the following:

```swift
let times = Array<Double>(stride(from: 0.0, through: 1.0, by: 0.001))
let results = Double.integrate(over: times, y0: 1.0, tol: 1e-6) { y, t in
  return -y
}
let solution = times.map { exp(-$0) }
assertEqual(solution, results, 1e-6)
```

Or you can solve the same ODE using a vector initial condition $y(0) = [1, 2]$ using:

```swift
let times = Array<Float>(stride(from: 0.0, through: 1.0, by: 0.001))
let results = SIMD2<Float>.integrate(over: times, y0: [1.0, 2.0], tol: 1e-6) { y, t in
  return -y
}
let solution = times.map { SIMD2(exp(-$0), 2 * exp(-$0)) }
assertEqual(solution, results, 1e-6)
```

# References
<a id="1">[1]</a> 
Dormand, J. R., & Prince, P. J. (1980). A family of embedded Runge-Kutta formulae. 
Journal of computational and applied mathematics, 6(1), 19-26.


<a id="2">[2]</a> 
Dormand, J. R., & Prince, P. J. (1986). Runge-Kutta triples. Computers & Mathematics 
with Applications, 12(9), 1007-1017.
