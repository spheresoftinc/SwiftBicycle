//
//  FieldValueEquatable.swift
//  
//
//  Created by Louis Franco on 4/9/21.
//

import Foundation

public protocol FieldValueEquatable {
    func fieldValueIsEqualTo(value: FieldValueEquatable) -> Bool
}
