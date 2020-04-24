func explicit_runge_kutta<Vector: OdeVector, Tableau: ButchersTableau>(tableau: Tableau, 
                          ys: inout UnsafeMutableBufferPointer<Vector>, 
                          ts: Array<Vector.Scalar>, y0: Vector, 
                          dydx: @escaping (Vector, Vector.Scalar) -> Vector, 
                          tol: Vector.Scalar) -> Int where Vector.Scalar == Tableau.Scalar {
                                                                            
  typealias Scalar = Tableau.Scalar
  let stages = tableau.stages
  let dense_order = tableau.dense_order
  let order = tableau.order
  let a = tableau.a
  let p = tableau.p
  let c = tableau.c
  let b = tableau.b
  let b_hat = tableau.b_hat
  assert(c.last! == 1.0, "last c value must be 1.0")

  var y_hat_n = y0
  ys[0] = y0
  var it = 1
  var k: [Vector] = Array<Vector>(repeating: Vector(repeating: 0), count: stages)

  let N = ts.count 
  if (N == 0) {
    return 0
  }
  var t_n = ts[0]
  var h_n = ts[N - 1] - t_n
  var step_count = 0
  k[stages - 1] = dydx(y0, t_n)
  while (t_n < ts[N - 1]) { 
    var step_rejected = true 
    while (step_rejected) {
      //print("attempting step \(step_count) with it = \(it), h_n = \(h_n)")

      // reuse last k (we have asserted that the last c value is 1.0)
      let last_k_store = k[stages - 1]
      k[0] = k[stages - 1]
      for i in 1..<stages {
        var sum_ak = Vector(repeating: 0)     
        for j in 0..<i {
          sum_ak += a[i][j] * k[j]
        }
        k[i] = dydx(y_hat_n + h_n * sum_ak, t_n + c[i] * h_n)
      }

      // calculate final value and error
      var error = Vector(repeating: 0)
      var sum_bk = Vector(repeating: 0)
      for i in 0..<stages {
        sum_bk += b_hat[i] * k[i]
        error += (b_hat[i] - b[i]) * k[i]
      }
      let y_hat_np1 = y_hat_n + h_n * sum_bk

      // check if step is successful, i.e error is below set tolerance
      let E_hp1 = (h_n * error).inf_norm()
      if (E_hp1 < tol) {
        // if moved over any requested times then interpolate their values
        let t_np1 = t_n + h_n
        while (it < ts.count && t_np1 >= ts[it]) {
          let sigma = (ts[it] - t_n) / h_n
          var Phi = Vector(repeating: 0)
          for i in 0..<stages {
            var term = sigma 
            var b_i = term * p[i][0]
            for j in 1..<dense_order {
              term *= sigma
              b_i += term * p[i][j]
            }
            Phi += b_i * k[i]
          }
          ys[it] = y_hat_n + h_n * Phi 
          it += 1
        }

        // move to next step
        step_rejected = false
        y_hat_n = y_hat_np1
        t_n = t_np1
        step_count += 1
      } else {
        // failed step, reset last k back to stored value
        k[stages - 1] = last_k_store
      }
      
      // adapt step size
      h_n *= 0.9 * Scalar.pow(tol / E_hp1, 1.0/(Scalar(order) + 1.0))
    }
  }
  assert(it == ts.count)
  return it
}
