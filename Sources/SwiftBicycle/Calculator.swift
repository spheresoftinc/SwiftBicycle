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

    public func setField() -> Bool {
        return false
    }

    public func resetField() {

    }

    public func isReady() -> Bool {
        return true
    }

    public func makeRelationship() -> Relationship {
        return Relationship()
    }

    public func allowRedundancyChecking() -> Bool {
        return false
    }

    public func hash(into hasher: inout Hasher) {
    }

    public static func == (lhs: AnyCalculator, rhs: AnyCalculator) -> Bool {
        return lhs === rhs
    }

    public func anyTarget() -> AnyField {
        assertionFailure("anyTarget must be overridden")
        // This line is here for the compiler. If you get here, it's programmer error.
        return AnyField()
    }
}

public class Calculator<TTarget>: AnyCalculator {

    var target: Field<TTarget>

    public init(network: BicycleNetwork, target: Field<TTarget>) {
        self.target = target
        super.init(network: network)
    }

    public override func makeRelationship() -> Relationship {
        let r = super.makeRelationship()
        r.addSourceField(fieldID: target.id)
        return r
    }

    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        target.id.hash(into: &hasher)
    }

    public override func anyTarget() -> AnyField {
        return target
    }
}

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


    public override func isReady() -> Bool {
        guard operand1.code != .clear else {
            return false
        }
        return self.readyFn?(self.operand1.value()) ?? true
    }

    public func calcTarget() -> TTarget {
        assert(operand1.code != .clear)
        return self.calcFn(self.operand1.value())
    }

    public override func makeRelationship() -> Relationship {
        let r = super.makeRelationship()
        r.addSourceField(fieldID: operand1.id)
        return r
    }

    public override func setField() -> Bool {
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

        let result = calcFn(self.operand1.value())
        // if the target is clear then propagate the result through the network
        if target.code == .clear {
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

