// s2-coordinator-adopt.swift
import SwiftUI
import ARKit
import SceneKit

struct ARFaceView: UIViewRepresentable {

    // Coordinator를 생성합니다. UIKit의 delegate 역할을 담당합니다.
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator  // delegate 연결
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    // ARSCNViewDelegate를 채택하는 Coordinator
    // SwiftUI 구조체는 delegate가 될 수 없으므로 NSObject 클래스로 분리합니다.
    class Coordinator: NSObject, ARSCNViewDelegate {
    }
}
