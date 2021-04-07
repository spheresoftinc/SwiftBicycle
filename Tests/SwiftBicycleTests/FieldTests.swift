//
//  FieldTests.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation
import XCTest
@testable import SwiftBicycle

class FieldTests: XCTestCase {

    func testField() {
        let network = BicycleNetwork()
        let f = Field<Int>()
        network.adoptField(field: f)
        XCTAssertEqual(f.code, Field.Code.clear)
    }

    func testFieldCalculator() {
        let network = BicycleNetwork()

        let feet = Field<Double>()
        network.adoptField(field: feet)

        let inches = Field<Double>()
        network.adoptField(field: inches)

        Calculator1OpFactory.registerFactory(target: inches, operand1: feet) { $0 * 12.0 }
        Calculator1OpFactory.registerFactory(target: feet, operand1: inches) { $0 / 12.0 }

        network.connectCalculators()

        let setter = SetterConstant(target: feet, value: 3.0)
        network.adoptSetter(setter: setter)

        XCTAssertEqual(feet.code, .set)
        XCTAssertEqual(feet.value(), 3.0)

        XCTAssertEqual(inches.code, .calced)
        XCTAssertEqual(inches.value(), 36.0)

        let setter2 = SetterConstant(target: inches, value: 12.0)
        network.adoptSetter(setter: setter2)
        XCTAssertEqual(feet.code, .calced)
        XCTAssertEqual(feet.value(), 1.0)
        XCTAssertEqual(inches.code, .set)
        XCTAssertEqual(inches.value(), 12.0)
    }

    func test2Op() {
        let network = BicycleNetwork()

        let num1 = Field<Double>()
        network.adoptField(field: num1)

        let num2 = Field<Double>()
        network.adoptField(field: num2)

        let sum = Field<Double>()
        network.adoptField(field: sum)

        Calculator2OpFactory.registerFactory(target: sum, operand1: num1, operand2: num2) { (a, b) -> Double in a + b }
        Calculator2OpFactory.registerFactory(target: num1, operand1: sum, operand2: num2) { (a, b) -> Double in a - b }
        Calculator2OpFactory.registerFactory(target: num2, operand1: sum, operand2: num1) { (a, b) -> Double in a - b }

        network.connectCalculators()

        network.adoptSetter(setter: SetterConstant(target: num1, value: 3.0))
        network.adoptSetter(setter: SetterConstant(target: num2, value: 4.0))

        XCTAssertEqual(num1.code, .set)
        XCTAssertEqual(num1.value(), 3.0)
        XCTAssertEqual(num2.code, .set)
        XCTAssertEqual(num2.value(), 4.0)

        XCTAssertEqual(sum.code, .calced)
        XCTAssertEqual(sum.value(), 7.0)

        network.adoptSetter(setter: SetterConstant(target: sum, value: 12.0))
        XCTAssertEqual(num1.code, .calced)
        XCTAssertEqual(num1.value(), 8.0)
        XCTAssertEqual(num2.code, .set)
        XCTAssertEqual(num2.value(), 4.0)

        XCTAssertEqual(sum.code, .set)
        XCTAssertEqual(sum.value(), 12.0)
    }

    func testFieldCalculatorErrors() {
        let network = BicycleNetwork()

        let feet = Field<Double>()
        network.adoptField(field: feet)

        let inches = Field<Double>()
        network.adoptField(field: inches)

        Calculator1OpFactory.registerFactory(target: inches, operand1: feet) { $0 * 12.0 }
        Calculator1OpFactory.registerFactory(target: feet, operand1: inches) { $0 / 12.0 }

        network.connectCalculators()

        let setter = SetterError(target: feet, text: "hello")
        network.adoptSetter(setter: setter)

        XCTAssertEqual(feet.code, .error(text: "hello"))
        XCTAssertEqual(inches.code, .clear)

        let setter2 = SetterConstant(target: inches, value: 12.0)
        network.adoptSetter(setter: setter2)
        XCTAssertEqual(feet.code, .calced)
        XCTAssertEqual(feet.value(), 1.0)
        XCTAssertEqual(inches.code, .set)
        XCTAssertEqual(inches.value(), 12.0)

        network.dropSetter(setter: setter2)
        XCTAssertEqual(feet.code, .error(text: "hello"))
        XCTAssertEqual(inches.code, .clear)
    }
}
