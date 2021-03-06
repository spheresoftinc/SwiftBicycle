//
//  Setter.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation

public class AnySetter: Comparable, Hashable {

    public enum PriorityLevel: Int, CaseIterable, Comparable {
        public static func < (lhs: AnySetter.PriorityLevel, rhs: AnySetter.PriorityLevel) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

        case targeted
        case normal
        case notCalced
    }

    public internal(set) weak var network: BicycleNetwork? {
        willSet {
            assert(newValue == nil || self.network == nil)
        }
    }
    
    var canCalculate = true
    var priorityLevel: PriorityLevel
    var insertOrder: Int = 0

    public init(priorityLevel: PriorityLevel = .normal) {
        self.priorityLevel = priorityLevel
    }

    public func lessThan(rhs: AnySetter) -> Bool {
        if self.priorityLevel != rhs.priorityLevel {
            return self.priorityLevel < rhs.priorityLevel
        }

        if anyTarget().hasNoTargettingCalcs() && !rhs.anyTarget().hasNoTargettingCalcs() {
            return true
        } else if !anyTarget().hasNoTargettingCalcs() && rhs.anyTarget().hasNoTargettingCalcs() {
            return false
        } else if isUserProvided() && !rhs.isUserProvided() {
            return true
        } else if !isUserProvided() && rhs.isUserProvided() {
            return false
        }
        return insertOrder > rhs.insertOrder
    }

    func anyTarget() -> AnyField {
        assertionFailure("anyTarget must be overridden")
        // This line is here for the compiler. If you get here, it's programmer error.
        return AnyField()
    }

    func shouldCountAsCalc() -> Bool {
        return false
    }

    public func hash(into hasher: inout Hasher) {
        self.anyTarget().id.hash(into: &hasher)
    }

    public static func < (lhs: AnySetter, rhs: AnySetter) -> Bool {
        return lhs.lessThan(rhs: rhs)
    }

    public static func == (lhs: AnySetter, rhs: AnySetter) -> Bool {
        return lhs === rhs
    }

    func isUserProvided() -> Bool {
        return false
    }

    func setField() -> Bool {
        return false
    }

    func resetField() {
        assert(anyTarget().code == .calced)
        anyTarget().code = .clear
    }

    func isMatch(field: AnyField) -> Bool {
       return self.anyTarget() === field
    }
}

public class SetterConstant<T>: AnySetter {

    public typealias ValueType = T
    let target: Field<T>
    let value: T

    public init(priorityLevel: PriorityLevel = .normal, target: Field<T>, value: T) {
        self.target = target
        self.value = value
        super.init(priorityLevel: priorityLevel)
    }

    override func anyTarget() -> AnyField {
        return target
    }

    override func isUserProvided() -> Bool {
        return true
    }

    override func setField() -> Bool {
        if target.code.isEmpty() {
            BicycleLog("Trying to set \(target.name)")
            if target.setValue(value: self.value, code: .set) {
                BicycleLog("Set \(target.name) to \(self.value)")
                return true
            } else {
                // don't use resetfield, because in this case,
                // the code is set, not calced, and
                // the assert will fail.
                target.code = .clear
                BicycleLog("Failed to set \(target.name)")
                return false
            }
        }
        return false
    }

}

public class SetterError<T>: AnySetter {

    public typealias ValueType = T
    let target: Field<T>
    let text: String

    public init(priorityLevel: PriorityLevel = .normal, target: Field<T>, text: String) {
        self.target = target
        self.text = text

        super.init(priorityLevel: priorityLevel)
    }

    override func anyTarget() -> AnyField {
        return target
    }

    override func isUserProvided() -> Bool {
        return true
    }

    override func setField() -> Bool {
        if target.code == .clear {
            target.code = .error(text: text)
            return true
        }
        return false
    }

}

public class SetterDefault<T>: AnySetter {

    public typealias ValueType = T
    let target: Field<T>
    let value: T

    public init(priorityLevel: PriorityLevel = .normal, target: Field<T>, value: T) {
        self.target = target
        self.value = value
        super.init(priorityLevel: priorityLevel)
    }

    override func anyTarget() -> AnyField {
        return target
    }

    override func setField() -> Bool {
        if target.code.isEmpty() {
            BicycleLog("Trying to set default \(target.name)")
            if target.setValue(value: self.value, code: .defaultValue) {
                BicycleLog("Set \(target.name) to default \(self.value)")
                return true
            } else {
                // don't use resetfield, because in this case,
                // the code is set, not calced, and
                // the assert will fail.
                target.code = .clear
                BicycleLog("Failed to set default \(target.name)")
                return false
            }
        }
        return false
    }
}

public class SetterDefaultFn<T>: AnySetter {

    public typealias ValueType = T
    let target: Field<T>
    let valueFn: () -> T

    public init(priorityLevel: PriorityLevel = .normal, target: Field<T>, valueFn: @escaping () -> T) {
        self.target = target
        self.valueFn = valueFn
        super.init(priorityLevel: priorityLevel)
    }

    override func anyTarget() -> AnyField {
        return target
    }

    override func setField() -> Bool {
        if target.code.isEmpty() {
            BicycleLog("Trying to set via default function \(target.name)")
            let value = self.valueFn()
            if target.setValue(value: value, code: .defaultValue) {
                BicycleLog("Set \(target.name) to function result \(value)")
                return true
            } else {
                // don't use resetfield, because in this case,
                // the code is set, not calced, and
                // the assert will fail.
                target.code = .clear
                BicycleLog("Failed to set via default function \(target.name)")
                return false
            }
        }
        return false
    }
}


// Convenience functions for using setters
public extension Field where Field.ValueType: Equatable {
    func set(value: T) {
        guard
            let network = self.network,
            self.code.isEmpty() || !(self.valueIsEqualTo(value: value))
        else { return }

        network.adoptSetter(setter: SetterConstant(target: self, value: value))
    }

    func setError(text: String) {
        guard
            let network = self.network
        else { return }

        network.adoptSetter(setter: SetterError(target: self, text: text))
    }

    func setDefault(value: T) {
        guard
            let network = self.network
        else { return }

        network.adoptSetter(setter: SetterDefault(target: self, value: value))
    }

    func setDefault(valueFn: @escaping () -> T) {
        guard
            let network = self.network
        else { return }

        network.adoptSetter(setter: SetterDefaultFn(target: self, valueFn: valueFn))
    }
}
