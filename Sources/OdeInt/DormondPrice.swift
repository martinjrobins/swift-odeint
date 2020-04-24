import Numerics

struct DormondPrice<Scalar: Real & BinaryFloatingPoint>: ButchersTableau {
  typealias Scalar = Scalar
  let stages = 7
  let order = 5
  let estimator_order = 4
  let dense_order = 5
  let c: [Scalar] = 
    [Scalar(0.0), Scalar(1.0/5.0), Scalar(3.0/10.0), Scalar(4.0/5.0), Scalar(8.0/9.0),
      Scalar(1.0), Scalar(1.0)]
  let a: [[Scalar]] = 
    [
      [Scalar(0.0), Scalar(0.0), Scalar(0.0), Scalar(0.0), Scalar(0.0)], 
      [Scalar(1.0/5.0), Scalar(0.0), Scalar(0.0), Scalar(0.0), Scalar(0.0)], 
      [Scalar(3.0/40.0), Scalar(9.0/40.0), Scalar(0.0), Scalar(0.0), Scalar(0.0)], 
      [Scalar(44.0/45.0), Scalar(-56.0/15.0), Scalar(32.0/9.0), Scalar(0.0), Scalar(0.0)], 
      [Scalar(19372.0/6561.0), Scalar(-25360.0/2187.0), Scalar(64448.0/6561.0), 
        Scalar(-212.0/729.0), Scalar(0.0)], 
      [Scalar(9017.0/3168.0), Scalar(-355.0/33.0), Scalar(46732.0/5247.0), Scalar(49.0/176.0),
        Scalar(-5103.0/18656.0)],
      [Scalar(35.0/384.0), Scalar(0.0), Scalar(500.0/1113.0), Scalar(125.0/192.0),
        Scalar(-2187.0/6784.0), Scalar(11.0/84.0)],
    ]


  let b_hat: [Scalar] = 
    [Scalar(35.0/384.0), Scalar(0.0), Scalar(500.0/1113.0), Scalar(125.0/192.0),
      Scalar(-2187.0/6784.0), Scalar(11.0/84.0), Scalar(0.0)]
  let b: [Scalar] =
    [Scalar(5179.0/57600.0), Scalar(0.0), Scalar(7571.0/16695.0), Scalar(393.0/640.0),
      Scalar(-92097.0/339200.0), Scalar(187.0/2100.0), Scalar(1.0/40.0)]
  let p: [[Scalar]] = 
    [
      [Scalar(1.0), 
        Scalar(-32272833064.0/11282082432.0),
        Scalar(34969693132.0/11282082432.0),
        Scalar(-13107642775.0/11282082432.0),
        Scalar(157015080.0/11282082432.0)],
      [Scalar(0.0), Scalar(0.0), Scalar(0.0), Scalar(0.0), Scalar(0.0)],
      [Scalar(0.0), 
        Scalar(1323431896.0*100.0/32700410799.0),
        Scalar(-2074956840.0*100.0/32700410799.0),
        Scalar(914128567.0*100.0/32700410799.0),
        Scalar(-15701508.0*100.0/32700410799.0)],
      [Scalar(0.0), 
        Scalar(-889289856.0*25.0/5641041216.0),
        Scalar(2460397220.0*25.0/5641041216.0),
        Scalar(-1518414297.0*25.0/5641041216.0),
        Scalar(94209048.0*25.0/5641041216.0)],
      [Scalar(0.0), 
        Scalar(259006536.0*2187.0/199316789632.0),
        Scalar(-687873124.0*2187.0/199316789632.0),
        Scalar(451824525.0*2187.0/199316789632.0),
        Scalar(-52338360.0*2187.0/199316789632.0)], 
      [Scalar(0.0), 
        Scalar(-361440756.0*11.0/2467955532.0),
        Scalar(946554244.0*11.0/2467955532.0),
        Scalar(-661884105.0*11.0/2467955532.0),
        Scalar(106151040.0*11.0/2467955532.0)],
      [Scalar(0.0), 
        Scalar(44764047.0/29380423.0), 
        Scalar(-127201567/29380423.0), 
        Scalar(90730570.0/29380423.0), 
        Scalar(-8293050.0/29380423.0)],
    ]

}

