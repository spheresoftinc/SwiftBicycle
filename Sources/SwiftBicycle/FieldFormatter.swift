//
//  FieldFormatter.swift
//  
//
//  Created by Louis Franco on 4/6/21.
//

import Foundation

class FieldFormatter<T> : Formatter where T: LosslessStringConvertible {
    let formatter: Formatter?

    public init(formatter: Formatter?) {
        self.formatter = formatter
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func string(for: Any?) -> String? {
        guard let field = `for` as? FieldValue<T> else {
            return ""
        }
        guard let value = field.value else {
            return field.text ?? ""
        }
        return self.formatter?.string(for: value) ?? String(value)
    }

    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard string != "" else {
            obj?.pointee = FieldValue<T>(value: nil, text: nil)
            return true
        }

        // If we have a formatter, use it
        if let formatter = self.formatter {
            if formatter.getObjectValue(obj, for: string, errorDescription: error) {
                if let value = obj?.pointee as? T {
                    obj?.pointee = FieldValue<T>(value: value, text: string)
                    return true
                }
            }
            return false
        }

        // Otherwise, we try the LosslessStringConvertible init
        guard let value = T(string) else {
            // This will make the FieldValue binder (below) use an error setter
            obj?.pointee = FieldValue<T>(value: nil, text: string)
            return true
        }
        obj?.pointee = FieldValue<T>(value: value, text: string)
        return true
    }
}

class FieldValue<T>: NSObject {
    let value: T?
    let text: String?
    init(value: T?, text: String? = nil) {
        self.value = value
        self.text = text
    }
}

extension Field where Field.ValueType: Equatable & LosslessStringConvertible {
    var bind: FieldValue<ValueType> {
        get {
            if self.code == .clear {
                return FieldValue(value: nil)
            } else if case let .error(text) = self.code {
                return FieldValue(value: nil, text: text)
            }
            return FieldValue(value: self.value(), text: self.text)
        }
        set {
            guard let v = newValue.value else {
                guard let text = newValue.text else {
                    self.network?.dropUserProvidedSetters(field: self)
                    return
                }
                self.setError(text: text)
                return
            }
            self.set(value: v)
        }
    }
}
