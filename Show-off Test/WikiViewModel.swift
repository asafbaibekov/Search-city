//
//  WikiViewModel.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class WikiViewModel {

	private var downloadQueue: OperationQueue = {
		let queue = OperationQueue()
		queue.name = "Image downloader queue"
		return queue
	}()

	private var wikiEntities: [WikiEntity]
	private(set) var rows: Int

	var onComplete: (() -> Void)?

	init() {
		self.wikiEntities = [WikiEntity]()
		self.rows = wikiEntities.count
	}
}

extension WikiViewModel {
	func fetch(with keyword: String?) {
		NetworkManager.shared.fetchWiki(
			with: keyword,
			complition: { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .success(let wikiEntities):
					self.wikiEntities = wikiEntities
					self.rows = wikiEntities.count
					CoreDataHandler.save(wikiEntities: wikiEntities, with: keyword)
					self.onComplete?()
				case .failure(let error):
					print(error.localizedDescription)
					self.wikiEntities = CoreDataHandler.getWikiEntities(by: keyword)
					self.rows = self.wikiEntities.count
					self.onComplete?()
				}
			}
		)
	}
	func addImageOperation(with indexPath: IndexPath, complition: @escaping (IndexPath) -> Void) {
		let operation = ImageDownloadOperation(wikiEntity: getWikiEntity(at: indexPath), indexPath: indexPath)
		operation.completionBlock = { [weak operation] in
			guard let operation = operation, !operation.isCancelled else { return }
			DispatchQueue.main.async {
				complition(operation.indexPath)
			}
		}
		self.downloadQueue.addOperation(operation)
	}
}

extension WikiViewModel {
	func getWikiEntity(at indexPath: IndexPath) -> WikiEntity {
		return self.wikiEntities[indexPath.row]
	}
	func getTitle(by indexPath: IndexPath) -> String? {
		return self.wikiEntities[indexPath.row].title
	}
	func getSummary(by indexPath: IndexPath) -> String? {
		return self.wikiEntities[indexPath.row].summary
	}
	func getImageURL(by indexPath: IndexPath) -> URL? {
		return self.wikiEntities[indexPath.row].thumbnailImg
	}
	func getImageData(by indexPath: IndexPath) -> Data? {
		return self.wikiEntities[indexPath.row].imageData
	}
}
