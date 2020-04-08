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

public class Calculator1OpFactory<TTarget: Equatable, TOperand1>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand1Id: FieldID
    public typealias CalcFn = Calculator1Op<TTarget, TOperand1>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand1Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand1Id = operand1Id
        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(targetId: FieldID, operand1Id: FieldID, calcFn: @escaping CalcFn) {
        _ = Calculator1OpFactory(targetId: targetId, operand1Id: operand1Id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let targetField = network.getField(id: targetId) as? Field<TTarget>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>
            else { return nil }
        return Calculator1Op<TTarget, TOperand1>(network: network, target: targetField, operand1: operand1Field, calcFn: calcFn)
    }

}

public class Calculator2OpFactory<TTarget: Equatable, TOperand1, TOperand2>: AnyCalculatorFactory {

    let targetId: FieldID
    let operand1Id: FieldID
    let operand2Id: FieldID
    public typealias CalcFn = Calculator2Op<TTarget, TOperand1, TOperand2>.CalcFn
    let calcFn: CalcFn

    init(targetId: FieldID, operand1Id: FieldID, operand2Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operand1Id = operand1Id
        self.operand2Id = operand2Id
        self.calcFn = calcFn
        super.init()
    }

    public static func registerFactory(targetId: FieldID, operand1Id: FieldID, operand2Id: FieldID, calcFn: @escaping CalcFn) {
        _ = Calculator2OpFactory(targetId: targetId, operand1Id: operand1Id, operand2Id: operand2Id, calcFn: calcFn)
    }

    override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
        guard
            let targetField = network.getField(id: targetId) as? Field<TTarget>,
            let operand1Field = network.getField(id: operand1Id) as? Field<TOperand1>,
            let operand2Field = network.getField(id: operand2Id) as? Field<TOperand2>
            else { return nil }
        return Calculator2Op<TTarget, TOperand1, TOperand2>(network: network, target: targetField, operand1: operand1Field, operand2: operand2Field, calcFn: calcFn)
    }

}
