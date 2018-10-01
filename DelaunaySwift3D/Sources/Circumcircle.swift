//
//  Circumcircle.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

/// Represents a bounding circle for a set of 3 vertices
internal struct Circumcircle {
    let vertex1: Vertex
    let vertex2: Vertex
    let vertex3: Vertex
    let x: Double
    let y: Double
    let rsqr: Double
}
