# CLAUDE.md

## 專案說明

Demo app，示範如何透過 `AVAssetResourceLoaderDelegate` 攔截 AVPlayer 資源請求，讓 AVPlayer 播放 App Bundle 內的本地 `.m3u8` 檔案。

## 技術架構

- **UI 層**：UIKit（AppDelegate / SceneDelegate 管理 window）
- **橋接層**：`UIHostingController`（HostController 負責 UIKit 導航）
- **視圖層**：SwiftUI + `@Observable` ViewModel
- **播放器**：`AVPlayer` 子類 `LocalPlayer`，自訂 scheme 觸發 ResourceLoader

## 架構規範（Skill）

下列任務必須觸發對應的 Skill，**不得繞過**：

| 任務 | Skill |
|------|-------|
| 新增 / 修改 HostController | `swift-hostcontroller` |
| 新增 / 修改 ViewModel | `swift-viewmodel` |
| 新增 / 修改 SwiftUI View | `swiftui-expert` |
| 新增 / 修改 Model / State / DTO | `swift-model` |
| 涉及 async/await / Task / actor | `swift-concurrency` |

## 命名規範

| 層級 | 規則 | 範例 |
|------|------|------|
| HostController | `Feature` + `HostController` | `HomeHostController` |
| ViewModel | `Feature` + `ViewModel` | `HomeViewModel` |
| View | `Feature` + `View` | `HomeView` |
| Models 檔 | `FeatureViewModel+Models.swift` | `HomeViewModel+Models.swift` |

## ViewModel 結構

本專案**不使用 `ViewModel` protocol**，pattern 直接定義在 class 上：

```swift
@Observable
@MainActor
final class FeatureViewModel {
  enum Action: Sendable { ... }

  var state: State = .init()

  @ObservationIgnored
  var onAction: (@MainActor (Action) -> Void)?

  func doAction(_ action: Action) async { ... }
}
```

## 檔案結構

```
Sources/
├── AppDelegate.swift          — @main，僅負責 SceneConfiguration
├── SceneDelegate.swift        — 建立 UIWindow 與 rootViewController
├── Info.plist                 — UIApplicationSceneManifest（手動管理）
├── video.m3u8                 — Bundle 內的本地 HLS playlist
├── Home/
│   ├── HomeHostController.swift    — UIHostingController 橋接 + Router 導航
│   ├── HomeView.swift              — SwiftUI View
│   ├── HomeViewModel.swift         — @Observable ViewModel
│   └── HomeViewModel+Models.swift  — State
└── Player/
    └── LocalPlayer.swift           — AVPlayer + ResourceLoader 攔截
```

## 關鍵技術決策

### LocalPlayer 自訂 Scheme

AVAssetResourceLoaderDelegate 只會對**非標準 scheme** 的 URL 被呼叫。直接使用 `file://` 讓 AVPlayer 自行載入，delegate 不會介入。

解法：Init 時將 `file://` 換成自訂 scheme `local://`，強制所有請求走 delegate；delegate 收到後換回 `file://` 讀取本地資料。

### SceneDelegate vs AppDelegate window 管理

部署目標 iOS 18.0，window 管理責任歸 SceneDelegate，AppDelegate 只留 `configurationForConnecting`。

### Info.plist 手動管理

因需設定 `UIApplicationSceneManifest`（複雜巢狀結構），`GENERATE_INFOPLIST_FILE = NO`，改用手動 `Sources/Info.plist`。
