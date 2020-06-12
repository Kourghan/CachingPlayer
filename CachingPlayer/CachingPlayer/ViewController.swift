//
//  ViewController.swift
//  CachingPlayer
//
//  Created by Mikhail Timoscenko on 03.06.2020.
//  Copyright © 2020 SoftServe. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var progressLabel: UILabel!

    var downloadSession: AVAssetDownloadURLSession?

    var player: AVPlayer?

    var manager: StreamSessionManager = StreamSessionManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        manager.output = self

        _ = manager.session(with: "test").stream(url: "https://playerservices.streamtheworld.com/api/livestream-redirect/WRJAFM_ADP.m3u8")

    }

}

extension ViewController: StreamSessionManagerOutput {

    func changed(progres: Double) {
        progressLabel.text = "\(progres)"
    }

}


