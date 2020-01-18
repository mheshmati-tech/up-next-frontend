//
//  SpotifyManager.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/16/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import Foundation

struct SpotifyManager {
    let createPlaylistURL = "https://up-next-playlist.herokuapp.com/playlists/new"
    
    func createPlaylist(accessToken: String, cityName: String, playlistName: String, completed: @escaping (Bool, String) -> Void) {
        let urlString = "\(createPlaylistURL)?accessToken=\(accessToken)&city=\(cityName)&playlistName=\(playlistName)"
        performRequest(urlString: urlString) {
            if $0 {
               completed(true, $1)
            }
        }
    }
    
    func performRequest(urlString: String, completed: @escaping (Bool, String) -> Void) {
        // 1. Create a URL
        
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(playlistData: safeData) {
                        if $0 {
                           completed(true, $1)
                        }
                    }
                }
            }
            // 4. Start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(playlistData: Data, completed: (Bool, String) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SpotifyData.self, from: playlistData)
            print(decodedData.playlist_uri)
            print(decodedData.events_found)
            print(decodedData.playlist_url)
//            print(decodedData.weather[0].description)
//            print(decodedData.sys.sunrise)
            if decodedData.events_found != "false" {
                completed(true, decodedData.playlist_url)
            }
        } catch {
            print(error)
        }
        
    }
    
   
}
