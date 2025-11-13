//
//  ViewController.swift
//  Group4Proposal
//
//  Created by Kent, Christian M. on 10/28/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //songAddedLabel.alpha = 0
        
        if tableView == nil {
            print("TableVIew is nil")
        }else {
            tableView.delegate = self
            tableView.dataSource = self
        }
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var song_name: UITextField!
    
    @IBOutlet weak var song_author: UITextField!

    @IBOutlet weak var song_description: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var starStackView: UIStackView!
    
    @IBOutlet weak var songAddedLabel: UILabel!
    
    var name = " "
    var author = " "
    var description_ = " "
    var star_rating = 0
    var current_rating = 0
    
    class RatedSong {
        var song_name: String
        var song_author: String
        var song_description: String
        var song_rating: Int
        
        init(song_name: String, song_author: String, song_description: String, song_rating: Int) {
            self.song_name = song_name
            self.song_author = song_author
            self.song_description = song_description
            self.song_rating = song_rating
        }
    }
    
    class DataStore {
        static let shared = DataStore()
        var items: [String] = []
        var rated_songs: [RatedSong] = []
    }
    
    @IBAction func star_tapped(_ sender: UIButton) {
        print("tapped tag", sender.tag)
        current_rating = sender.tag
        updateStars()
    }
    
    //animations, optinal binding
    func updateStars() {
        for case let button as UIButton in starStackView.arrangedSubviews {
            let filled = button.tag <= current_rating
            button.setTitle(filled ? "★" : "☆", for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                button.transform = filled ? CGAffineTransform(scaleX: 1.3, y: 1.3) : .identity
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    button.transform = .identity
                }
            }
        }
    }
    
    
    
    //optional binding, error handling, animations
    @IBAction func song_added(_ sender: Any) {
        guard let name = song_name?.text, !name.isEmpty,
              let author = song_author?.text, !author.isEmpty,
              let description = song_description?.text, !description.isEmpty else {
            showAlert(title: "Missing needed information", message: "Please fill in all album details before adding.")
            return
        }
        
        let ratedSong = RatedSong(song_name: name, song_author: author, song_description: description, song_rating: current_rating)
        DataStore.shared.items.append("\(name), by \(author): \(current_rating)/5")
        DataStore.shared.rated_songs.append(ratedSong)

        //animation
        songAddedLabel.alpha = 0
        songAddedLabel.text = "Song Added!"
        songAddedLabel.transform = CGAffineTransform(translationX: 0, y: 20)

        UIView.animate(withDuration: 0.4, animations: {
            self.songAddedLabel.alpha = 1.0
            self.songAddedLabel.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.4, delay: 1.0, options: [], animations: {
                self.songAddedLabel.alpha = 0.0
                self.songAddedLabel.transform = CGAffineTransform(translationX: 0, y: -20)
            }) { _ in
                self.dismiss(animated: true)
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = "\(DataStore.shared.items[indexPath.row])"
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSong = ViewController.DataStore.shared.rated_songs[indexPath.row]
        
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "SongDetailsViewController") as? SongDetailsViewController {
            detailVC.song = selectedSong
            detailVC.modalPresentationStyle = .fullScreen
            present(detailVC, animated: true)
        }
    }
}

