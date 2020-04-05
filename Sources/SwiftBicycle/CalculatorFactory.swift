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

public class Calculator1OpFactory<TTarget: Equatable, TOperator1>: AnyCalculatorFactory {

    let targetId: FieldID
    let operator1Id: FieldID
    public typealias CalcFn = Calculator1Op<TTarget, TOperator1>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operator1Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operator1Id = operator1Id
        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(targetId: FieldID, operator1Id: FieldID, calcFn: @escaping CalcFn) {
        _ = Calculator1OpFactory(targetId: targetId, operator1Id: operator1Id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let targetField = network.getField(id: targetId) as? Field<TTarget>,
            let operator1Field = network.getField(id: operator1Id) as? Field<TOperator1>
            else { return nil }
        return Calculator1Op<TTarget, TOperator1>(network: network, target: targetField, operand1: operator1Field, calcFn: calcFn)
    }

}

public class Calculator2OpFactory<TTarget: Equatable, TOperator1, TOperator2>: AnyCalculatorFactory {

    let targetId: FieldID
    let operator1Id: FieldID
    let operator2Id: FieldID
    public typealias CalcFn = Calculator2Op<TTarget, TOperator1, TOperator2>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operator1Id: FieldID, operator2Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operator1Id = operator1Id
        self.operator2Id = operator2Id
        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(targetId: FieldID, operator1Id: FieldID, operator2Id: FieldID, calcFn: @escaping CalcFn) {
        _ = Calculator2OpFactory(targetId: targetId, operator1Id: operator1Id, operator2Id: operator2Id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let targetField = network.getField(id: targetId) as? Field<TTarget>,
            let operator1Field = network.getField(id: operator1Id) as? Field<TOperator1>,
            let operator2Field = network.getField(id: operator2Id) as? Field<TOperator2>
            else { return nil }
        return Calculator2Op<TTarget, TOperator1, TOperator2>(network: network, target: targetField, operand1: operator1Field, operand2: operator2Field, calcFn: calcFn)
    }

}
