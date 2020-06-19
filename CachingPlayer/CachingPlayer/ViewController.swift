//
//  ViewController.swift
//  CachingPlayer
//
//  Created by Mikhail Timoscenko on 03.06.2020.
//  Copyright © 2020 SoftServe. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVAssetDownloadDelegate {

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressLabel: UILabel!

    var assetDownloadURLSession: AVAssetDownloadURLSession?

    private var playerItemObserver: NSKeyValueObservation?

    private var playerItem: AVPlayerItem? {
        willSet {
            /// Remove any previous KVO observer.
            guard let playerItemObserver = playerItemObserver else { return }

            playerItemObserver.invalidate()
        }

        didSet {
            /// - Tag: PlayerItemReadyToPlay
            playerItemObserver = playerItem?.observe(\AVPlayerItem.status, options: [.new, .initial]) { [weak self] (item, _) in
                guard let strongSelf = self else { return }

                if item.status == .readyToPlay {
                    strongSelf.player = AVPlayer(playerItem: strongSelf.playerItem)
                    strongSelf.player?.play()
                } else if item.status == .failed {
                    let error = item.error

                    print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }

    var player: AVPlayer?

    var manager: StreamSessionManager = StreamSessionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let asset = AVURLAsset(url: URL(string: "https://playerservices.streamtheworld.com/api/livestream-redirect/WRJAFM_ADP.m3u8")!)
        AssetPersistenceManager.sharedManager.downloadStream(for: asset)

    }

    @IBAction func stop(_ sender: Any) {
        print("")
    }
}

extension ViewController: StreamSessionManagerOutput {

    func changed(progres: Double) {
        progressLabel.text = "\(progres)"
    }

}


