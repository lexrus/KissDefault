//
//  KissDefault.swift
//  KissDefault
//
//  Created by Lex on 2020/6/12.
//  Copyright © 2020 Lex Tang. All rights reserved.
//

import Foundation


@propertyWrapper
public struct Kiss<T> {

    var `default`: T
    var userDefaults: UserDefaults

    public var wrappedValue: T {
        get {
            let key = demangleVariableNameFromCallstack()

            guard
                let obj = userDefaults.object(forKey: key) as? T,
                let optional = obj as? AnyOptional, !optional.isNil
            else {
                return `default`
            }

            return obj
        }
        set {
            let key = demangleVariableNameFromCallstack()

            if let optional = newValue as? AnyOptional, optional.isNil {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.setValue(newValue, forKey: key)
            }
        }
    }

    public init(default: T, userDefaults: UserDefaults = .standard) {
        self.default = `default`
        self.userDefaults = .standard
    }

}

@propertyWrapper
public struct KissCodable<T: Codable> {

    var `default`: T
    var userDefaults: UserDefaults

    public var wrappedValue: T {
        get {
            let key = demangleVariableNameFromCallstack()

            if
                let data = userDefaults.object(forKey: key) as? Data,
                let value = try? JSONDecoder().decode(T.self, from: data)
            {
                return value

            }
            return `default`
        }
        set {
            let key = demangleVariableNameFromCallstack()

            if let data = try? JSONEncoder().encode(newValue) {
                userDefaults.set(data, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }

    public init(default: T, userDefaults: UserDefaults = .standard) {
        self.default = `default`
        self.userDefaults = .standard
    }

}

struct AnyEncodable: Encodable {
    let value: Encodable

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
}

extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

public extension Kiss where T: ExpressibleByNilLiteral {

    init(userDefaults: UserDefaults = .standard) {
        self.init(default: nil, userDefaults: userDefaults)
    }

}

func demangleVariableNameFromCallstack() -> String {
    let stacks = Thread.callStackSymbols
    //     Since we have the source code, we may guarantee the property name is located in the 3rd symbol
    //     0 KissDefault 0x0000000100001db4 #demangleWrappedName
    //     1 KissDefault 0x0000000100001769 $s11KissDefault0A0V12wrappedValuexvg + 254
    //     2 KissDefault 0x0000000100002efb $s11KissDefault3StrV9staticVarSSvgZ + 235  <- real property

    guard stacks.count > 3 else {
        assertionFailure()
        return ""
    }

    let stack = stacks[2]

    guard let symbolRange = stack.range(
        of: #"\$s\S+"#,
        options: [.regularExpression, .caseInsensitive]
    ) else {
        assertionFailure()
        return ""
    }

    let symbol = String(stack[symbolRange])

    return demangleVariableName(of: symbol)
}

func demangleVariableName(of symbol: String) -> String {
    let ranges = symbol.ranges(of: "[VC]\\d+(?=\\D.*[sSA35])")

    let invalidCharacterSet = CharacterSet(charactersIn: " +")

    for range in ranges {
        let sub = symbol[range]

        guard sub.hasPrefix("V") || sub.hasPrefix("C") else {
            continue
        }

        let countStr = sub.trimmingCharacters(in: CharacterSet.decimalDigits.inverted)

        guard countStr.count > 0, let count = Int(countStr), count > 0 else {
            continue
        }

        guard sub.endIndex.utf16Offset(in: symbol) + count <= symbol.count else {
            continue
        }

        let variableRange = sub.endIndex ..< symbol.index(sub.endIndex, offsetBy: count)
        let variableName = symbol[variableRange]

        if variableName.count == count, variableName.trimmingCharacters(in: invalidCharacterSet).count == count {
            return String(variableName)
        }
    }

    // Failover
    return symbol.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
}

extension String {
    func ranges(of regEx: String) -> [Range<Index>] {
        var ranges: [Range<Index>] = []

        while let range = range(
            of: regEx,
            options: .regularExpression,
            range: (ranges.last?.upperBound ?? startIndex)..<endIndex
            ) {
                ranges.append(range)
        }
        return ranges
    }
}
