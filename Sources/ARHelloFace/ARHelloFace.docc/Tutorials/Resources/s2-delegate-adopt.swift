// s2-delegate-adopt.swift
class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self  // delegate 연결
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
    }
}
