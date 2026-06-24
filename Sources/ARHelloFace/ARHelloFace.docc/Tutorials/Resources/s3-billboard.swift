// s3-billboard.swift - Billboard Constraint 적용
private func makeHelloNode() -> SCNNode {
    let textGeometry = SCNText(string: "Hello 👋", extrusionDepth: 1.0)
    textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.white
    material.emission.contents = UIColor.white
    textGeometry.materials = [material]

    let textNode = SCNNode(geometry: textGeometry)
    let scale: Float = 0.002
    textNode.scale = SCNVector3(scale, scale, scale)

    let (min, max) = textNode.boundingBox
    let width = (max.x - min.x) * scale
    textNode.position = SCNVector3(-width / 2, 0.15, 0)

    // 항상 카메라를 향하도록 - 얼굴이 옆을 봐도 텍스트는 정면 유지
    let billboard = SCNBillboardConstraint()
    billboard.freeAxes = .Y
    textNode.constraints = [billboard]

    return textNode
}
