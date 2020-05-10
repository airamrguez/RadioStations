//
//  RadioPlayerViewController.swift
//  RadioStation
//
//  Created by Airam Rguez on 10/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import UIKit
import AVKit
import CoreData

class RadioPlayerViewController: UIViewController {
    @IBOutlet weak var stationPicture: UIImageView!
    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var station: Station!
    
    lazy var player: AVPlayer = {
        initAudioSession()
        return AVPlayer()
    }()
    
    var isFavourite: FavState!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        self.navigationItem.title = station.name
        stationPicture.imageFromURL(url: station.favicon, defaultImage: "RadioStation")
        
        // Setup favorutie button image
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationEntity")
        let namePredicate = NSPredicate(format: "name == %@", station.name)
        let isFavPredicate = NSPredicate(format: "isFavourite == %@", NSNumber(booleanLiteral: true))
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [namePredicate, isFavPredicate])
        fetchRequest.predicate = compoundPredicate
        
        do {
            let count = try context.count(for: fetchRequest)
            if count == 1 {
                updateFavouriteUI(for: .isFavourite)
                self.isFavourite = .isFavourite
            } else {
                self.isFavourite = .notFavourite
            }
        } catch let error {
            print(error)
        }
    }
    
    @IBAction func playStopButtonPressed(_ sender: Any) {
        if player.timeControlStatus == .playing {
            pauseStream()
        } else {
            if let url = station?.url_resolved {
                playStream(from: url)
            }
        }
    }
    
    @IBAction func favButtonPressed(_ sender: Any) {
        switch isFavourite {
        case .isFavourite:
            removeFromFavorites()
        case .notFavourite, .none:
            addToFavorites()
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: Any) {
        changeVolume(value: volumeSlider.value)
    }
}

extension RadioPlayerViewController {
    func initAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch let error {
            print(error)
        }
    }
    
    func playStream(from url: String) {
        guard let url = URL(string: url) else { return }
        
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        
        player.volume = volumeSlider.value
        
        updatePlayerUI(for: .playing)
    }
    
    func pauseStream() {
        player.pause()
        
        updatePlayerUI(for: .paused)
    }
    
    func changeVolume(value: Float) {
        player.volume = value
    }
    
    func updatePlayerUI(for state: PlayerState) {
        switch state {
        case .paused:
            playStopButton.setBackgroundImage(UIImage(named: "PlayIcon"), for: .normal)
        case .playing:
            playStopButton.setBackgroundImage(UIImage(named: "PauseIcon"), for: .normal)
        }
    }
}

extension RadioPlayerViewController {
    func addToFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "StationEntity", in: context)!
        let stationRecord = NSManagedObject(entity: entity, insertInto: context)
        
        stationRecord.setValue(self.station.name, forKey: "name")
        stationRecord.setValue(self.station.favicon, forKey: "imageURL")
        stationRecord.setValue(self.station.url_resolved, forKey: "streamURL")
        stationRecord.setValue(true, forKey: "isFavourite")
        
        appDelegate.saveContext()
        self.isFavourite = .isFavourite
        self.updateFavouriteUI(for: .isFavourite)
    }
    
    func removeFromFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "StationEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@", station.name)
        fetchRequest.fetchLimit = 1
        
        do {
            let record = try context.fetch(fetchRequest)
            record.first?.setValue(NSNumber(booleanLiteral: false), forKey: "isFavourite")
            
            appDelegate.saveContext()
            
            self.isFavourite = .notFavourite
            self.updateFavouriteUI(for: .notFavourite)
        } catch let error {
            print(error)
        }
    }
    
    func updateFavouriteUI(for state: FavState) {
        switch state {
        case .notFavourite:
            UIView.transition(
                with: favButton,
                duration: 0.5,
                options: .curveEaseInOut,
                animations: {
                    self.favButton.setBackgroundImage(
                        UIImage(named: "AddFavoriteIcon"),
                        for: .normal)
                },
                completion: nil)
        case .isFavourite:
            UIView.transition(
                with: favButton,
                duration: 0.5,
                options: .curveEaseInOut,
                animations: {
                    self.favButton.setBackgroundImage(
                        UIImage(named: "RemoveFavoriteIcon"),
                        for: .normal)
                },
                completion: nil)
        }
    }
}

enum PlayerState {
    case playing
    case paused
}

enum FavState {
    case isFavourite
    case notFavourite
}
