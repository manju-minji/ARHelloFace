import SwiftUI
import ARKit
import SceneKit
import UIKit  // SceneKit 텍스트에 쓰는 UIColor / UIFont

// MARK: - App 진입점

@main
struct ARHelloFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - ContentView

struct ContentView: View {
    var body: some View {
        // Face Tracking 지원 기기에서만 AR 화면을 표시합니다.
        if ARFaceTrackingConfiguration.isSupported {
            ARFaceView()
                .ignoresSafeArea()
        } else {
            VStack(spacing: 12) {
                Image(systemName: "faceid")
                    .font(.system(size: 48))
                Text("미지원 기기")
                    .font(.title2).bold()
                Text("Face Tracking은 TrueDepth 카메라가 있는\niPhone X 이상에서만 동작합니다.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

// MARK: - ARFaceView (UIViewRepresentable)

/// ARSCNView를 SwiftUI에서 사용할 수 있도록 감싼 래퍼입니다.
struct ARFaceView: UIViewRepresentable {

    // delegate 역할을 할 Coordinator 생성
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        sceneView.delegate = context.coordinator
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        return sceneView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    // 뷰가 제거될 때 AR 세션 일시정지 (UIKit의 viewWillDisappear 역할)
    static func dismantleUIView(_ uiView: ARSCNView, coordinator: Coordinator) {
        uiView.session.pause()
    }

    // MARK: - Coordinator

    /// ARSCNViewDelegate를 구현해 얼굴 앵커에 노드를 붙입니다.
    class Coordinator: NSObject, ARSCNViewDelegate {

        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard anchor is ARFaceAnchor else { return nil }

            let faceNode = SCNNode()
            faceNode.addChildNode(makeHelloNode())  // Hello 텍스트 노드를 자식으로 추가
            return faceNode
        }

        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard anchor is ARFaceAnchor else { return }
            // ARKit이 node.transform을 ARFaceAnchor.transform과 자동 동기화합니다
        }

        // MARK: - Hello Node 생성

        /// 얼굴 위에 표시할 "Hello 👋" 3D 텍스트 노드를 생성합니다.
        private func makeHelloNode() -> SCNNode {
            // 1. SCNText 지오메트리 생성
            let textGeometry = SCNText(string: "Hello 👋", extrusionDepth: 1.0)
            textGeometry.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            textGeometry.flatness = 0.1  // 텍스트 곡선 부드럽기

            // 2. 머티리얼 설정 - emission으로 조명과 무관하게 밝게 표시
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white
            material.emission.contents = UIColor.white
            textGeometry.materials = [material]

            // 3. 텍스트 노드 생성 및 크기 조절
            let textNode = SCNNode(geometry: textGeometry)
            let scale: Float = 0.002
            textNode.scale = SCNVector3(scale, scale, scale)

            // 4. 텍스트를 가로 중앙 정렬 (SCNText는 기본적으로 왼쪽 정렬)
            let (min, max) = textNode.boundingBox
            let width = (max.x - min.x) * scale
            textNode.position = SCNVector3(-width / 2, 0.15, 0)  // 얼굴 위 15cm

            // 5. 항상 카메라를 바라보도록 Billboard Constraint 적용
            let billboard = SCNBillboardConstraint()
            billboard.freeAxes = .Y
            textNode.constraints = [billboard]

            return textNode
        }
    }
}
