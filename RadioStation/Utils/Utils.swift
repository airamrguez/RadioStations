//
//  Utils.swift
//  RadioStation
//
//  Created by Airam Rguez on 09/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import UIKit

class Utils {
    static func addBackgroundImage(_ to: UITableView) {
        let bgImage = UIImageView(image: UIImage(named: "AppBackground"))
        bgImage.frame = to.frame
        to.backgroundView = bgImage
    }
}
