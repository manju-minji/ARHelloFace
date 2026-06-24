import SwiftUI

// ARFaceView를 화면 전체에 채워 표시하는 SwiftUI 루트 뷰
struct ContentView: View {
    var body: some View {
        ARFaceView()
            .ignoresSafeArea()  // 노치/홈 인디케이터 영역까지 카메라 화면을 채움
    }
}
