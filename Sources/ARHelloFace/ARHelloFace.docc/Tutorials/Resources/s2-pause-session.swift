// s2-pause-session.swift
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // 백그라운드 진입 시 AR 세션 일시정지
    sceneView.session.pause()
}
