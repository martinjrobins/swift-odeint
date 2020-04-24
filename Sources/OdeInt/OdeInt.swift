import Numerics

extension OdeVector {

static func integrate(over ts: Array<Self.Scalar>, y0: Self, tol: Self.Scalar,
               dydx: @escaping (Self, Self.Scalar) -> Self) -> Array<Self> {
  let n = ts.count
  return Array<Self>(unsafeUninitializedCapacity: n) { buffer, initializedCount in
    initializedCount = explicit_runge_kutta(tableau: DormondPrice<Scalar>(), ys: &buffer, ts:
                                            ts, y0: y0, dydx: dydx, tol: tol)
  }
}

}

