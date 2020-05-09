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
    
    var tag: Tag?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = tag?.name ?? "Default value"
        Utils.addBackgroundImage(tableView)
    }
}

extension StationsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clear
        return cell
    }
}

extension StationsViewController {
    
}
