//
//  RadioPlayerViewController.swift
//  RadioStation
//
//  Created by Airam Rguez on 10/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import UIKit

class RadioPlayerViewController: UIViewController {
    @IBOutlet weak var stationPicture: UIImageView!
    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = station?.name ?? "Default station"
    }
    
    @IBAction func playStopButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func volumeSliderChanged(_ sender: Any) {
        
    }
}
