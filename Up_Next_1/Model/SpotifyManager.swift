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
    
    func createPlaylist(accessToken: String, cityName: String, playlistName: String, genreId: String, completed: @escaping (Bool, String, Bool) -> Void) {
        let urlString = "\(createPlaylistURL)?accessToken=\(accessToken)&city=\(cityName)&genreId=\(genreId)&playlistName=\(playlistName)"
        performRequest(urlString: urlString) {
            if $0 {
               completed(true, $1, $2)
            }
        }
    }
    
    func performRequest(urlString: String, completed: @escaping (Bool, String, Bool) -> Void) {
        
        if let url = URL(string: urlString) {
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(playlistData: safeData) {
                        if $0 {
                           completed(true, $1, $2)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(playlistData: Data, completed: (Bool, String, Bool) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(SpotifyData.self, from: playlistData)
            if decodedData.successfully_generated != "false" {
                completed(true, decodedData.playlist_url, true)
            } else if decodedData.rate_limited != "true" {
                completed(true, "Could not generate a playlist for your search criteria; try entering a different city or genre.", false)
            } else {
                completed(true, "Spotify rate limiting is in effect. Please wait at least \(decodedData.wait_time) seconds before trying again.", false)
            }
        } catch {
            print(error)
        }
        
    }
    
   
}
