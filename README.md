Title: 播放本地端 m3u8  
Categories: [iOS][L1]  
Labels: [AVPlayer][L2]  
References: [Link][L3] , [Link][L4]  

## 前言  
原則上 AVPlayer 播放 m3u8 是基於網路播放, 之前的公司懶得實作 HLS 加密,  
於是將 m3u8 壓縮成有密碼的壓縮檔, 再透過 [CocoaHTTPServer] run 本地端 Server 來播放.  
由於專案轉變為 swift, 加上 [CocoaHTTPServer] 已經很久沒維護, 所以查找了一下本地端播放 m3u8 的方法.  
最後查詢到 AVAssetResourceLoaderDelegate 可以解決這個問題.

[L1]: https://github.com/shinrenpan/Note/discussions/categories/ios
[L2]: https://github.com/shinrenpan/Note/discussions?discussions_q=label:AVPlayer
[L3]: https://stackoverflow.com/questions/45670774/playing-offline-hls-with-aes-128-encryption-ios/45957045#45957045
[L4]: https://github.com/Cyklet/VidLoader
[CocoaHTTPServer]: https://github.com/robbiehanson/CocoaHTTPServer