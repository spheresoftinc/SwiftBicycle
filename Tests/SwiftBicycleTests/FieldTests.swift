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
        let collection = FieldCollection()
        let f = Field<Int>(id: FieldID(), collection: collection)
        collection.adoptField(field: f)
        XCTAssertEqual(f.code, Field.Code.clear)
    }

    func testFieldCalculator() {
        let collection = FieldCollection()

        let feet = Field<Double>(id: FieldID(), collection: collection)
        collection.adoptField(field: feet)

        let inches = Field<Double>(id: FieldID(), collection: collection)
        collection.adoptField(field: inches)


        let _ = CalculatorInitializer1Op(targetId: inches.id, operator1Id: feet.id) { $0 * 12.0 }
        let _ = CalculatorInitializer1Op(targetId: feet.id, operator1Id: inches.id) { $0 / 12.0 }

        collection.connectCalculators()

        let setter = SetterConstant(collection: collection, target: feet, value: 3.0)
        collection.adoptSetter(setter: setter)

        XCTAssertEqual(feet.code, .set)
        XCTAssertEqual(feet.value(), 3.0)

        XCTAssertEqual(inches.code, .calced)
        XCTAssertEqual(inches.value(), 36.0)

        let setter2 = SetterConstant(collection: collection, target: inches, value: 12.0)
        collection.adoptSetter(setter: setter2)
        XCTAssertEqual(feet.code, .calced)
        XCTAssertEqual(feet.value(), 1.0)
        XCTAssertEqual(inches.code, .set)
        XCTAssertEqual(inches.value(), 12.0)
    }

}
