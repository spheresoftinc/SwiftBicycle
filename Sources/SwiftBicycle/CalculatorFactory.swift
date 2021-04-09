//
//  CalculatorFactory.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation


public class AnyCalculatorFactory {

    init() {
        AnyField.registerCalcFactory(calculatorFactory: self)
    }

    func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        return nil
    }
}

// Code under this comment generated with gen-calc-factory.swift. Do not edit.

public class Calculator1OpFactory<TTarget: Equatable, TOperand0>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand0Id: FieldID

    public typealias CalcFn = Calculator1Op<TTarget, TOperand0>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand0Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand0Id = operand0Id

        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(target: Field<TTarget>, operand0: Field<TOperand0>, calcFn: @escaping CalcFn) {
        _ = Calculator1OpFactory(targetId: target.id, operand0Id: operand0.id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let operand0Field = network.getField(id: operand0Id) as? Field<TOperand0>,

            let targetField = network.getField(id: targetId) as? Field<TTarget>
        else { return nil }

        return Calculator1Op<TTarget, TOperand0>(network: network, target: targetField, operand0: operand0Field, calcFn: calcFn)
    }

}
public class Calculator2OpFactory<TTarget: Equatable, TOperand0, TOperand1>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand0Id: FieldID
    let operand1Id: FieldID

    public typealias CalcFn = Calculator2Op<TTarget, TOperand0, TOperand1>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand0Id: FieldID, operand1Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand0Id = operand0Id
        self.operand1Id = operand1Id

        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(target: Field<TTarget>, operand0: Field<TOperand0>, operand1: Field<TOperand1>, calcFn: @escaping CalcFn) {
        _ = Calculator2OpFactory(targetId: target.id, operand0Id: operand0.id, operand1Id: operand1.id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let operand0Field = network.getField(id: operand0Id) as? Field<TOperand0>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>,

            let targetField = network.getField(id: targetId) as? Field<TTarget>
        else { return nil }

        return Calculator2Op<TTarget, TOperand0, TOperand1>(network: network, target: targetField, operand0: operand0Field, operand1: operand1Field, calcFn: calcFn)
    }

}
public class Calculator3OpFactory<TTarget: Equatable, TOperand0, TOperand1, TOperand2>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand0Id: FieldID
    let operand1Id: FieldID
    let operand2Id: FieldID

    public typealias CalcFn = Calculator3Op<TTarget, TOperand0, TOperand1, TOperand2>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand0Id: FieldID, operand1Id: FieldID, operand2Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand0Id = operand0Id
        self.operand1Id = operand1Id
        self.operand2Id = operand2Id

        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(target: Field<TTarget>, operand0: Field<TOperand0>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, calcFn: @escaping CalcFn) {
        _ = Calculator3OpFactory(targetId: target.id, operand0Id: operand0.id, operand1Id: operand1.id, operand2Id: operand2.id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let operand0Field = network.getField(id: operand0Id) as? Field<TOperand0>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>,
            let operand2Field = network.getField(id: operand2Id) as? Field<TOperand2>,

            let targetField = network.getField(id: targetId) as? Field<TTarget>
        else { return nil }

        return Calculator3Op<TTarget, TOperand0, TOperand1, TOperand2>(network: network, target: targetField, operand0: operand0Field, operand1: operand1Field, operand2: operand2Field, calcFn: calcFn)
    }

}
public class Calculator4OpFactory<TTarget: Equatable, TOperand0, TOperand1, TOperand2, TOperand3>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand0Id: FieldID
    let operand1Id: FieldID
    let operand2Id: FieldID
    let operand3Id: FieldID

    public typealias CalcFn = Calculator4Op<TTarget, TOperand0, TOperand1, TOperand2, TOperand3>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand0Id: FieldID, operand1Id: FieldID, operand2Id: FieldID, operand3Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand0Id = operand0Id
        self.operand1Id = operand1Id
        self.operand2Id = operand2Id
        self.operand3Id = operand3Id

        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(target: Field<TTarget>, operand0: Field<TOperand0>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, calcFn: @escaping CalcFn) {
        _ = Calculator4OpFactory(targetId: target.id, operand0Id: operand0.id, operand1Id: operand1.id, operand2Id: operand2.id, operand3Id: operand3.id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let operand0Field = network.getField(id: operand0Id) as? Field<TOperand0>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>,
            let operand2Field = network.getField(id: operand2Id) as? Field<TOperand2>,
            let operand3Field = network.getField(id: operand3Id) as? Field<TOperand3>,

            let targetField = network.getField(id: targetId) as? Field<TTarget>
        else { return nil }

        return Calculator4Op<TTarget, TOperand0, TOperand1, TOperand2, TOperand3>(network: network, target: targetField, operand0: operand0Field, operand1: operand1Field, operand2: operand2Field, operand3: operand3Field, calcFn: calcFn)
    }

}
public class Calculator5OpFactory<TTarget: Equatable, TOperand0, TOperand1, TOperand2, TOperand3, TOperand4>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand0Id: FieldID
    let operand1Id: FieldID
    let operand2Id: FieldID
    let operand3Id: FieldID
    let operand4Id: FieldID

    public typealias CalcFn = Calculator5Op<TTarget, TOperand0, TOperand1, TOperand2, TOperand3, TOperand4>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand0Id: FieldID, operand1Id: FieldID, operand2Id: FieldID, operand3Id: FieldID, operand4Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand0Id = operand0Id
        self.operand1Id = operand1Id
        self.operand2Id = operand2Id
        self.operand3Id = operand3Id
        self.operand4Id = operand4Id

        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(target: Field<TTarget>, operand0: Field<TOperand0>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, operand4: Field<TOperand4>, calcFn: @escaping CalcFn) {
        _ = Calculator5OpFactory(targetId: target.id, operand0Id: operand0.id, operand1Id: operand1.id, operand2Id: operand2.id, operand3Id: operand3.id, operand4Id: operand4.id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let operand0Field = network.getField(id: operand0Id) as? Field<TOperand0>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>,
            let operand2Field = network.getField(id: operand2Id) as? Field<TOperand2>,
            let operand3Field = network.getField(id: operand3Id) as? Field<TOperand3>,
            let operand4Field = network.getField(id: operand4Id) as? Field<TOperand4>,

            let targetField = network.getField(id: targetId) as? Field<TTarget>
        else { return nil }

        return Calculator5Op<TTarget, TOperand0, TOperand1, TOperand2, TOperand3, TOperand4>(network: network, target: targetField, operand0: operand0Field, operand1: operand1Field, operand2: operand2Field, operand3: operand3Field, operand4: operand4Field, calcFn: calcFn)
    }

}
public class Calculator6OpFactory<TTarget: Equatable, TOperand0, TOperand1, TOperand2, TOperand3, TOperand4, TOperand5>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand0Id: FieldID
    let operand1Id: FieldID
    let operand2Id: FieldID
    let operand3Id: FieldID
    let operand4Id: FieldID
    let operand5Id: FieldID

    public typealias CalcFn = Calculator6Op<TTarget, TOperand0, TOperand1, TOperand2, TOperand3, TOperand4, TOperand5>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand0Id: FieldID, operand1Id: FieldID, operand2Id: FieldID, operand3Id: FieldID, operand4Id: FieldID, operand5Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand0Id = operand0Id
        self.operand1Id = operand1Id
        self.operand2Id = operand2Id
        self.operand3Id = operand3Id
        self.operand4Id = operand4Id
        self.operand5Id = operand5Id

        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(target: Field<TTarget>, operand0: Field<TOperand0>, operand1: Field<TOperand1>, operand2: Field<TOperand2>, operand3: Field<TOperand3>, operand4: Field<TOperand4>, operand5: Field<TOperand5>, calcFn: @escaping CalcFn) {
        _ = Calculator6OpFactory(targetId: target.id, operand0Id: operand0.id, operand1Id: operand1.id, operand2Id: operand2.id, operand3Id: operand3.id, operand4Id: operand4.id, operand5Id: operand5.id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let operand0Field = network.getField(id: operand0Id) as? Field<TOperand0>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>,
            let operand2Field = network.getField(id: operand2Id) as? Field<TOperand2>,
            let operand3Field = network.getField(id: operand3Id) as? Field<TOperand3>,
            let operand4Field = network.getField(id: operand4Id) as? Field<TOperand4>,
            let operand5Field = network.getField(id: operand5Id) as? Field<TOperand5>,

            let targetField = network.getField(id: targetId) as? Field<TTarget>
        else { return nil }

        return Calculator6Op<TTarget, TOperand0, TOperand1, TOperand2, TOperand3, TOperand4, TOperand5>(network: network, target: targetField, operand0: operand0Field, operand1: operand1Field, operand2: operand2Field, operand3: operand3Field, operand4: operand4Field, operand5: operand5Field, calcFn: calcFn)
    }

}
