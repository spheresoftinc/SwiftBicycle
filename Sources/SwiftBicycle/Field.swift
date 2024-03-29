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
    public let name: String
    public internal(set) weak var network: BicycleNetwork? {
        willSet {
            assert(newValue == nil || self.network == nil)
        }
    }
    var dependents = Set<AnyCalculator>()
    static var calculatorFactories = [AnyCalculatorFactory]()

    public enum Code: Equatable {
        case clear
        case error(text: String)
        case set
        case calced
        case defaultValue
        case implied

        func isEmpty() -> Bool {
            switch self {
            case .clear, .error:
                return true
            case .set, .calced, .defaultValue, .implied:
                return false
            }
        }

        func isError() -> Bool {
            switch self {
            case .error:
                return true
            case .clear, .set, .calced, .defaultValue, .implied:
                return false
            }
        }
    }

    public var code: Code = .clear

    public init(id: FieldID = FieldID(), name: String? = nil) {
        self.id = id
        self.name = name ?? id.uuid.uuidString
    }

    func clear() {
        dependents.removeAll()
    }

    func addDependent(calculator: AnyCalculator) {
        dependents.insert(calculator)
    }

    func dropDependent(calculator: AnyCalculator) {
        dependents.remove(calculator)
    }

    func propagate() -> Bool {
        for dependent in dependents {
            if dependent.setField() {
                // Do nothing when propagation succeeds.
                BicycleLog("Calculator propagate succeeded")
            }
            else {
                BicycleLog("Calculator propagate failed")
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
    public var formatter: Formatter?
    public var isEqual: ((T, T) -> Bool)?

    public func setValue(value: T, code: Code) -> Bool
    {
        self.maybeValue = value
        self.code = code
        return propagate()
    }

    public func value() -> T {
        assert(self.maybeValue != nil && !self.code.isEmpty())
        return self.maybeValue!
    }
}

public extension Field where Field.ValueType: Equatable {
    func valueIsEqualTo(value: T) -> Bool {
        if let isEqual = self.isEqual {
            return isEqual(self.value(), value)
        } else if let tgtEquatable = self.value() as? FieldValueEquatable,
                  let resEquatable = value as? FieldValueEquatable {
            return tgtEquatable.fieldValueIsEqualTo(value: resEquatable)
        } else {
            return self.value() == value
        }
    }
}

public extension Field where Field.ValueType: Equatable & LosslessStringConvertible {
    internal func set(text: String) {
        guard text != self.text else {
            return
        }
        if let formatter = self.formatter {
            var obj: AnyObject?
            var error: NSString?
            if formatter.getObjectValue(&obj, for: text, errorDescription: &error) {
                if let value = obj as? T {
                    set(value: value)
                }
            }
        }
        else if let val = T(text) {
            set(value: val)
        }
    }

    internal func getText() -> String {
        if case let .error(text) = self.code {
            return text
        }
        if !self.code.isEmpty() {
            if let formatter = self.formatter {
                return formatter.string(for: self.value()) ?? ""
            }
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
