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
    
    func updateStars() {
        for case let button as UIButton in starStackView.arrangedSubviews {
            if button.tag <= current_rating {
                button.setTitle( "★", for: .normal)
            } else {
                button.setTitle( "☆", for: .normal)
            }
        }
        }
    
    @IBAction func song_added(_ sender: Any) {
        print("Song Added")
        name = song_name.text!
        author = song_author.text!
        description_ = song_description.text!
        
        DataStore.shared.items.append("\(name), by \(author): \(current_rating)/5")
        var RatedSongs = RatedSong(song_name: name, song_author: author, song_description: description, song_rating: current_rating)
        DataStore.shared.rated_songs.append(RatedSongs)
        print(DataStore.shared.items)
        //tableView.reloadData()
        //items.append("\(name) by \(author)")
        //tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print(indexPath.row)
        print("name: \(DataStore.shared.rated_songs[indexPath.row])")
        print("author: \(DataStore.shared.rated_songs[indexPath.row].song_author)")
        print("description: \(DataStore.shared.rated_songs[indexPath.row].song_description)")
        print("rating: \(DataStore.shared.rated_songs[indexPath.row].song_rating)/5")
    }
    



}

