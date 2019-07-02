//
//  WikiTableViewController.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class WikiTableViewController: UITableViewController {

	lazy var searchController: UISearchController = {
		let searchController = UISearchController(searchResultsController: nil)
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Search City"
		return searchController
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		definesPresentationContext = true
    }
}

extension WikiTableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 0
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 0
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
		return cell
	}
}

extension WikiTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		
	}
}
