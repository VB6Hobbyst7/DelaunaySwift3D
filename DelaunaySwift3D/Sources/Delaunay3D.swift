//
//  Delaunay3D.swift
//  DelaunaySwift3D_macOS
//
//  Created by Yota Odaka on 2018/10/01.
//  Copyright © 2018 Yota Odaka. All rights reserved.
//
//

import Darwin

open class Delaunay3D {
  
    public init() { }
  
    fileprivate func supertetrahedron(_ vertices: [Vertex3D]) -> [Vertex3D] {
        var xmin = Double(Int32.max)
        var ymin = Double(Int32.max)
        var zmin = Double(Int32.max)
        var xmax = Double(Int32.min)
        var ymax = Double(Int32.min)
        var zmax = Double(Int32.min)
      
        for i in 0..<vertices.count {
            if vertices[i].x < xmin { xmin = vertices[i].x }
            if vertices[i].x > xmax { xmax = vertices[i].x }
            if vertices[i].y < ymin { ymin = vertices[i].y }
            if vertices[i].y > ymax { ymax = vertices[i].y }
            if vertices[i].z < zmin { zmin = vertices[i].z }
            if vertices[i].z > zmax { zmax = vertices[i].z }
        }
      
        let dx = xmax - xmin
        let dy = ymax - ymin
        let dz = zmax - zmin
        let dmax = max(dx, dy, dz)
        let xmid = xmin + dx * 0.5
        let ymid = ymin + dy * 0.5
        let zmid = zmin + dz * 0.5
      
        return [
            Vertex3D(x: xmid - 20 * dmax, y: ymid - dmax, z: zmid - dmax),
            Vertex3D(x: xmid + 20 * dmax, y: ymid - dmax, z: zmid - dmax),
            Vertex3D(x: xmid, y: ymid - dmax, z: zmid + 20 * dmax),
            Vertex3D(x: xmid, y: ymid + 20 * dmax, z: zmid)
        ]
    }
  
    /* Generates a supertraingle containing all other triangles */
//    fileprivate func supertriangle(_ vertices: [Vertex3D]) -> [Vertex3D] {
//        var xmin = Double(Int32.max)
//        var ymin = Double(Int32.max)
//        var xmax = Double(Int32.min)
//        var ymax = Double(Int32.min)
//
//        for i in 0..<vertices.count {
//            if vertices[i].x < xmin { xmin = vertices[i].x }
//            if vertices[i].x > xmax { xmax = vertices[i].x }
//            if vertices[i].y < ymin { ymin = vertices[i].y }
//            if vertices[i].y > ymax { ymax = vertices[i].y }
//        }
//
//        let dx = xmax - xmin
//        let dy = ymax - ymin
//        let dmax = max(dx, dy)
//        let xmid = xmin + dx * 0.5
//        let ymid = ymin + dy * 0.5
//
//        return [
//            Vertex3D(x: xmid - 20 * dmax, y: ymid - dmax),
//            Vertex3D(x: xmid, y: ymid + 20 * dmax),
//            Vertex3D(x: xmid + 20 * dmax, y: ymid - dmax)
//        ]
//    }
  
