import SwiftUI
import ARKit
import SceneKit

struct ARFaceView: UIViewRepresentable {

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()

        // 개발 중 디버깅용 통계 표시
        sceneView.showsStatistics = true

        // 씬의 조명을 카메라 위치 기반으로 자동 설정
        sceneView.autoenablesDefaultLighting = true

        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
