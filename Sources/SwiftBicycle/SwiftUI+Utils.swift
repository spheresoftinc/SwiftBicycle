//
//  SwiftUI+Utils.swift
//  
//
//  Created by Louis Franco on 4/6/21.
//

import Foundation
import SwiftUI

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
public extension TextField where Label == Text {
    init<S, T>(_ title: S, field: Binding<Field<T>>) where S : StringProtocol, T: Equatable & LosslessStringConvertible  {
        self.init(title, value: field.bind, formatter: FieldFormatter<T>(formatter: field.formatter.wrappedValue))
    }
}
