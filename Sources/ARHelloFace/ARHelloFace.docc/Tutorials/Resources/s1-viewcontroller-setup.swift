import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 개발 중 디버깅용 통계 표시
        sceneView.showsStatistics = true

        // 씬의 조명을 카메라 위치 기반으로 자동 설정
        sceneView.autoenablesDefaultLighting = true
    }
}