    fileprivate func circumsphere(_ i: Vertex3D, j: Vertex3D, k: Vertex3D, l: Vertex3D) -> Circumsphere3D {
        let x1 = i.x, y1 = i.y, z1 = i.z
        let x2 = j.x, y2 = j.y, z2 = j.z
        let x3 = k.x, y3 = k.y, z3 = k.z
        let x4 = l.x, y4 = l.y, z4 = l.z
      
        let x1_2 = x1 * x1, x2_2 = x2 * x2, x3_2 = x3 * x3, x4_2 = x4 * x4
        let y1_2 = y1 * y1, y2_2 = y2 * y2, y3_2 = y3 * y3, y4_2 = y4 * y4
        let z1_2 = z1 * z1, z2_2 = z2 * z2, z3_2 = z3 * z3, z4_2 = z4 * z4

        let a1 = 2 * (x1 - x2), b1 = 2 * (y1 - y2), c1 = 2 * (z1 - z2)
        let d1 = x1_2 - x2_2 + y1_2 - y2_2 + z1_2 - z2_2

        let a2 = 2 * (x1 - x3), b2 = 2 * (y1 - y3), c2 = 2 * (z1 - z3)
        let d2 = x1_2 - x3_2 + y1_2 - y3_2 + z1_2 - z3_2

        let a3 = 2 * (x1 - x4), b3 = 2 * (y1 - y4), c3 = 2 * (z1 - z4)
        let d3 = x1_2 - x4_2 + y1_2 - y4_2 + z1_2 - z4_2

        let denominator = a1 * b2 * c3 + a2 * b3 * c1 + a3 * b1 * c2 - a3 * b2 * c1 - a2 * b1 * c3 - a1 * b3 * c2
        let xnumerator =  b1 * c2 * d3 + b2 * c3 * d1 + b3 * c1 * d2 - b3 * c2 * d1 - b2 * c1 * d3 - b1 * c3 * d2
        let ynumerator =  a1 * d2 * c3 + a2 * d3 * c1 + a3 * d1 * c2 - a3 * d2 * c1 - a2 * d1 * c3 - a1 * d3 * c2
        let znumerator =  a1 * b2 * d3 + a2 * b3 * d1 + a3 * b1 * d2 - a3 * b2 * d1 - a2 * b1 * d3 - a1 * b3 * d2

        let cx = xnumerator / denominator
        let cy = ynumerator / denominator
        let cz = znumerator / denominator
      
        let dx = x2 - cx
        let dy = y2 - cy
        let dz = z2 - cz
        let rsqr = dx * dx + dy * dy + dz * dz
      
        return Circumsphere3D(vertex1: i, vertex2: j, vertex3: k, vertex4: l, x: cx, y: cy, z: cz, rsqr: rsqr)
    }
  
    /* Calculate a circumcircle for a set of 3 vertices */
//    fileprivate func circumcircle(_ i: Vertex3D, j: Vertex3D, k: Vertex3D) -> Circumcircle3D {
//        let x1 = i.x
//        let y1 = i.y
//        let x2 = j.x
//        let y2 = j.y
//        let x3 = k.x
//        let y3 = k.y
//        let xc: Double
//        let yc: Double
//
//        let fabsy1y2 = abs(y1 - y2)
//        let fabsy2y3 = abs(y2 - y3)
//
//        if fabsy1y2 < Double.ulpOfOne {
//            let m2 = -((x3 - x2) / (y3 - y2))
//            let mx2 = (x2 + x3) / 2
//            let my2 = (y2 + y3) / 2
//            xc = (x2 + x1) / 2
//            yc = m2 * (xc - mx2) + my2
//        } else if fabsy2y3 < Double.ulpOfOne {
//            let m1 = -((x2 - x1) / (y2 - y1))
//            let mx1 = (x1 + x2) / 2
//            let my1 = (y1 + y2) / 2
//            xc = (x3 + x2) / 2
//            yc = m1 * (xc - mx1) + my1
//        } else {
//            let m1 = -((x2 - x1) / (y2 - y1))
//            let m2 = -((x3 - x2) / (y3 - y2))
//            let mx1 = (x1 + x2) / 2
//            let mx2 = (x2 + x3) / 2
//            let my1 = (y1 + y2) / 2
//            let my2 = (y2 + y3) / 2
//            xc = (m1 * mx1 - m2 * mx2 + my2 - my1) / (m1 - m2)
//
//            if fabsy1y2 > fabsy2y3 {
//                yc = m1 * (xc - mx1) + my1
//            } else {
//                yc = m2 * (xc - mx2) + my2
//            }
//        }
//
//        let dx = x2 - xc
//        let dy = y2 - yc
//        let rsqr = dx * dx + dy * dy
//
//        return Circumcircle3D(vertex1: i, vertex2: j, vertex3: k, x: xc, y: yc, rsqr: rsqr)
//    }

