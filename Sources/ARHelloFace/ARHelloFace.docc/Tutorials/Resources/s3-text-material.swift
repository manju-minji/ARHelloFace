// s3-text-material.swift - Step 2: 머티리얼 설정
private func makeHelloNode() -> SCNNode {
    let textGeometry = SCNText(string: "Hello 👋", extrusionDepth: 1.0)
    textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    textGeometry.flatness = 0.1

    // 흰색 발광 머티리얼 - 조명에 상관없이 항상 밝게 보임
    let material = SCNMaterial()
    material.diffuse.contents = UIColor.white
    material.emission.contents = UIColor.white
    textGeometry.materials = [material]

    let textNode = SCNNode(geometry: textGeometry)
    return textNode
}
