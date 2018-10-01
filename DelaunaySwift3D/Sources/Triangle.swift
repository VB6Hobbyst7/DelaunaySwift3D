//
//  Triangle.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

/// A simple struct representing 3 vertices
public struct Triangle {
  
    public init(vertex1: Vertex, vertex2: Vertex, vertex3: Vertex) {
        self.vertex1 = vertex1
        self.vertex2 = vertex2
        self.vertex3 = vertex3
    }
  
    public let vertex1: Vertex
    public let vertex2: Vertex
    public let vertex3: Vertex
}
