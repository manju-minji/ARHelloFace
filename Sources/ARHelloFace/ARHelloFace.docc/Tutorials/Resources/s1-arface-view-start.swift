import SwiftUI
import ARKit
import SceneKit

// ARSCNView는 UIKit 뷰이므로 SwiftUI에서 바로 쓸 수 없습니다.
// UIViewRepresentable로 감싸면 SwiftUI 뷰처럼 사용할 수 있습니다.
struct ARFaceView: UIViewRepresentable {

    // UIKit 뷰(ARSCNView)를 생성해 반환합니다.
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView()
        return sceneView
    }

    // SwiftUI 상태가 바뀔 때 호출됩니다. 지금은 할 일이 없습니다.
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
}
