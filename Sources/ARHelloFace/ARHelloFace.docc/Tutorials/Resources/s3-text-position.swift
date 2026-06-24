// s3-text-position.swift - 얼굴 위 위치 설정
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

    // 텍스트 가로 폭을 구해 중앙 정렬
    let (min, max) = textNode.boundingBox
    let width = (max.x - min.x) * scale
    // Y = 0.15 → 얼굴 앵커 원점에서 위로 15cm
    textNode.position = SCNVector3(-width / 2, 0.15, 0)
    return textNode
}
