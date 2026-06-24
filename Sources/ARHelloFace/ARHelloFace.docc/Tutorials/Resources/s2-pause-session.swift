// s2-pause-session.swift
// 뷰가 화면에서 사라지면 SwiftUI가 ARSCNView를 해제합니다.
// UIViewRepresentable의 dismantleUIView(_:coordinator:)에서 세션을 정리합니다.
// (UIKit의 viewWillDisappear에 해당하는 역할)
static func dismantleUIView(_ uiView: ARSCNView, coordinator: Coordinator) {
    // 화면 이탈 시 AR 세션 일시정지
    uiView.session.pause()
}
