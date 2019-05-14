//
//  ItunesAPIClient.swift
//  iTunesClient
//
//  Created by Screencast on 4/12/17.
//  Copyright © 2017 Treehouse Island. All rights reserved.
//

import Foundation

class ItunesAPIClient {
    let downloader = JSONDownloader()
    
    func searchForArtists(withTerm term: String, completion: @escaping ([Artist], ItunesError?) -> Void) {
        let endpoint = Itunes.search(term: term, media: .music(entity: .musicArtist, attribute: .artistTerm))
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion([], error)
                return
            }
            
            let artists = results.flatMap { Artist(json: $0) }
            
            completion(artists, nil)
        }
    }
    
    func lookupArtist(withId id: Int, completion: @escaping (Artist?, ItunesError?) -> Void) {
        
        let endpoint = Itunes.lookup(id: id, entity: MusicEntity.album)
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            guard let artistInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain artist info"))
                return
            }
            
            guard let artist = Artist(json: artistInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parse artist information"))
                return
            }
            
            let albumResults = results[1..<results.count]
            let albums = albumResults.flatMap { Album(json: $0) }
            
            artist.albums = albums
            completion(artist, nil)
            
            
        }
    }
    
    func lookupAlbum(withId id: Int, completion: @escaping (Album?, ItunesError?) -> Void) {
        
        let endpoint = Itunes.lookup(id: id, entity: MusicEntity.song)
        
        performRequest(with: endpoint) { results, error in
            guard let results = results else {
                completion(nil, error)
                return
            }
            
            guard let albumInfo = results.first else {
                completion(nil, .jsonParsingFailure(message: "Results does not contain album information"))
                return
            }
            
            guard let album = Album(json: albumInfo) else {
                completion(nil, .jsonParsingFailure(message: "Could not parse album information"))
                return
            }
            
            let songResults = results[1..<results.count]
            let songs = songResults.flatMap { Song(json: $0) }
            
            album.songs = songs
            completion(album, nil)
        }
    }
    
    typealias Results = [[String: Any]] //further used as artists, albums, etc at the time of initializations.
    
    // MARK: Creating a data task #INSTANCE
    //To create a data task that uses a completion handler, call the dataTask(with:) method of URLSession. Your completion handler needs to do three things:
    
    private func performRequest(with endpoint: Endpoint, completion: @escaping (Results?, ItunesError?) -> Void) {
        
        // MARK: SWEET CLARITY :D
        
        /*

         
       1.  DO NOT FORGET TO DO THE FIRST STEP... AGAIN!!! -> Verify that the error parameter is nil. If not, a transport error has occurred; handle the error and exit.
         
       2.  THIS IS A BIGGIE!! -> Check the response parameter to verify that the status code indicates success and that the MIME type is an expected value. If not, handle the server error and exit.
         
         3. YOU GOT IT MATE :D -> Use the data instance as needed.
        
        */
        
        let task = downloader.jsonTask(with: endpoint.request) { json, error in
            DispatchQueue.main.async {
                //First step as described above
                guard let json = json else {
                    completion(nil, error)
                    return
                }
                // second step bro
                guard let results = json["results"] as? [[String: Any]] else {
                    completion(nil, .jsonParsingFailure(message: "JSON data does not contain results"))
                    return
                }
                // yep you got it dude!
                completion(results, nil)
            }
        }
        
        task.resume()
        
    }
}


// MARK: FUTURE REFERENCE, ERROR HANDLING

/*
 Delegate methods for better access of data through the process of receiving the data: https://developer.apple.com/documentation/foundation/url_loading_system/fetching_website_data_into_memory#2926952
 
 func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
 DispatchQueue.main.async {
 self.loadButton.isEnabled = true
 if let error = error {
 handleClientError(error)
 } else if let receivedData = self.receivedData,
 let string = String(data: receivedData, encoding: .utf8) {
 self.webView.loadHTMLString(string, baseURL: task.currentRequest?.url)
 }
 }

*/





















