//
//  ViewController.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/5/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    let keychain = KeychainSwift()
    
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var playlistNameField: UITextField!
    @IBOutlet weak var selectGenreButton: UIButton!
    @IBOutlet weak var genreTableView: UITableView!
    
    var spotifyManager = SpotifyManager()
    var refreshTokenManager = RefreshTokenManager()
    
    var selectedGenre: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        
        cityNameField.delegate = self
        playlistNameField.delegate = self
        genreTableView.dataSource = self
        genreTableView.delegate = self
        
        genreTableView.isHidden = true
    }

    @IBAction func generatePressed(_ sender: UIButton) {
        print("The first access token is \(keychain.get("accessToken") ?? String()) yeah")

//        let currentDate = Date()
//        if let expirationDate = defaults.object (forKey: "expirationDate") as? Date {
//            if expirationDate < currentDate.addingTimeInterval(5.0 * 60.0) {
//                refreshTokenManager.refreshToken()
//            }
//        }
        // once it finishes the check expiration process, submit the form
        // will probably need another round of closures within in order to switch to a new page when the process is complete
        checkExpiration {
            if $0, $1 == "" {
                DispatchQueue.main.async {
                    self.submitForm()
                }
            } else {
                let alertMessage = $1
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Failed to Refresh Token", message:
                        alertMessage, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
//        cityNameField.endEditing(true)
//        submitForm()
        print("Generate button pressed")
    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != "" {
//            return true
//        } else {
//            cityNameField.placeholder = "You must enter a city name!"
//            playlistNameField.placeholder = "You must enter a playlist name!"
//            return false
//        }
//    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
////        if var city = cityNameField.text, let accessToken = keychain.get("accessToken") {
////            city = city.replacingOccurrences(of: " ", with: "%20")
////            spotifyManager.createPlaylist(cityName: city, accessToken: accessToken)
////        }
////        cityNameField.text = ""
////        cityNameField.placeholder = "Enter a city name"
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func submitForm() {
        print("The second access token is \(keychain.get("accessToken") ?? String()) yeah")
        print(playlistNameField.text!)
        if var city = cityNameField.text, city != "", var playlistName = playlistNameField.text, playlistName != "", let genreId = selectedGenre, let accessToken = keychain.get("accessToken"), accessToken != "" {
            city = city.replacingOccurrences(of: " ", with: "%20")
            playlistName = playlistName.replacingOccurrences(of: " ", with: "%20")
            playlistName = playlistName.replacingOccurrences(of: "&", with: "and")
            print(playlistName)
            spotifyManager.createPlaylist(accessToken: accessToken, cityName: city, playlistName: playlistName, genreId: genreId) {
                if $0, $2 {
                    let newPlaylistURL = $1
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "CompletedViewController") as! CompletedViewController
                        vc.playlistURL = newPlaylistURL
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                } else {
                    let alertMessage = $1
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Playlist Generation Failed", message:
                            alertMessage, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alertController = UIAlertController(title: "Playlist Generation Failed", message:
                "You must complete all form fields to create a playlist.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
        cityNameField.text = ""
        cityNameField.placeholder = "Enter a City Name"
        playlistNameField.text = ""
        playlistNameField.placeholder = "Enter a Playlist Name"
        selectGenreButton.setTitle("Select a Genre", for: .normal)
        selectedGenre = nil
    }
    
    func checkExpiration(completed: @escaping (Bool, String) -> Void) {
        let currentDate = Date()
        if let expirationDate = defaults.object (forKey: "expirationDate") as? Date {
            // refresh the token if it will expire in less than 5 mintues
            if expirationDate < currentDate.addingTimeInterval(5.0 * 60.0) {
                refreshTokenManager.refreshToken {
                    if $0 {
                        completed(true, $1)
                    }
                }
            } else {
                completed(true, "")
            }
        } else {
            completed(true, "")
        }
    }
    
    var genres: [Genre] = [
        Genre(genreName: "All Genres", genreId: ""),
        Genre(genreName: "Alternative", genreId: "KnvZfZ7vAvv"),
        Genre(genreName: "Blues", genreId: "KnvZfZ7vAvd"),
        Genre(genreName: "Classical", genreId: "KnvZfZ7vAeJ"),
        Genre(genreName: "Country", genreId: "KnvZfZ7vAv6"),
        Genre(genreName: "Electronic", genreId: "KnvZfZ7vAvF"),
        Genre(genreName: "Folk", genreId: "KnvZfZ7vAva"),
        Genre(genreName: "Hip-Hop", genreId: "KnvZfZ7vAv1"),
        Genre(genreName: "Jazz", genreId: "KnvZfZ7vAvE"),
        Genre(genreName: "Pop", genreId: "KnvZfZ7vAev"),
        Genre(genreName: "R&B", genreId: "KnvZfZ7vAee"),
        Genre(genreName: "Rock", genreId: "KnvZfZ7vAeA")
    ]
    
    @IBAction func selectGenreClicked(_ sender: UIButton) {
        if genreTableView.isHidden {
            animate(toggle: true)
        } else {
            animate(toggle: false)
        }
    }
    
    func animate(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.genreTableView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.genreTableView.isHidden = true
            }
        }
    }
    
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = genres[indexPath.row].genreName
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectGenreButton.setTitle(genres[indexPath.row].genreName, for: .normal)
        animate(toggle: false)
        selectedGenre = genres[indexPath.row].genreId
    }
}

