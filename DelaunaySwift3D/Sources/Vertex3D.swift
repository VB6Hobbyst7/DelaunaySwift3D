//
//  Vertex3D.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

public struct Vertex3D {
  
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
  
    public let x: Double
    public let y: Double
    public let z: Double
}

extension Vertex3D: Equatable {
    static public func ==(lhs: Vertex3D, rhs: Vertex3D) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
    }
}

extension Vertex3D: Hashable {
    public var hashValue: Int {
        return "\(x)\(y)\(z)".hashValue
    }
}


extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

extension Array where Element: Hashable {
    func removeDuplicates() -> [Element] {
        return Array(Set(self))
    }
}
