//
//  Calculator.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation

public class AnyCalculator: Hashable {
    weak var network: BicycleNetwork?
    var wasUsed = false

    public init(network: BicycleNetwork) {
        self.network = network
    }

    func setField() -> Bool {
        return false
    }

    func resetField() {

    }

    func isReady() -> Bool {
        return true
    }

    func makeRelationship() -> Relationship {
        return Relationship()
    }

    public func hash(into hasher: inout Hasher) {
    }

    public static func == (lhs: AnyCalculator, rhs: AnyCalculator) -> Bool {
        return lhs === rhs
    }

    func anyTarget() -> AnyField {
        assertionFailure("anyTarget must be overridden")
        // This line is here for the compiler. If you get here, it's programmer error.
        return AnyField()
    }
}

public class Calculator<TTarget: Equatable>: AnyCalculator {

    var target: Field<TTarget>

    public init(network: BicycleNetwork, target: Field<TTarget>) {
        self.target = target
        super.init(network: network)
    }

    override func makeRelationship() -> Relationship {
        let r = super.makeRelationship()
        r.addSourceField(fieldID: target.id)
        return r
    }

    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        target.id.hash(into: &hasher)
    }

    override func anyTarget() -> AnyField {
        return target
    }

    internal func calcTarget() -> TTarget? {
        assertionFailure("Must be overridden")
        return nil
    }

    override func setField() -> Bool {
        // check to see if this calculator is ready.  Typically this means that all of the source
        // operands are not clear, but in some cases, the actual values of the fields may determine
        // if this calculator is ready (i.e. value-dependent calculators).
        guard isReady() else {
            return true // not ready, but that's ok
        }

        guard let network = self.network else { return true }

        // check to see if an inversion of this calculator has already been used
        // if it has, we may not want to use it.
        let r = makeRelationship()
        guard !network.relationshipWasUsed(relationship: r) else {
            return true
        }

        guard let result: TTarget = calcTarget() else { return true }

        // if the target is clear then propagate the result through the network
        if target.code.isEmpty() {
            // every calc that acts is added to the rollbacks, and will be reversed if the network
            // becomes inconsistent
            network.addRollback(calculator: self)

            // register the relationship
            network.addUsedRelationship(relationship: r)

            // Set the value with a calc code...
            return target.setValue(value: result, code: .calced)
        } else {
            // Compare to existing value, to see if the sources are consistent with the target.
            return target.value() == result
        }
    }
}

