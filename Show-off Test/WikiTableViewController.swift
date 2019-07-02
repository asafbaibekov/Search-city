//
//  WikiTableViewController.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class WikiTableViewController: UITableViewController {

	var viewModel: WikiViewModel!

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
		self.viewModel = WikiViewModel()
		self.viewModel.onComplete = { [weak self] in
			self?.tableView.reloadData()
		}
    }
}

extension WikiTableViewController {
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.viewModel.rows
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
		cell.textLabel?.text = self.viewModel.getTitle(by: indexPath)
		cell.detailTextLabel?.text = self.viewModel.getSummary(by: indexPath)
		cell.detailTextLabel?.numberOfLines = 0
		return cell
	}
}

extension WikiTableViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		self.viewModel.fetch(with: searchController.searchBar.text)
	}
}
