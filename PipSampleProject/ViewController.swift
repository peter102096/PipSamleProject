//
//  ViewController.swift
//  PipSampleProject
//
//  Created by PeterLin on 2021/10/8.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    @IBOutlet weak var pipBtn: UIButton!
    
    var pictureInPictureController: AVPictureInPictureController!
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pipBtn.setTitle("Pip start", for: .normal)
        let startImage = AVPictureInPictureController.pictureInPictureButtonStartImage
        let stopImage = AVPictureInPictureController.pictureInPictureButtonStopImage
        pipBtn.setImage(startImage, for: .normal)
        pipBtn.setImage(stopImage, for: .selected)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pipBtn.isEnabled = false
    }

    @IBAction func pipBtnAction(_ sender: Any) {
        if playerLayer != nil {
            if pictureInPictureController.isPictureInPictureActive {
                print("isPictureInPictureActive")
                pictureInPictureController.stopPictureInPicture()
            } else {
                print("is not PictureInPictureActive")
                pictureInPictureController.startPictureInPicture()
            }
        }
    }
    @IBAction func localBtnAction(_ sender: Any) {
        let path = Bundle.main.path(forResource: "Apple", ofType: "mp4")!
        let url = NSURL(fileURLWithPath: path)
        player = AVPlayer(url: url as URL)
        setupPictureInPicture()
    }
    @IBAction func urlBtnAction(_ sender: Any) {
        let videoUrl = URL(string: "https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/Sample-MP4-Video-File-Download.mp4")
        player = AVPlayer(url: videoUrl!)
        setupPictureInPicture()
    }
    
    func setupPictureInPicture() {
        // Ensure PiP is supported by current device.
        playerLayer = AVPlayerLayer(player: player)
        let width = self.view.frame.size.width - 50
        playerLayer!.frame = CGRect(x: 0, y: 64, width: width, height: width*(9/16))
        playerLayer!.videoGravity = .resize
        view.layer.addSublayer(playerLayer!)
        player!.play()
        
        if AVPictureInPictureController.isPictureInPictureSupported() {
            print("isPictureInPictureSupported")
            pipBtn.isEnabled = true
            // Create a new controller, passing the reference to the AVPlayerLayer.
            pictureInPictureController = AVPictureInPictureController(playerLayer: playerLayer!)
            pictureInPictureController.delegate = self
        } else {
            print("is not PictureInPictureSupported")
            // PiP isn't supported by the current device. Disable the PiP button.
            pipBtn.isEnabled = false
        }
    }
    
}

extension ViewController: AVPictureInPictureControllerDelegate {
    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
        print("restoreUserInterfaceForPictureInPictureStopWithCompletionHandler")
        completionHandler(true)
    }
}
