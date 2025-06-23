public actor FysEngActor {
    // … existing init …

    public func simulate(_ rep: RepStruct) async throws -> RepStruct {
        // GPU path stub omitted…
        // CPU fallback:
        var result = rep
        let positions = rep.cells.map { $0.position }    // assume SIMD2<Float>
        let velocities = rep.cells.map { $0.velocity }  // SIMD2<Float>
        // Use your tuned constants or defaults
        let forces = FysEngine.computeForces(
            positions: positions,
            velocities: velocities,
            A: 1.0, B: 0.5, C: 0.1
        )
        // Apply forces → integrate positions/velocities (Euler step)
        for i in 0..<rep.cells.count {
            let cell = rep.cells[i]
            let a = forces[i]
            // simple dt = 1/fps, say dt=1/60
            let dt: Float = 1/60
            let newV = cell.velocity + a * dt
            let newP = cell.position + newV * dt
            result.cells[i].velocity = newV
            result.cells[i].position = newP
        }
        return result
    }
}
