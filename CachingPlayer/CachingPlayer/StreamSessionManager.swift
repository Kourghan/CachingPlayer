//
//  StreamSessionManager.swift
//  CachingPlayer
//
//  Created by Mikhail Timoscenko on 09.06.2020.
//  Copyright © 2020 SoftServe. All rights reserved.
//

import Foundation
import AVKit

protocol StreamSessionManagerOutput {
    func changed(progres: Double)
}

class StreamSessionManager: NSObject {

    static let shared = StreamSessionManager()
    private var sessions = [String : StreamSession]()

    var output: StreamSessionManagerOutput?

    func session(with name: String) -> StreamSession {
        if let session = sessions[name] {
            return session
        } else {
            return createSession(name: name)
        }
    }

    func restorePendingDownloads(sessions: [String]) {
        _ = sessions.map {
            self.resetoreSession(name: $0)
        }
    }

    private func createSession(name: String) -> StreamSession {
        let session = StreamSession(name: name)
        sessions[name] = session
        session.delegate = self

        return session
    }

    private func resetoreSession(name: String) {
        createSession(name: name).restore()
    }

}

extension StreamSessionManager: AVAssetDownloadDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error)
    }

    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        print(location)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        // Here you can calculate % of task downloaded

        var percentComplete = 0.0
        // Iterate through the loaded time ranges
        for value in loadedTimeRanges {
            // Unwrap the CMTimeRange from the NSValue
            let loadedTimeRange = value.timeRangeValue
            // Calculate the percentage of the total expected asset duration
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        percentComplete *= 100

        output?.changed(progres: percentComplete)
    }

}