// Code under this comment generated with gen-calc.swift. Do not edit.

  public class Calculator1Op<TTarget: Equatable, TOperand1>: Calculator<TTarget> {

      var operand1: Field<TOperand1>

      public typealias CalcFn = (TOperand1) -> TTarget
      public typealias ReadyFn = (TOperand1) -> Bool
      var calcFn: CalcFn
      var readyFn: ReadyFn?

      public init(network: BicycleNetwork, target: Field<TTarget>, operand1: Field<TOperand1>, calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
          self.operand1 = operand1

          self.calcFn = calcFn
          self.readyFn = readyFn
          super.init(network: network, target: target)
          operand1.addDependent(calculator: self)

      }

      public override func hash(into hasher: inout Hasher) {
          super.hash(into: &hasher)
          operand1.id.hash(into: &hasher)

      }

      override func isReady() -> Bool {
          guard !operand1.code.isEmpty() else {
              return false
          }

          return self.readyFn?(self.operand1.value()) ?? true
      }

      internal override func calcTarget() -> TTarget? {
          assert(!operand1.code.isEmpty())

          return self.calcFn(self.operand1.value())
      }

      override func makeRelationship() -> Relationship {
          let r = super.makeRelationship()
          r.addSourceField(fieldID: operand1.id)

          return r
      }

  }

  public class Calculator2Op<TTarget: Equatable, TOperand1, TOperand2>: Calculator<TTarget> {

      var operand1: Field<TOperand1>
      var operand2: Field<TOperand2>

      public typealias CalcFn = (TOperand1, TOperand2) -> TTarget
      public typealias ReadyFn = (TOperand1, TOperand2) -> Bool
      var calcFn: CalcFn
      var readyFn: ReadyFn?

      public init(network: BicycleNetwork, target: Field<TTarget>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
          self.operand1 = operand1
          self.operand2 = operand2

          self.calcFn = calcFn
          self.readyFn = readyFn
          super.init(network: network, target: target)
          operand1.addDependent(calculator: self)
          operand2.addDependent(calculator: self)

      }

      public override func hash(into hasher: inout Hasher) {
          super.hash(into: &hasher)
          operand1.id.hash(into: &hasher)
          operand2.id.hash(into: &hasher)

      }

      override func isReady() -> Bool {
          guard !operand1.code.isEmpty() else {
              return false
          }
          guard !operand2.code.isEmpty() else {
              return false
          }

          return self.readyFn?(self.operand1.value(), self.operand2.value()) ?? true
      }

      internal override func calcTarget() -> TTarget? {
          assert(!operand1.code.isEmpty())
          assert(!operand2.code.isEmpty())

          return self.calcFn(self.operand1.value(), self.operand2.value())
      }

      override func makeRelationship() -> Relationship {
          let r = super.makeRelationship()
          r.addSourceField(fieldID: operand1.id)
          r.addSourceField(fieldID: operand2.id)

          return r
      }

  }

  public class Calculator3Op<TTarget: Equatable, TOperand1, TOperand2, TOperand3>: Calculator<TTarget> {

      var operand1: Field<TOperand1>
      var operand2: Field<TOperand2>
      var operand3: Field<TOperand3>

      public typealias CalcFn = (TOperand1, TOperand2, TOperand3) -> TTarget
      public typealias ReadyFn = (TOperand1, TOperand2, TOperand3) -> Bool
      var calcFn: CalcFn
      var readyFn: ReadyFn?

      public init(network: BicycleNetwork, target: Field<TTarget>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
          self.operand1 = operand1
          self.operand2 = operand2
          self.operand3 = operand3

          self.calcFn = calcFn
          self.readyFn = readyFn
          super.init(network: network, target: target)
          operand1.addDependent(calculator: self)
          operand2.addDependent(calculator: self)
          operand3.addDependent(calculator: self)

      }

      public override func hash(into hasher: inout Hasher) {
          super.hash(into: &hasher)
          operand1.id.hash(into: &hasher)
          operand2.id.hash(into: &hasher)
          operand3.id.hash(into: &hasher)

      }

      override func isReady() -> Bool {
          guard !operand1.code.isEmpty() else {
              return false
          }
          guard !operand2.code.isEmpty() else {
              return false
          }
          guard !operand3.code.isEmpty() else {
              return false
          }

          return self.readyFn?(self.operand1.value(), self.operand2.value(), self.operand3.value()) ?? true
      }

      internal override func calcTarget() -> TTarget? {
          assert(!operand1.code.isEmpty())
          assert(!operand2.code.isEmpty())
          assert(!operand3.code.isEmpty())

          return self.calcFn(self.operand1.value(), self.operand2.value(), self.operand3.value())
      }

      override func makeRelationship() -> Relationship {
          let r = super.makeRelationship()
          r.addSourceField(fieldID: operand1.id)
          r.addSourceField(fieldID: operand2.id)
          r.addSourceField(fieldID: operand3.id)

          return r
      }

  }

  public class Calculator4Op<TTarget: Equatable, TOperand1, TOperand2, TOperand3, TOperand4>: Calculator<TTarget> {

      var operand1: Field<TOperand1>
      var operand2: Field<TOperand2>
      var operand3: Field<TOperand3>
      var operand4: Field<TOperand4>

      public typealias CalcFn = (TOperand1, TOperand2, TOperand3, TOperand4) -> TTarget
      public typealias ReadyFn = (TOperand1, TOperand2, TOperand3, TOperand4) -> Bool
      var calcFn: CalcFn
      var readyFn: ReadyFn?

      public init(network: BicycleNetwork, target: Field<TTarget>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, operand4: Field<TOperand4>, calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
          self.operand1 = operand1
          self.operand2 = operand2
          self.operand3 = operand3
          self.operand4 = operand4

          self.calcFn = calcFn
          self.readyFn = readyFn
          super.init(network: network, target: target)
          operand1.addDependent(calculator: self)
          operand2.addDependent(calculator: self)
          operand3.addDependent(calculator: self)
          operand4.addDependent(calculator: self)

      }

      public override func hash(into hasher: inout Hasher) {
          super.hash(into: &hasher)
          operand1.id.hash(into: &hasher)
          operand2.id.hash(into: &hasher)
          operand3.id.hash(into: &hasher)
          operand4.id.hash(into: &hasher)

      }

      override func isReady() -> Bool {
          guard !operand1.code.isEmpty() else {
              return false
          }
          guard !operand2.code.isEmpty() else {
              return false
          }
          guard !operand3.code.isEmpty() else {
              return false
          }
          guard !operand4.code.isEmpty() else {
              return false
          }

          return self.readyFn?(self.operand1.value(), self.operand2.value(), self.operand3.value(), self.operand4.value()) ?? true
      }

      internal override func calcTarget() -> TTarget? {
          assert(!operand1.code.isEmpty())
          assert(!operand2.code.isEmpty())
          assert(!operand3.code.isEmpty())
          assert(!operand4.code.isEmpty())

          return self.calcFn(self.operand1.value(), self.operand2.value(), self.operand3.value(), self.operand4.value())
      }

      override func makeRelationship() -> Relationship {
          let r = super.makeRelationship()
          r.addSourceField(fieldID: operand1.id)
          r.addSourceField(fieldID: operand2.id)
          r.addSourceField(fieldID: operand3.id)
          r.addSourceField(fieldID: operand4.id)

          return r
      }

  }

  public class Calculator5Op<TTarget: Equatable, TOperand1, TOperand2, TOperand3, TOperand4, TOperand5>: Calculator<TTarget> {

      var operand1: Field<TOperand1>
      var operand2: Field<TOperand2>
      var operand3: Field<TOperand3>
      var operand4: Field<TOperand4>
      var operand5: Field<TOperand5>

      public typealias CalcFn = (TOperand1, TOperand2, TOperand3, TOperand4, TOperand5) -> TTarget
      public typealias ReadyFn = (TOperand1, TOperand2, TOperand3, TOperand4, TOperand5) -> Bool
      var calcFn: CalcFn
      var readyFn: ReadyFn?

      public init(network: BicycleNetwork, target: Field<TTarget>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, operand4: Field<TOperand4>, operand5: Field<TOperand5>, calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
          self.operand1 = operand1
          self.operand2 = operand2
          self.operand3 = operand3
          self.operand4 = operand4
          self.operand5 = operand5

          self.calcFn = calcFn
          self.readyFn = readyFn
          super.init(network: network, target: target)
          operand1.addDependent(calculator: self)
          operand2.addDependent(calculator: self)
          operand3.addDependent(calculator: self)
          operand4.addDependent(calculator: self)
          operand5.addDependent(calculator: self)

      }

      public override func hash(into hasher: inout Hasher) {
          super.hash(into: &hasher)
          operand1.id.hash(into: &hasher)
          operand2.id.hash(into: &hasher)
          operand3.id.hash(into: &hasher)
          operand4.id.hash(into: &hasher)
          operand5.id.hash(into: &hasher)

      }

      override func isReady() -> Bool {
          guard !operand1.code.isEmpty() else {
              return false
          }
          guard !operand2.code.isEmpty() else {
              return false
          }
          guard !operand3.code.isEmpty() else {
              return false
          }
          guard !operand4.code.isEmpty() else {
              return false
          }
          guard !operand5.code.isEmpty() else {
              return false
          }

          return self.readyFn?(self.operand1.value(), self.operand2.value(), self.operand3.value(), self.operand4.value(), self.operand5.value()) ?? true
      }

      internal override func calcTarget() -> TTarget? {
          assert(!operand1.code.isEmpty())
          assert(!operand2.code.isEmpty())
          assert(!operand3.code.isEmpty())
          assert(!operand4.code.isEmpty())
          assert(!operand5.code.isEmpty())

          return self.calcFn(self.operand1.value(), self.operand2.value(), self.operand3.value(), self.operand4.value(), self.operand5.value())
      }

      override func makeRelationship() -> Relationship {
          let r = super.makeRelationship()
          r.addSourceField(fieldID: operand1.id)
          r.addSourceField(fieldID: operand2.id)
          r.addSourceField(fieldID: operand3.id)
          r.addSourceField(fieldID: operand4.id)
          r.addSourceField(fieldID: operand5.id)

          return r
      }

  }

  public class Calculator6Op<TTarget: Equatable, TOperand1, TOperand2, TOperand3, TOperand4, TOperand5, TOperand6>: Calculator<TTarget> {

      var operand1: Field<TOperand1>
      var operand2: Field<TOperand2>
      var operand3: Field<TOperand3>
      var operand4: Field<TOperand4>
      var operand5: Field<TOperand5>
      var operand6: Field<TOperand6>

      public typealias CalcFn = (TOperand1, TOperand2, TOperand3, TOperand4, TOperand5, TOperand6) -> TTarget
      public typealias ReadyFn = (TOperand1, TOperand2, TOperand3, TOperand4, TOperand5, TOperand6) -> Bool
      var calcFn: CalcFn
      var readyFn: ReadyFn?

      public init(network: BicycleNetwork, target: Field<TTarget>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, operand4: Field<TOperand4>, operand5: Field<TOperand5>, operand6: Field<TOperand6>, calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
          self.operand1 = operand1
          self.operand2 = operand2
          self.operand3 = operand3
          self.operand4 = operand4
          self.operand5 = operand5
          self.operand6 = operand6

          self.calcFn = calcFn
          self.readyFn = readyFn
          super.init(network: network, target: target)
          operand1.addDependent(calculator: self)
          operand2.addDependent(calculator: self)
          operand3.addDependent(calculator: self)
          operand4.addDependent(calculator: self)
          operand5.addDependent(calculator: self)
          operand6.addDependent(calculator: self)

      }

      public override func hash(into hasher: inout Hasher) {
          super.hash(into: &hasher)
          operand1.id.hash(into: &hasher)
          operand2.id.hash(into: &hasher)
          operand3.id.hash(into: &hasher)
          operand4.id.hash(into: &hasher)
          operand5.id.hash(into: &hasher)
          operand6.id.hash(into: &hasher)

      }

      override func isReady() -> Bool {
          guard !operand1.code.isEmpty() else {
              return false
          }
          guard !operand2.code.isEmpty() else {
              return false
          }
          guard !operand3.code.isEmpty() else {
              return false
          }
          guard !operand4.code.isEmpty() else {
              return false
          }
          guard !operand5.code.isEmpty() else {
              return false
          }
          guard !operand6.code.isEmpty() else {
              return false
          }

          return self.readyFn?(self.operand1.value(), self.operand2.value(), self.operand3.value(), self.operand4.value(), self.operand5.value(), self.operand6.value()) ?? true
      }

      internal override func calcTarget() -> TTarget? {
          assert(!operand1.code.isEmpty())
          assert(!operand2.code.isEmpty())
          assert(!operand3.code.isEmpty())
          assert(!operand4.code.isEmpty())
          assert(!operand5.code.isEmpty())
          assert(!operand6.code.isEmpty())

          return self.calcFn(self.operand1.value(), self.operand2.value(), self.operand3.value(), self.operand4.value(), self.operand5.value(), self.operand6.value())
      }

      override func makeRelationship() -> Relationship {
          let r = super.makeRelationship()
          r.addSourceField(fieldID: operand1.id)
          r.addSourceField(fieldID: operand2.id)
          r.addSourceField(fieldID: operand3.id)
          r.addSourceField(fieldID: operand4.id)
          r.addSourceField(fieldID: operand5.id)
          r.addSourceField(fieldID: operand6.id)

          return r
      }

  }