    fileprivate func dedup(_ faces: [Vertex3D]) -> [Vertex3D] {
      
        var f = faces
        var a: Vertex3D?, b: Vertex3D?, c: Vertex3D?, l: Vertex3D?, m: Vertex3D?, n: Vertex3D?
      
        var j = f.count
        while j > 0 {
            j -= 1
            c = j < f.count ? f[j] : nil
            j -= 1
            b = j < f.count ? f[j] : nil
            j -= 1
            a = j < f.count ? f[j] : nil
          
            var i = j
            while i > 0 {
                i -= 1
                n = f[i]
                i -= 1
                m = f[i]
                i -= 1
                l = f[i]
              
                if (a == l && b == m && c == n) ||
                   (a == l && b == n && c == m) ||
                   (a == m && b == l && c == n) ||
                   (a == m && b == n && c == l) ||
                   (a == n && b == l && c == m) ||
                   (a == n && b == m && c == l) {
                    f.removeSubrange(j...j + 2)
                    f.removeSubrange(i...i + 2)
                    break
                }
            }
        }
      
        return f
    }

    fileprivate func dedup(faces: [Triangle3D]) -> [Triangle3D] {
      
        var f = faces
        var f1: Triangle3D?, f2: Triangle3D?
        var j = f.count
        while j > 0 {
            j -= 1
            f1 = j < f.count ? f[j]: nil
            var i = j
            while i > 0 {
                i -= 1
                f2 = f[i]
                if (f1!.vertex1 == f2!.vertex1 && f1!.vertex2 == f2!.vertex2 && f1!.vertex3 == f2!.vertex3) ||
                   (f1!.vertex1 == f2!.vertex1 && f1!.vertex2 == f2!.vertex3 && f1!.vertex3 == f2!.vertex2) ||
                   (f1!.vertex1 == f2!.vertex2 && f1!.vertex2 == f2!.vertex1 && f1!.vertex3 == f2!.vertex3) ||
                   (f1!.vertex1 == f2!.vertex2 && f1!.vertex2 == f2!.vertex3 && f1!.vertex3 == f2!.vertex1) ||
                   (f1!.vertex1 == f2!.vertex3 && f1!.vertex2 == f2!.vertex1 && f1!.vertex3 == f2!.vertex2) ||
                   (f1!.vertex1 == f2!.vertex3 && f1!.vertex2 == f2!.vertex2 && f1!.vertex3 == f2!.vertex1) {
                    f.remove(at: j)
                    f.remove(at: i)
                    break
                }
            }
        }
      
        return f
    }
//    fileprivate func dedup(_ edges: [Vertex3D]) -> [Vertex3D] {
//
//        var e = edges
//        var a: Vertex3D?, b: Vertex3D?, m: Vertex3D?, n: Vertex3D?
//
//        var j = e.count
//        while j > 0 {
//            j -= 1
//            b = j < e.count ? e[j] : nil
//            j -= 1
//            a = j < e.count ? e[j] : nil
//
//            var i = j
//            while i > 0 {
//                i -= 1
//                n = e[i]
//                i -= 1
//                m = e[i]
//
//                if (a == m && b == n) || (a == n && b == m) {
//                    e.removeSubrange(j...j + 1)
//                    e.removeSubrange(i...i + 1)
//                    break
//                }
//            }
//        }
//
//        return e
//    }

