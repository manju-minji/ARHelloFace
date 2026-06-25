import SwiftUI
import ARKit

struct ContentView: View {
    var body: some View {
        // Face Tracking 지원 여부 확인 (TrueDepth 카메라 필요)
        if ARFaceTrackingConfiguration.isSupported {
            ARFaceView()
                .ignoresSafeArea()
        } else {
            // 미지원 기기 안내 화면 (UIAlertController 대신 SwiftUI 뷰로 표시)
            VStack(spacing: 12) {
                Image(systemName: "faceid")
                    .font(.system(size: 48))
                Text("미지원 기기")
                    .font(.title2).bold()
                Text("Face Tracking은 TrueDepth 카메라가 있는\n기기에서만 동작합니다.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}
