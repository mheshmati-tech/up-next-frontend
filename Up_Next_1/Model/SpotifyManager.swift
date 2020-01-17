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
    
    func createPlaylist(cityName: String, accessToken: String) {
        let urlString = "\(createPlaylistURL)?accessToken=\(accessToken)&city=\(cityName)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
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
                    self.parseJSON(playlistData: safeData)
                }
            }
            // 4. Start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(playlistData: Data) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SpotifyData.self, from: playlistData)
            print(decodedData.playlist_uri)
            print(decodedData.events_found)
//            print(decodedData.weather[0].description)
//            print(decodedData.sys.sunrise)
        } catch {
            print(error)
        }
        
    }
    
   
}
