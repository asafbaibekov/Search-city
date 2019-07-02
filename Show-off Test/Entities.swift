//
//  Entities.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import Foundation

struct GeoNames: Decodable {
	let geonames: [WikiEntity]
}

class WikiEntity: Decodable {
	let title, summary: String?
	let thumbnailImg: URL?
	var imageData: Data?
}
