import SwiftUI
import ARKit
import SceneKit

struct ARFaceView: UIViewRepresentable {

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true

        // ARFaceTrackingConfiguration 생성 및 세션 시작
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
