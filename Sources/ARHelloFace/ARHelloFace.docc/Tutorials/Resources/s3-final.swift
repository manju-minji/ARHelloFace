// s3-final.swift - renderer(nodeFor:)에 Hello 노드 추가
func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    guard anchor is ARFaceAnchor else { return nil }

    let faceNode = SCNNode()
    // makeHelloNode()를 자식으로 추가 → 얼굴을 따라 텍스트가 이동
    faceNode.addChildNode(makeHelloNode())
    return faceNode
}
