//
//  ViewController.swift
//  RadioStation
//
//  Created by Airam Rguez on 09/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import UIKit

class TagsViewController: UITableViewController {
    private let TagCellIdentifier = "TagCell"

    var tags: [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TagCell", bundle: nil), forCellReuseIdentifier: TagCellIdentifier)
        
        Utils.addBackgroundImage(tableView)
        downloadRadioStations()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStationsForTag",
            let stationsVC = segue.destination as? StationsViewController {
            guard let selectedTag = sender as? Tag else { return }
            stationsVC.tag = selectedTag
        } else if segue.identifier == "showFavourites",
            let stationsVC = segue.destination as? StationsViewController {
            guard let favouriteStations = sender as? [Station] else { return }
            stationsVC.stations = favouriteStations
        }
    }
    
    private func downloadRadioStations() {
        RadioAPI.getTags() { [weak self] (tags) in
            guard let self = self else { return }
            self.tags = tags
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func starButtonPressed(_ sender: Any) {
        performSegue(
            withIdentifier: "showFavourites",
            sender: DirbleAPI.fetchFavouriteStations())
    }
}

// MARK: - Table view delegate
extension TagsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showStationsForTag", sender: tags[indexPath.row])
    }
}

// MARK: - Table view data source
extension TagsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagCellIdentifier, for: indexPath) as! TagCell
        let tag = tags[indexPath.row]
        cell.genreInitialLabel?.text = String(tag.name.prefix(1))
        cell.genreLabel?.text = tag.name
        cell.stationsCountLabel?.text = String("Estaciones: \(tag.stationcount)")
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.clear : UIColor.black.withAlphaComponent(0.4)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