    open func triangulate(_ vertices: [Vertex3D]) -> [Triangle3D] {
      
        var _vertices = vertices.removeDuplicates()
      
        guard _vertices.count >= 4 else {
            return [Triangle3D]()
        }

        let n = _vertices.count
        var open = [Circumsphere3D]()
        var completed = [Circumsphere3D]()
        var faces = [Vertex3D]()
      
        /* Make an array of indices into the vertex array, sorted by the
        * vertices' x-position. */
        var indices = [Int](0..<n).sorted {  _vertices[$0].x < _vertices[$1].x }
      
        /* Next, find the vertices of the supertriangle (which contains all other
        * triangles) */
      
        _vertices += supertetrahedron(_vertices)
      
        /* Initialize the open list (containing the supertriangle and nothing
        * else) and the closed list (which is empty since we havn't processed
        * any triangles yet). */
        open.append(circumsphere(_vertices[n], j: _vertices[n + 1], k: _vertices[n + 2], l: _vertices[n + 3]))
      
        /* Incrementally add each vertex to the mesh. */
        for i in 0..<n {
            let c = indices[i]
          
            faces.removeAll()
          
            /* For each open triangle, check to see if the current point is
            * inside it's circumcircle. If it is, remove the triangle and add
            * it's edges to an edge list. */
            for j in (0..<open.count).reversed() {
              
                /* If this point is to the right of this triangle's circumcircle,
                * then this triangle should never get checked again. Remove it
                * from the open list, add it to the closed list, and skip. */
                let dx = _vertices[c].x - open[j].x
              
                if dx > 0 && dx * dx > open[j].rsqr {
                    completed.append(open.remove(at: j))
                    continue
                }
              
                /* If we're outside the circumcircle, skip this triangle. */
                let dy = _vertices[c].y - open[j].y
                let dz = _vertices[c].z - open[j].z
              
                if dx * dx + dy * dy + dz * dz - open[j].rsqr > Double.ulpOfOne {
                    continue
                }
              
                /* Remove the triangle and add it's edges to the edge list. */
                faces += [
                    open[j].vertex1, open[j].vertex2, open[j].vertex3,
                    open[j].vertex1, open[j].vertex2, open[j].vertex4,
                    open[j].vertex2, open[j].vertex3, open[j].vertex4,
                    open[j].vertex3, open[j].vertex1, open[j].vertex4
                ]
              
//                edges += [
//                    Edge(vertex1: open[j].vertex1, vertex2: open[j].vertex2),
//                    Edge(vertex1: open[j].vertex2, vertex2: open[j].vertex3),
//                    Edge(vertex1: open[j].vertex3, vertex2: open[j].vertex1)
//                ]
              
                open.remove(at: j)
            }
          
            /* Remove any doubled edges. */
            faces = dedup(faces)
          
            /* Add a new triangle for each edge. */
            var j = faces.count
            while j > 0 {
                j -= 1
                let p1 = faces[j]
                j -= 1
                let p2 = faces[j]
                j -= 1
                let p3 = faces[j]
              
//                open.append(circumcircle(a, j: b, k: _vertices[c]))
                open.append(circumsphere(p3, j: p2, k: p1, l: _vertices[c]))
            }
        }
      
        /* Copy any remaining open triangles to the closed list, and then
        * remove any triangles that share a vertex with the supertriangle,
        * building a list of triplets that represent triangles. */
        completed += open
      
        let ignored: Set<Vertex3D> = [_vertices[n], _vertices[n + 1], _vertices[n + 2], _vertices[n + 3]]

        let resultsArray = completed.compactMap { (circumSphere) -> [Triangle3D]? in

            let current: Set<Vertex3D> = [circumSphere.vertex1, circumSphere.vertex2, circumSphere.vertex3, circumSphere.vertex4]
            let intersection = ignored.intersection(current)
            if intersection.count > 0 {
                return nil
            }
//            let tetrahedron
            let p1 = circumSphere.vertex1
            let p2 = circumSphere.vertex2
            let p3 = circumSphere.vertex3
            let p4 = circumSphere.vertex4
            var triangles = [Triangle3D]()
            triangles.append(Triangle3D(vertex1: p1, vertex2: p2, vertex3: p3))
            triangles.append(Triangle3D(vertex1: p1, vertex2: p2, vertex3: p4))
            triangles.append(Triangle3D(vertex1: p2, vertex2: p3, vertex3: p4))
            triangles.append(Triangle3D(vertex1: p2, vertex2: p1, vertex3: p4))
            return triangles
//            return Triangle3D(vertex1: circumCircle.vertex1, vertex2: circumCircle.vertex2, vertex3: circumCircle.vertex3)
//            return Triangle3D(vertex1: circumCircle.vertex1, vertex2: circumCircle.vertex2, vertex3: circumCircle.vertex3)
        }

        var results = [Triangle3D]()
        for array in resultsArray {
            results += array
        }
        results = dedup(faces: results)

        /* Yay, we're done! */
        return results
    }


//    open func triangulate(_ vertices: [Vertex3D]) -> [Triangle3D] {
//
//        var _vertices = vertices.removeDuplicates()
//
//        guard _vertices.count >= 3 else {
//            return [Triangle3D]()
//        }
//
//        let n = _vertices.count
//        var open = [Circumcircle3D]()
//        var completed = [Circumcircle3D]()
//        var edges = [Vertex3D]()
//
//        /* Make an array of indices into the vertex array, sorted by the
//        * vertices' x-position. */
//        var indices = [Int](0..<n).sorted {  _vertices[$0].x < _vertices[$1].x }
//
//        /* Next, find the vertices of the supertriangle (which contains all other
//        * triangles) */
//
//        _vertices += supertriangle(_vertices)
//
//        /* Initialize the open list (containing the supertriangle and nothing
//        * else) and the closed list (which is empty since we havn't processed
//        * any triangles yet). */
//        open.append(circumcircle(_vertices[n], j: _vertices[n + 1], k: _vertices[n + 2]))
//
//        /* Incrementally add each vertex to the mesh. */
//        for i in 0..<n {
//            let c = indices[i]
//
//            edges.removeAll()
//
//            /* For each open triangle, check to see if the current point is
//            * inside it's circumcircle. If it is, remove the triangle and add
//            * it's edges to an edge list. */
//            for j in (0..<open.count).reversed() {
//
//                /* If this point is to the right of this triangle's circumcircle,
//                * then this triangle should never get checked again. Remove it
//                * from the open list, add it to the closed list, and skip. */
//                let dx = _vertices[c].x - open[j].x
//
//                if dx > 0 && dx * dx > open[j].rsqr {
//                    completed.append(open.remove(at: j))
//                    continue
//                }
//
//                /* If we're outside the circumcircle, skip this triangle. */
//                let dy = _vertices[c].y - open[j].y
//
//                if dx * dx + dy * dy - open[j].rsqr > Double.ulpOfOne {
//                    continue
//                }
//
//                /* Remove the triangle and add it's edges to the edge list. */
//                edges += [
//                    open[j].vertex1, open[j].vertex2,
//                    open[j].vertex2, open[j].vertex3,
//                    open[j].vertex3, open[j].vertex1
//                ]
//
////                edges += [
////                    Edge(vertex1: open[j].vertex1, vertex2: open[j].vertex2),
////                    Edge(vertex1: open[j].vertex2, vertex2: open[j].vertex3),
////                    Edge(vertex1: open[j].vertex3, vertex2: open[j].vertex1)
////                ]
//
//                open.remove(at: j)
//            }
//
//            /* Remove any doubled edges. */
//            edges = dedup(edges)
//
//            /* Add a new triangle for each edge. */
//            var j = edges.count
//            while j > 0 {
//
//                j -= 1
//                let b = edges[j]
//                j -= 1
//                let a = edges[j]
//                open.append(circumcircle(a, j: b, k: _vertices[c]))
//            }
//        }
//
//        /* Copy any remaining open triangles to the closed list, and then
//        * remove any triangles that share a vertex with the supertriangle,
//        * building a list of triplets that represent triangles. */
//        completed += open
//
//        let ignored: Set<Vertex3D> = [_vertices[n], _vertices[n + 1], _vertices[n + 2]]
//
//        let results = completed.flatMap { (circumCircle) -> Triangle3D? in
//
//            let current: Set<Vertex3D> = [circumCircle.vertex1, circumCircle.vertex2, circumCircle.vertex3]
//            let intersection = ignored.intersection(current)
//            if intersection.count > 0 {
//                return nil
//            }
//
//            return Triangle3D(vertex1: circumCircle.vertex1, vertex2: circumCircle.vertex2, vertex3: circumCircle.vertex3)
//        }
//
//        /* Yay, we're done! */
//        return results
//    }
}

