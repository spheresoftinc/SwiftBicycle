//
//  Relationship.swift
//  
//
//  Copyright 2020 Spheresoft
//

import Foundation

public class Relationship: Equatable, Hashable {

    var fieldIDs = Set<FieldID>()
    public func addSourceField(fieldID: FieldID) {
        fieldIDs.insert(fieldID)
    }

    public static func == (lhs: Relationship, rhs: Relationship) -> Bool {
        return lhs.fieldIDs == rhs.fieldIDs
    }

    public func hash(into hasher: inout Hasher) {
        fieldIDs.hash(into: &hasher)
    }
}
