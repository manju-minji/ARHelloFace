// s2-did-update.swift
/// ARKit이 매 프레임마다 앵커 transform을 자동으로 node에 동기화합니다.
/// 추가 처리가 필요한 경우 이 메서드에서 구현합니다.
func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let faceAnchor = anchor as? ARFaceAnchor else { return }

    // faceAnchor.blendShapes로 표정 데이터 접근 가능 (선택적 확장)
    // 예: let smileLeft = faceAnchor.blendShapes[.mouthSmileLeft]
    _ = faceAnchor  // 현재는 ARKit이 transform을 자동 처리하므로 추가 작업 불필요
}
