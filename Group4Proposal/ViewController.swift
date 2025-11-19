//
//  ViewController.swift
//  Group4Proposal
//
//  Created by Kent, Christian M. on 10/28/25.
//

import UIKit

//protocols and delegates
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //mvc architecture
    @IBOutlet weak var song_name: UITextField!
    @IBOutlet weak var song_author: UITextField!
    @IBOutlet weak var song_description: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var starStackView: UIStackView! //stack view
    @IBOutlet weak var songAddedLabel: UILabel!
    
    var current_rating = 0
    
    //mvc architecture
    class RatedSong: Codable {
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
    
    //classes
    class DataStore {
        static let shared = DataStore()
        
        var rated_songs: [RatedSong] = []
        var items: [String] = []
        
        private init() {
            loadSongs()
        }
        
        //file handling
        private var saveURL: URL {
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            return directory.appendingPathComponent("songs.json")
        }
        
        //error handling
        func saveSongs() {
            do {
                let data = try JSONEncoder().encode(rated_songs)
                try data.write(to: saveURL)
                print("Saved songs to file.")
            } catch {
                print("Error saving:", error)
            }
        }
        
        //error handling
        func loadSongs() {
            do {
                let data = try Data(contentsOf: saveURL)
                rated_songs = try JSONDecoder().decode([RatedSong].self, from: data)
                
                //map
                items = rated_songs.map { "\($0.song_name), by \($0.song_author): \($0.song_rating)/5" }
                
                print("Loaded existing songs.")
            } catch {
                print("No previous file found or failed to load.")
                rated_songs = []
                items = []
            }
        }
    }
    
    //view controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate and datasource
        if tableView == nil {
            print("tableView is nil")
        } else {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //button and userinteraction, function
    @IBAction func star_tapped(_ sender: UIButton) {
        current_rating = sender.tag
        updateStars()
    }
    
    //animation, stackviews
    func updateStars() {
        for case let button as UIButton in starStackView.arrangedSubviews {
            let filled = button.tag <= current_rating
            button.setTitle(filled ? "★" : "☆", for: .normal)
            
            //animations
            UIView.animate(withDuration: 0.2, animations: {
                button.transform = filled ? CGAffineTransform(scaleX: 1.3, y: 1.3) : .identity
            }) { _ in
                UIView.animate(withDuration: 0.2) {
                    button.transform = .identity
                }
            }
        }
    }
    
    //function
    @IBAction func song_added(_ sender: Any) {
        
        //optional binding, input validation
        guard let name = song_name?.text, !name.isEmpty,
              let author = song_author?.text, !author.isEmpty,
              let description = song_description?.text, !description.isEmpty else {
            
            //error handling, alerts
            showAlert(title: "Missing needed information",
                      message: "Please fill in all album details before adding.")
            return
        }
        
        //mvc architecture
        let ratedSong = RatedSong(
            song_name: name,
            song_author: author,
            song_description: description,
            song_rating: current_rating
        )
        
        DataStore.shared.rated_songs.append(ratedSong)
        DataStore.shared.items.append("\(name), by \(author): \(current_rating)/5")
        
        //data store save
        DataStore.shared.saveSongs()
        
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
                //navigation
                self.dismiss(animated: true)
            }
        }
    }
    
    //alerts
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        //views
        present(alert, animated: true)
    }
    
    //functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = DataStore.shared.items[indexPath.row]
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedSong = DataStore.shared.rated_songs[indexPath.row]
        
        //optional binding
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "SongDetailsViewController") as? SongDetailsViewController {
            
            detailVC.song = selectedSong
            detailVC.modalPresentationStyle = .fullScreen
            
            //navigation
            present(detailVC, animated: true)
        }
    }
}
