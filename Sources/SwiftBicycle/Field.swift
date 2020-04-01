//
//  Field.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation

public struct FieldID: Hashable {
    let uuid = UUID()
}

public class AnyField: Hashable {
    public let id: FieldID
    weak var collection: FieldCollection?
    var dependents = [AnyCalculator]()
    static var calculatorInitializers = [AnyCalculatorInitializer]()

    public enum Code: CaseIterable {
        case clear
        case set
        case calced
        case defaultValue
        case implied
    }

    public var code: Code = .clear

    public init(id: FieldID, collection: FieldCollection) {
        self.id = id
        self.collection = collection
    }

    public func clear() {
        dependents.removeAll()
    }

    public func addDependent(calculator: AnyCalculator) {
        if dependents.first(where: { $0 === calculator }) == nil {
            dependents.append(calculator)
        }
    }

    public func dropDependent(calculator: AnyCalculator) {
        dependents.removeAll(where: { $0 === calculator })
    }

    public func propagate() -> Bool {
        for dependent in dependents {
            if dependent.setField() {
                // Do nothing when propagation succeeds.
            }
            else {
                return false
            }
        }
        return true
    }

    public func setToDefault() -> Bool {
        return true
    }

    public private(set) var numTargettingCalcs: Int = 0

    public func zeroNumTargettingCalculators() {
        numTargettingCalcs = 0
    }

    public func incrementNumTargettingCalculators() {
        numTargettingCalcs += 1
    }

    public func hasNoTargettingCalcs() -> Bool {
        return numTargettingCalcs == 0
    }

    public func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
    }

    public static func == (lhs: AnyField, rhs: AnyField) -> Bool {
        return lhs === rhs
    }

    static func registerCalcInitializer(calculatorInitializer: AnyCalculatorInitializer) {
        calculatorInitializers.append(calculatorInitializer)
    }
}

public class Field<T>: AnyField {

    private var maybeValue: T?

    public func setValue(value: T, code: Code) -> Bool
    {
        self.maybeValue = value
        self.code = code
        return propagate()
    }

    public func value() -> T {
        assert(self.maybeValue != nil && self.code != .clear)
        return self.maybeValue!
    }
}
