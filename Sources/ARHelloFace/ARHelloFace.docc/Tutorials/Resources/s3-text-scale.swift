// s3-text-scale.swift - Step 3: 크기 조절
private func makeHelloNode() -> SCNNode {
    let textGeometry = SCNText(string: "Hello 👋", extrusionDepth: 1.0)
    textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.white
    material.emission.contents = UIColor.white
    textGeometry.materials = [material]

    let textNode = SCNNode(geometry: textGeometry)
    // SCNText 기본 크기는 매우 크므로 0.002배로 축소 (약 2mm/unit)
    let scale: Float = 0.002
    textNode.scale = SCNVector3(scale, scale, scale)
    return textNode
}
