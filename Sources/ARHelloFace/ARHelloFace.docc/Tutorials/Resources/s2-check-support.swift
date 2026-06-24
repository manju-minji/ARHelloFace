import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Face Tracking 지원 여부 확인 (TrueDepth 카메라 필요)
        guard ARFaceTrackingConfiguration.isSupported else {
            let alert = UIAlertController(
                title: "미지원 기기",
                message: "Face Tracking은 TrueDepth 카메라가 있는 기기에서만 동작합니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
    }
}
