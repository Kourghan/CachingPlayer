//
//  StreamSession.swift
//  CachingPlayer
//
//  Created by Mikhail Timoscenko on 10.06.2020.
//  Copyright © 2020 SoftServe. All rights reserved.
//

import Foundation
import AVKit

class StreamSession: NSObject {

    var sessionName: String = "DefaultName"
    var continious: Bool?

    private var downloadSession: AVAssetDownloadURLSession?
    private var tasks = [String : AVAssetDownloadTask]()

    weak var delegate: AVAssetDownloadDelegate?

    var identifier: String {
        return sessionName
    }

    init(name: String, continious: Bool? = true) {
        self.sessionName = name
        self.continious = continious
    }

    func stream(url: String) -> AVPlayerItem? {
        if downloadSession == nil {
            setupSession()
        }

        guard let streamURL = URL(string: url) else {
            return nil
        }

        let asset = AVURLAsset(url: streamURL)
        guard let downloadTask = downloadSession?.makeAssetDownloadTask(asset: asset,
                                                                        assetTitle: identifier,
                                                                        assetArtworkData: nil,
                                                                        options: nil) else  { return nil }
        tasks[url] =  downloadTask
        downloadTask.resume()

        return AVPlayerItem(asset: downloadTask.urlAsset)
    }

    func restore() {
        setupSession()

        downloadSession?.getAllTasks { tasksArray in
            for task in tasksArray {
                guard let downloadTask = task as? AVAssetDownloadTask else { break }

                // Here you can get all data from asset in task

                downloadTask.resume()
            }
        }
    }

    private func setupSession() {
        let configuration = URLSessionConfiguration.background(withIdentifier: self.identifier)
        downloadSession = AVAssetDownloadURLSession(configuration: configuration,
                                                    assetDownloadDelegate: delegate,
                                                    delegateQueue: OperationQueue.main)
    }
}
