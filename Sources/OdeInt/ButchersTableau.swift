protocol ButchersTableau {
  associatedtype Scalar
  var stages: Int { get }
  var order: Int { get }
  var estimator_order: Int { get }
  var dense_order: Int { get }
  var c: [Scalar] { get }
  var a: [[Scalar]] { get }
  var b_hat: [Scalar] { get }
  var b: [Scalar] { get }
  var p: [[Scalar]] { get }
}

