//
//  BicycleNetwork.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation

public protocol BicycleNetworkDelegate: class {
    func networkWillCalculate(_ network: BicycleNetwork)
    func networkDidCalculate(_ network: BicycleNetwork)
}

public extension BicycleNetworkDelegate {
    func networkWillCalculate(_ network: BicycleNetwork) {}
    func networkDidCalculate(_ network: BicycleNetwork) {}
}

public class BicycleNetwork {

    public private(set) var fields = Set<AnyField>()
    var calculators = Set<AnyCalculator>()
    var setters = [AnySetter]()

    var rollbackCalculators = Set<AnyCalculator>()
    var usedRelationships = Set<Relationship>()

    public var autoCalc = true
    var numSettersInserted = 0

    public weak var delegate: BicycleNetworkDelegate?

    // MARK: General

    public init() {
    }

    func doAutoCalc() {
        if autoCalc {
            setFields()
        }
    }

    // MARK: Rollbacks

    func addRollback(calculator: AnyCalculator) {
        rollbackCalculators.insert(calculator)
    }

    func rollbackUsedRelationship(relationship: Relationship) {
        usedRelationships.remove(relationship)
    }

    func markRollbackCalculatorsAsUsed() {
        rollbackCalculators.forEach { $0.wasUsed = true }
    }

    // MARK: Used Relationships

    func addUsedRelationship(relationship: Relationship) {
        usedRelationships.insert(relationship)
    }

    func relationshipWasUsed(relationship: Relationship) -> Bool {
        return usedRelationships.contains(relationship)
    }

    func clearUsedRelationships() {
        usedRelationships.removeAll()
    }

    // MARK: Fields

    public func adoptField(field: AnyField) {
        self.fields.insert(field)
        field.network = self
    }

    public func dropField(field: AnyField) {
        self.fields.remove(field)
        field.network = nil
    }

    func clearFields() {
        fields.forEach { $0.code = .clear }
    }

    func getField(id: FieldID) -> AnyField? {
        return fields.first { $0.id == id }
    }

    // MARK: Calculators

    public func connectCalculators() {
        AnyField.calculatorFactories
            .compactMap { $0.makeOrphanCalculator(network: self) }
            .forEach { self.adoptCalculator(calculator: $0) }
    }

    func adoptCalculator(calculator: AnyCalculator) {
        calculators.insert(calculator)
    }

    func dropCalculator(calculator: AnyCalculator) {
        calculators.remove(calculator)
    }

    func clearCalculators() {
        self.calculators.forEach { $0.wasUsed = false }
    }

    func resetCalcCountPerField() {
        fields.forEach { $0.zeroNumTargettingCalculators() }
    }

    func countCalcsPerField() {
        resetCalcCountPerField()
        calculators.forEach { $0.anyTarget().incrementNumTargettingCalculators() }
    }

    // MARK: Setters

    public func adoptSetter(setter: AnySetter) {
        setter.network = self
        setter.insertOrder = numSettersInserted
        numSettersInserted += 1
        let ac = self.autoCalc
        self.autoCalc = false
        if setter.isUserProvided() {
            dropUserProvidedSetters(field: setter.anyTarget())
        }
        setters.append(setter)
        self.autoCalc = ac
        doAutoCalc()
    }

    func dropASetter(field: AnyField) -> Bool {
        if let setterIndex = setters.firstIndex(where: { $0.isMatch(field: field) }) {
            let setter = setters.remove(at: setterIndex)
            setter.network = nil
            return true
        }
        return false
    }

    func dropSetter(setter: AnySetter) {
        if let setterIndex = setters.firstIndex(where: { $0 === setter }) {
            let setter = setters.remove(at: setterIndex)
            setter.network = nil
            doAutoCalc()
        }
    }

    func dropSetters(field: AnyField) {
        while dropASetter(field: field) {
            // do nothing
        }
        doAutoCalc()
    }

    public func setFields() {
        delegate?.networkWillCalculate(self)
        clearFields()
        clearUsedRelationships()
        clearCalculators()
        countCalcsPerField()
        sortSetters()

        let len = setters.count
        var done = (len == 0)
        while !done {
            for i in 0..<len {
                rollbackCalculators.removeAll()
                if setters[i].setField() {
                    // If the setter was successful, mark the list of rollback calculators as used
                    // this way we can not use others in the same relationship
                    markRollbackCalculatorsAsUsed()
                    // break out of this loop so that we can retry old setters that failed
                    break
                } else {
                    // if the setter was not successful, undo the effects of all the calculators
                    rollback()
                }
                if i == len-1 {
                    done = true
                }
            }
        }
        delegate?.networkDidCalculate(self)
    }

    func sortSetters() {
        if setters.count < 2 {
            return
        }

        var done = false
        while !done {
            done = true
            for i in 0..<(setters.count-1) {
                if setters[i+1] < setters[i] {
                    // swap them
                    let temp = setters[i]
                    setters[i] = setters[i+1]
                    setters[i+1] = temp
                    done = false
                }
            }
        }
    }

    func rollback() {
        rollbackCalculators.forEach { rollback in
            rollback.resetField()
            rollback.wasUsed = false
            let r = rollback.makeRelationship()
            rollbackUsedRelationship(relationship: r)
        }
    }

    func dropUserProvidedSetters(field: AnyField) {
        setters.removeAll { setter in
            return setter.isUserProvided() && setter.isMatch(field: field)
        }

    }

}
