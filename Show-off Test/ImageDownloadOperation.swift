//
//  ImageDownloadOperation.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class ImageDownloadOperation: Operation {

	private(set) var wikiEntity: WikiEntity
	private(set) var indexPath: IndexPath

	init(wikiEntity: WikiEntity, indexPath: IndexPath) {
		self.wikiEntity = wikiEntity
		self.indexPath = indexPath
	}

	override func main() {
		guard !isCancelled, let url = self.wikiEntity.thumbnailImg else { return }
		self.wikiEntity.imageData = try? Data(contentsOf: url)
	}
}
