// s3-make-hello-node.swift
// makeHelloNode() 헬퍼 함수 - Step 1: SCNText 생성

private func makeHelloNode() -> SCNNode {
    // SCNText 지오메트리 생성
    let textGeometry = SCNText(string: "Hello 👋", extrusionDepth: 1.0)
    textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
    textGeometry.flatness = 0.1

    let textNode = SCNNode(geometry: textGeometry)
    return textNode
}
