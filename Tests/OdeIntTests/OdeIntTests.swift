import XCTest
@testable import OdeInt

final class OdeIntTests: XCTestCase {
    func testScalarDouble() {
      let times = Array<Double>(stride(from: 0.0, through: 1.0, by: 0.001))
      let results = Double.integrate(over: times, y0: 1.0, tol: 1e-6) { y, t in
        return -y
      }
      let solution = times.map { exp(-$0) }
      assertEqual(solution, results, 1e-6)
    }

    func testScalarFloat() {
      let times = Array<Float>(stride(from: 0.0, through: 1.0, by: 0.001))
      let results = Float.integrate(over: times, y0: 1.0, tol: 1e-6) { y, t in
        return -y
      }
      let solution = times.map { exp(-$0) }
      assertEqual(solution, results, 1e-6)
    }

    func testSimdVectorFloat() {
      let times = Array<Float>(stride(from: 0.0, through: 1.0, by: 0.001))
      let results = SIMD2<Float>.integrate(over: times, y0: [1.0, 2.0], tol: 1e-6) { y, t in
        return -y
      }
      let solution = times.map { SIMD2(exp(-$0), 2 * exp(-$0)) }
      assertEqual(solution, results, 1e-6)
    }

    func testSimdVector4Double() {
      let times = Array<Double>(stride(from: 0.0, through: 1.0, by: 0.001))
      let results = SIMD4<Double>.integrate(over: times, y0: [1.0, 2.0, 3.0, 4.0], tol: 1e-6) { y, t in
        return -y
      }
      let solution = times.map { SIMD4<Double>(exp(-$0), 2 * exp(-$0), 3 * exp(-$0), 4 * exp(-$0)) }
      assertEqual(solution, results, 1e-6)
    }

    func assertEqual<Vector: OdeVector>(_ expression1: Array<Vector>, _ expression2:
                                   Array<Vector>, _ accuracy: Vector.Scalar) {
      XCTAssertEqual(expression1.count, expression2.count, "arrays not equal in size")
      var error_counter = 0
      let max_errors = 4
      for i in 0..<expression1.count {
        let arg1 = expression1[i]
        let arg2 = expression2[i]
        let max_error = (arg2 - arg1).inf_norm()
        if (max_error > accuracy) {
          error_counter += 1
          let error_string = "|\(arg1) - \(arg2)| > \(accuracy) at index \(i)."
          if (error_counter == max_errors) {
            XCTFail(error_string + " Futher errors suppressed...")
          } else if (error_counter < max_errors) {
            XCTFail(error_string)
          }
        }
      }
      if (error_counter > 0) {
        XCTFail("In total, \(error_counter) elements failed the accuracy test")
      }
    }

    static var allTests = [
        ("testScalarDouble", testScalarDouble),
        ("testScalarFloat", testScalarFloat),
        ("testSimdVectorFloat", testSimdVectorFloat),
        ("testSimdVector4Double", testSimdVector4Double),

    ]
}
