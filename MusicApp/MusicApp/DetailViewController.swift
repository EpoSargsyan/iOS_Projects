//
//  DetailViewController.swift
//  MusicApp
//
//  Created by Eprem Sargsyan on 20.05.23.
//

import AVFoundation
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var holder: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var backwardButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!

    var songs = SearchResult()
    var player: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if holder.subviews.count == 0 {
            configure()
        }
    }

    func configure() {
        guard Bundle.main.path(forResource: songs.trackName, ofType: "M4A") != nil else { return }
        guard let urlString = Bundle.main.path(forResource: songs.trackName, ofType: "mp3") else { return }

        do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)

               // guard let urlString = urlString else { return }

                player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)

                guard let player = player else { return }

                player.play()
        } catch {
            print("Erroorr --->>>> ")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }




    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


