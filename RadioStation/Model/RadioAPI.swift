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
}

struct Tag: Decodable {
    let name: String
    let stationcount: Int
}
