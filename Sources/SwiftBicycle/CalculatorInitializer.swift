//
//  CalculatorInitializer.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation


class AnyCalculatorInitializer {
    func orphanCalculator(collection: FieldCollection) -> AnyCalculator? {
        return nil
    }
}

class CalculatorInitializer1Op<TTarget: Equatable, TOperator1>: AnyCalculatorInitializer {

    let targetId: FieldID
    let operator1Id: FieldID
    typealias CalcFn = Calculator1Op<TTarget, TOperator1>.CalcFn
    let calcFn: CalcFn

    public init(targetId: FieldID, operator1Id: FieldID, calcFn: @escaping CalcFn) {
        self.targetId = targetId
        self.operator1Id = operator1Id
        self.calcFn = calcFn
        super.init()
        AnyField.registerCalcInitializer(calculatorInitializer: self)
    }

    override func orphanCalculator(collection: FieldCollection) -> AnyCalculator? {
        guard
            let targetField = collection.getField(id: targetId) as? Field<TTarget>,
            let operator1Field = collection.getField(id: operator1Id) as? Field<TOperator1>
            else { return nil }
        return Calculator1Op<TTarget, TOperator1>(collection: collection, target: targetField, operand1: operator1Field, calcFn: calcFn)
    }

}
