# play-local-m3u8

Demo app：示範如何讓 `AVPlayer` 播放 App Bundle 內的本地 `.m3u8` HLS 檔案。

---

## 核心問題

AVPlayer 可以直接以 `file://` URL 播放本地影片，但對於 `.m3u8` playlist，它會在解析完 manifest 後，**直接嘗試以原始路徑載入每一個 segment**。這個過程完全繞過了 `AVAssetResourceLoaderDelegate`，導致無法攔截並自訂載入行為。

簡單說：`file://` URL 太「正常」了，AVPlayer 自己就處理掉，不給你插手的機會。

---

## 解法：自訂 Scheme

`AVAssetResourceLoaderDelegate` 只對 **AVPlayer 不認識的 scheme** 生效。

做法是在建立 `AVURLAsset` 時，把 `file://` 替換成自訂的 `local://`：

```
file:///var/mobile/.../video.m3u8
         ↓ 替換 scheme
local:///var/mobile/.../video.m3u8
```

AVPlayer 看到 `local://`，不知道怎麼處理，就把請求轉交給 `AVAssetResourceLoaderDelegate`。

---

## 流程

```
AVPlayer 請求 local:///path/to/video.m3u8
    ↓
AVAssetResourceLoaderDelegate.shouldWaitForLoadingOfRequestedResource
    ↓
delegate 把 local:// 換回 file://
    ↓
Data(contentsOf: file:///path/to/video.m3u8)  — 讀取 Bundle 內的本地檔案
    ↓
request.dataRequest?.respond(with: data)
request.finishLoading()
    ↓
AVPlayer 拿到 m3u8 資料，解析 playlist
    ↓
playlist 內的 segment URL（本例為 HTTPS）正常從網路載入
```

---

## 程式碼

### LocalPlayer（核心邏輯）

```swift
final class LocalPlayer: AVPlayer {

  init(m3u8Path: String) {
    super.init()

    // 1. 建立 file:// URL
    let fileURL = URL(fileURLWithPath: m3u8Path)

    // 2. 把 scheme 換成自訂的 "local://"，觸發 ResourceLoader
    guard var components = URLComponents(url: fileURL, resolvingAgainstBaseURL: false) else { return }
    components.scheme = "local"
    guard let url = components.url else { return }

    let asset = AVURLAsset(url: url)
    asset.resourceLoader.setDelegate(self, queue: .main)
    replaceCurrentItem(with: AVPlayerItem(asset: asset))
  }
}

extension LocalPlayer: AVAssetResourceLoaderDelegate {
  func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                      shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
    guard let url = loadingRequest.request.url,
          var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return false
    }
    // 3. 換回 file://，讀取本地資料
    components.scheme = "file"
    guard let fileURL = components.url,
          let data = try? Data(contentsOf: fileURL),
          !data.isEmpty else {
      return false
    }
    loadingRequest.dataRequest?.respond(with: data)
    loadingRequest.finishLoading()
    return true
  }
}
```

---

## 注意事項

- **本 demo 的 m3u8 指向遠端 segment**（Big Buck Bunny HTTPS URLs），因此需要網路連線才能實際播放。Delegate 只攔截 m3u8 manifest 本身的請求，segment 仍由 AVPlayer 直接從網路載入。
- 若 segment 也是本地檔案，以同樣的 scheme 替換方式即可讓 delegate 一併處理。
- `resourceLoader.setDelegate(_:queue:)` 的 queue 使用 `.main`，同步讀取本地資料在此 demo 規模下可接受；大型檔案或高頻請求建議改用背景 queue 搭配非同步讀取。

---

## 架構

```
AppDelegate (@main)
    └── SceneDelegate
            └── HomeHostController (UIHostingController)
                    ├── HomeViewModel (@Observable, @MainActor)
                    └── HomeView (SwiftUI)
                            └── 點擊 Play
                                    └── LocalPlayer (AVPlayer)
                                            └── AVPlayerViewController
```
