//
//  UIImageView+UrlImage.swift
//  RadioStation
//
//  Created by Airam Rguez on 10/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import UIKit

extension UIImageView {
    func imageFromURL(url: String, defaultImage: String) {
        guard let url = URL(string: url) else {
            self.image = UIImage(named: defaultImage)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let mimeType = response?.mimeType, mimeType.hasPrefix("image") {
                    self.image = UIImage(data: data)
                } else {
                    self.image = UIImage(named: defaultImage)
                }
            }
        }.resume()
    }
}
