//
//  Triangle3D.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

/// A simple struct representing 3 vertices
public struct Triangle3D {
  
    public init(vertex1: Vertex3D, vertex2: Vertex3D, vertex3: Vertex3D) {
        self.vertex1 = vertex1
        self.vertex2 = vertex2
        self.vertex3 = vertex3
    }
  
    public let vertex1: Vertex3D
    public let vertex2: Vertex3D
    public let vertex3: Vertex3D
}
