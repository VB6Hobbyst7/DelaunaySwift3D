//
//  Circumcircle3D.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//

/// Represents a bounding circle for a set of 3 vertices
internal struct Circumcircle3D {
    let vertex1: Vertex3D
    let vertex2: Vertex3D
    let vertex3: Vertex3D
    let x: Double
    let y: Double
    let rsqr: Double
}

internal struct Circumsphere3D {
    let vertex1: Vertex3D
    let vertex2: Vertex3D
    let vertex3: Vertex3D
    let vertex4: Vertex3D
    let x: Double
    let y: Double
    let z: Double
    let rsqr: Double
}
