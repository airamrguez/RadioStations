//
//  StationsViewController.swift
//  RadioStation
//
//  Created by Airam Rguez on 09/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import UIKit

class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private let StationCellIdentifier = "StationCell"
    
    var tag: Tag?
    var stations: [Station]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "StationCell", bundle: nil), forCellReuseIdentifier: StationCellIdentifier)
        self.navigationItem.title = tag?.name ?? "Default value"
        
        if let tag = tag {
            RadioAPI.getStations(for: tag.name) { stations in
                self.stations = stations
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            let stationsURL = RadioAPI.stationsForTagURL(categoryID: tag.name)
            print(stationsURL)
        }
        
        Utils.addBackgroundImage(tableView)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlayer",
            let radioPlayerVC = segue.destination as? RadioPlayerViewController {
            guard let selectedStation = sender as? Station else { return }
            print(selectedStation)
            radioPlayerVC.station = selectedStation
        }
    }
}

extension StationsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StationCellIdentifier) as! StationCell
        cell.backgroundColor = UIColor.clear
        
        if let station = stations?[indexPath.row] {
            cell.stationNameLabel.text = station.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension StationsViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showPlayer", sender: stations?[indexPath.row])
    }
}
