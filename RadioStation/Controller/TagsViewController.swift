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

    var tempTags = ["Jazz", "Blues", "Classical", "Country"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "TagCell", bundle: nil), forCellReuseIdentifier: TagCellIdentifier)
        
        addBackgroundImage()
    }
    
    private func addBackgroundImage() {
        let bgImage = UIImageView(image: UIImage(named: "AppBackground"))
        bgImage.frame = tableView.frame
        tableView.backgroundView = bgImage
    }
}

// MARK: - Table view delegate
extension TagsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - Table view data source
extension TagsViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TagCellIdentifier, for: indexPath) as! TagCell
        cell.genreInitialLabel?.text = String(tempTags[indexPath.row].prefix(1))
        cell.genreLabel?.text = tempTags[indexPath.row]
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.clear : UIColor.black.withAlphaComponent(0.4)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempTags.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
