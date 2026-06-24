import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard ARFaceTrackingConfiguration.isSupported else {
            showUnsupportedAlert()
            return
        }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }

        let faceNode = SCNNode()
        faceNode.addChildNode(makeHelloNode())  // Hello 텍스트 노드를 자식으로 추가
        return faceNode
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

    // MARK: - Helpers

    private func showUnsupportedAlert() {
        let alert = UIAlertController(
            title: "미지원 기기",
            message: "Face Tracking은 TrueDepth 카메라가 있는\niPhone X 이상에서만 동작합니다.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
