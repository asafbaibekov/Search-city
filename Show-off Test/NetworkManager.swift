//
//  NetworkManager.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit

class NetworkManager {
	static let shared = NetworkManager()
	
	let wikiURL: String
	
	private init() {
		self.wikiURL = "http://api.geonames.org/wikipediaSearchJSON?maxRows=10&username=tingz&q="
	}
	
	func fetchWiki(with keyword: String?, complition: @escaping (Result<[WikiEntity], Error>) -> Void) {
		guard let keyword = keyword, !keyword.isEmpty else { complition(.success([WikiEntity]())); return }
		let url = URL(string: "\(wikiURL)\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)")!
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			DispatchQueue.main.async {
				if let error = error {
					complition(.failure(error))
				} else if let data = data {
					do {
						complition(.success(try JSONDecoder().decode(GeoNames.self, from: data).geonames))
					} catch {
						complition(.failure(error))
					}
				}
			}
		}.resume()
	}
}
