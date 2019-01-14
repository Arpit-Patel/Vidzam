//
//  MusicManager.swift
//  Vidzam
//
//  Created by Arpit Patel on 2019-01-13.
//  Copyright © 2019 Zapps Inc. All rights reserved.
//

import Foundation

class MusicManager {
    
    struct Body : Codable {
        var videoUrl: String
        var startTime: Int
    }
    
    let networkLayer = Networking()
    
    let defaultUrl = "http://www.music-identify.com/identify"
    
    let defaultHeaders = [:] as [String : String]
    
    func getMusicInfo(url : String, startTime : Int,
                      completionHandler: @escaping ([String : Any]) -> (Void),
                      errorHandler: @escaping (String) -> (Void)) {
        
        let body = Body(videoUrl: url, startTime: startTime)
        
        networkLayer.submitPost(urlString: self.defaultUrl,
                                body: body,
                                headers: self.defaultHeaders,
                                errorHandler: { (error) in
                                    errorHandler("Could not identify music.")
                                },
                                successHandler: { (result) in
                                    let metadata = result["metadata"] as! [String:Any]
                                    let music = metadata["music"] as! [[String : Any]]
                                    let resultDict = self.fillMusicInfo(musicInfo: music[0])
                                    completionHandler(resultDict)
                                })
    }
    
    private func fillMusicInfo(musicInfo : [String : Any]) -> [String : Any] {
        var artists = Array<String>()
        for artist in musicInfo["artists"] as! [[String : String]] {
            artists.append(artist["name"]!)
        }
        return ["artists" : artists, "songName" : musicInfo["title"] as! String]
    }
    
}
