import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        // delegate 연결
        sceneView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    /// 새 앵커가 감지될 때 호출 - ARFaceAnchor이면 노드를 생성해 반환
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }

        let faceNode = SCNNode()
        // 다음 챕터에서 이 노드에 "Hello" 텍스트를 추가합니다
        return faceNode
    }

    /// 매 프레임마다 앵커 업데이트 - ARKit이 transform을 자동으로 동기화함
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARFaceAnchor else { return }
        // ARKit이 node.transform을 ARFaceAnchor.transform과 자동 동기화합니다
    }
}
