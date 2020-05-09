//
//  RadioAPI.swift
//  RadioStation
//
//  Created by Airam Rguez on 09/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import Foundation

enum RadioAPI {
    static let BaseURL = "http://de1.api.radio-browser.info/"
    static let Format = "json"
    
    static let TagsURL = "\(BaseURL)\(Format)/tags"
    
    static func getTags(onComplete: @escaping(([Tag]) -> Void)) {
        guard let url = URL(string: TagsURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard let tags = try? JSONDecoder().decode([Tag].self, from: data) else { return }
            onComplete(tags)
            
        }.resume()
    }
    
    static func stationsForTagURL(categoryID: String) -> String {
        // http://de1.api.radio-browser.info/​{format}/​stations/bytag/​{searchterm​}
        let safeCategoryID = categoryID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return "\(BaseURL)\(Format)/stations/bytag/\(safeCategoryID)"
            
    }
    
    static func getStations(for tag: String, onComplete: @escaping(([Station]) -> Void)) {
        guard let url = URL(string: stationsForTagURL(categoryID: tag)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            guard let stations = try? JSONDecoder().decode([Station].self, from: data) else { return }
            onComplete(stations)
        }.resume()
    }
}

struct Tag: Decodable {
    let name: String
    let stationcount: Int
}

struct Station: Decodable {
    let name: String
    let url_resolved: String
    let favicon: String
}
