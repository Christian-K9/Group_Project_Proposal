//
//  SongDetailsViewController.swift
//  Group4Proposal
//
//  Created by Trey Justice on 11/13/25.
//

import UIKit

class SongDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var songName: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    
    @IBOutlet weak var rating: UILabel!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated:true)
    }
    
    
    //optional
    var song: ViewController.RatedSong?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let song = song {
                    songName.text = "🎵 \(song.song_name) -"
                    author.text = "Author -  \(song.song_author)"
                    descriptionLabel.text = "\(song.song_description)"
                    rating.text = "⭐️ Rating: \(song.song_rating)/5"
                }
    }

}
