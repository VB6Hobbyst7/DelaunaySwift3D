//
//  Edge.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

import Cocoa

struct Edge {
    let vertex1: Vertex
    let vertex2: Vertex
}

extension Edge: Equatable {}

func ==(lhs: Edge, rhs: Edge) -> Bool {
    return lhs.vertex1 == rhs.vertex1 && lhs.vertex2 == rhs.vertex2 || lhs.vertex1 == rhs.vertex2 && lhs.vertex2 == rhs.vertex1
}

extension Edge: Hashable {
    var hashValue: Int {
        return "\(vertex1.x)\(vertex1.y)\(vertex2.x)\(vertex2.y)".hashValue
    }
}
