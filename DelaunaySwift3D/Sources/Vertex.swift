//
//  Vertex.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

public struct Vertex {
  
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
  
    public let x: Double
    public let y: Double
}

extension Vertex: Equatable {
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

extension Vertex: Hashable {
    public var hashValue: Int {
        return "\(x)\(y)".hashValue
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
