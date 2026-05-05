import AVFoundation

final class LocalPlayer: AVPlayer {

  init(m3u8Path: String) {
    super.init()

    let fileURL = URL(fileURLWithPath: m3u8Path)
    guard var components = URLComponents(url: fileURL, resolvingAgainstBaseURL: false) else {
      replaceCurrentItem(with: nil)
      return
    }
    components.scheme = "local"
    guard let url = components.url else {
      replaceCurrentItem(with: nil)
      return
    }

    let asset = AVURLAsset(url: url)
    asset.resourceLoader.setDelegate(self, queue: .main)
    let item = AVPlayerItem(asset: asset)
    replaceCurrentItem(with: item)
  }
}

// MARK: - AVAssetResourceLoaderDelegate

extension LocalPlayer: AVAssetResourceLoaderDelegate {
  func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
    handleLoadingRequest(renewalRequest)
  }

  func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
    handleLoadingRequest(loadingRequest)
  }
}

// MARK: - Private

private extension LocalPlayer {
  func handleLoadingRequest(_ request: AVAssetResourceLoadingRequest) -> Bool {
    guard let url = request.request.url,
          var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return false
    }
    components.scheme = "file"
    guard let fileURL = components.url,
          let data = try? Data(contentsOf: fileURL),
          !data.isEmpty else {
      return false
    }
    request.dataRequest?.respond(with: data)
    request.finishLoading()
    return true
  }
}
