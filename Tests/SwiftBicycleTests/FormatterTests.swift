//
//  File.swift
//  
//
//  Created by Louis Franco on 4/10/22.
//

import Foundation
import Foundation
import XCTest
@testable import SwiftBicycle

class FormatterTests: XCTestCase {
    var nf = NumberFormatter()

    override func setUp() {
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 4
        nf.numberStyle = .decimal
        super.setUp()
    }

    func testCommaWorksInFormatter() {
        var obj: AnyObject?
        var error: NSString?
        XCTAssertTrue(nf.getObjectValue(&obj, for: "1,000", errorDescription: &error))
        XCTAssertEqual(obj as! Double, 1000)
    }

    func testCommaWorksInFieldFormatter() {
        let ff = FieldFormatter<Double>(formatter: nf)

        var obj: AnyObject?
        var error: NSString?
        XCTAssertTrue(ff.getObjectValue(&obj, for: "1,000", errorDescription: &error))
        XCTAssertEqual((obj as! FieldValue<Double>).value!, 1000)
    }
}
