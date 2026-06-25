# ARHelloFace — DocC 튜토리얼

ARKit Face Tracking으로 사람 머리 위에 "Hello 👋" 텍스트를 띄우는 예제 앱의 **DocC 튜토리얼** 소스입니다.
**SwiftUI** 앱에서 `UIViewRepresentable`로 `ARSCNView`를 감싸 사용합니다.

## 튜토리얼 구성

| 챕터 | 파일 | 내용 |
|------|------|------|
| 1 | `01-ProjectSetup.tutorial` | Xcode 프로젝트 생성, ARSCNView를 UIViewRepresentable로 감싸기 |
| 2 | `02-FaceTracking.tutorial` | ARFaceTrackingConfiguration, Coordinator(ARSCNViewDelegate) |
| 3 | `03-HelloText.tutorial` | SCNText 생성, Billboard, 완성 코드 |

## 필요 환경

- Xcode 15 이상
- iOS 16 이상 배포 대상
- **실기기 필수**: TrueDepth 카메라가 있는 iPhone X 이상 (시뮬레이터 불가)

## DocC 빌드 방법

### Xcode에서 빌드
```
Product > Build Documentation (⌃⇧⌘D)
```

### 커맨드라인으로 빌드
```bash
xcodebuild docbuild \
  -scheme ARHelloFace \
  -destination 'generic/platform=iOS' \
  -derivedDataPath ./DerivedData

# 정적 사이트로 변환
xcrun docc convert \
  DerivedData/Build/Products/Debug-iphoneos/ARHelloFace.doccarchive \
  --output-path ./docs \
  --transform-for-static-hosting \
  --hosting-base-path ARHelloFace
```

## 디렉토리 구조

```
ARHelloFace/
├── Package.swift
└── Sources/ARHelloFace/
    └── ARHelloFace.docc/
        ├── ARHelloFace.tutorial          ← 튜토리얼 목차 (루트)
        ├── Resources/                    ← 이미지 리소스 (별도 추가 필요)
        └── Tutorials/
            ├── 01-ProjectSetup.tutorial
            ├── 02-FaceTracking.tutorial
            ├── 03-HelloText.tutorial
            └── Resources/               ← 각 Step의 코드 파일
                ├── s1-arface-view-start.swift   ← UIViewRepresentable 스켈레톤
                ├── s1-arface-view-setup.swift   ← makeUIView 기본 설정
                ├── s1-content-view.swift        ← ContentView 호스팅
                ├── s1-info-plist.xml
                ├── s2-check-support.swift       ← 지원 여부 분기 (ContentView)
                ├── s2-run-session.swift         ← makeUIView에서 세션 시작
                ├── s2-coordinator-adopt.swift   ← Coordinator + delegate 연결
                ├── s2-node-for-anchor.swift
                ├── s2-did-update.swift
                ├── s2-pause-session.swift       ← dismantleUIView로 세션 정리
                ├── s3-make-hello-node.swift
                ├── s3-text-material.swift
                ├── s3-text-scale.swift
                ├── s3-text-position.swift
                ├── s3-billboard.swift
                ├── s3-final.swift
                └── s3-complete.swift     ← 최종 완성 코드 (App + ContentView + ARFaceView)
```

## 이미지 리소스 추가

`.tutorial` 파일에서 `@Image(source:)` 로 참조하는 PNG 파일들을
`ARHelloFace.docc/Resources/` 폴더에 추가해야 합니다.

| 파일명 | 권장 크기 | 용도 |
|--------|----------|------|
| `ar-hero.png` | 800×600 | 튜토리얼 인트로 대표 이미지 |
| `chapter1.png` | 800×600 | 챕터 1 썸네일 |
| `chapter2.png` | 800×600 | 챕터 2 썸네일 |
| `chapter3.png` | 800×600 | 챕터 3 썸네일 |
| `s1~s3-*.png` | 800×450 | 각 Step 설명 이미지 |

## 완성 코드

`Tutorials/Resources/s3-complete.swift` 파일이 최종 완성된 `ARFaceView.swift`입니다.
`@main App` 진입점, `ContentView`, `ARFaceView`(UIViewRepresentable)와
`Coordinator`(ARSCNViewDelegate)가 한 파일에 들어 있습니다.
Xcode SwiftUI 프로젝트에 이 코드를 복사해 실기기에서 바로 테스트할 수 있습니다.
