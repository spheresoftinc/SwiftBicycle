//
//  Field.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation

public struct FieldID: Hashable {
    let uuid = UUID()

    public init() {
    }
}

public class AnyField: Hashable {
    public let id: FieldID
    public internal(set) weak var network: BicycleNetwork? {
        willSet {
            assert(newValue == nil || self.network == nil)
        }
    }
    var dependents = [AnyCalculator]()
    static var calculatorFactories = [AnyCalculatorFactory]()

    public enum Code: CaseIterable {
        case clear
        case set
        case calced
        case defaultValue
        case implied
    }

    public var code: Code = .clear

    public init(id: FieldID = FieldID()) {
        self.id = id
    }

    func clear() {
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

    func propagate() -> Bool {
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

    private var numTargettingCalcs: Int = 0

    func zeroNumTargettingCalculators() {
        numTargettingCalcs = 0
    }

    func incrementNumTargettingCalculators() {
        numTargettingCalcs += 1
    }

    func hasNoTargettingCalcs() -> Bool {
        return numTargettingCalcs == 0
    }

    public func hash(into hasher: inout Hasher) {
        self.id.hash(into: &hasher)
    }

    public static func == (lhs: AnyField, rhs: AnyField) -> Bool {
        return lhs === rhs
    }

    static func registerCalcFactory(calculatorFactory: AnyCalculatorFactory) {
        calculatorFactories.append(calculatorFactory)
    }
}

public class Field<T>: AnyField {

    public typealias ValueType = T
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

public extension Field where Field.ValueType: Equatable & LosslessStringConvertible {
    internal func set(text: String) {
        if let val = T(text) {
            set(value: val)
        }
    }

    internal func getText() -> String {
        if self.code != .clear {
            return String(self.value())
        } else {
            return ""
        }
    }

    var text: String {
        get {
            return self.getText()
        }
        set {
            self.set(text: newValue)
        }
    }
}
