//
//  Edge3D.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

import Cocoa

struct Edge3D {
    let vertex1: Vertex3D
    let vertex2: Vertex3D
}

extension Edge3D: Equatable {}

func ==(lhs: Edge3D, rhs: Edge3D) -> Bool {
    return lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2 || lhs.vertex1 == rhs.vertex2 && lhs.vertex2 == rhs.vertex1
}

extension Edge3D: Hashable {
    var hashValue: Int {
        return "\(vertex1.x)\(vertex1.y)\(vertex1.z)\(vertex2.x)\(vertex2.y)\(vertex2.z)".hashValue
    }
}
