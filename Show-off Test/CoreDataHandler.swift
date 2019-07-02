//
//  MovieCoreDataHandler.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 02/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler {
	private class func getContext() -> NSManagedObjectContext {
		let delegate = UIApplication.shared.delegate as! AppDelegate
		return delegate.persistentContainer.viewContext
	}
	
	class func save(wikiEntities: [WikiEntity], with keyword: String?) {
		guard let keyword = keyword else { return }
		let context = getContext()

		let storeKeyword = Keyword(context: context)
		storeKeyword.keyword = keyword.lowercased()
		storeKeyword.wikies = NSSet(array:
			wikiEntities.map { (wikiEntity) -> Wiki in
				let storeWiki = Wiki(context: context)
				storeWiki.title = wikiEntity.title
				storeWiki.summary = wikiEntity.summary
				storeWiki.thumbnailImg = wikiEntity.thumbnailImg
				storeWiki.imageData = wikiEntity.imageData
				return storeWiki
			}
		)

		do {
			try context.save()
		} catch {
			print("unable to save data")
		}
	}

	class func getWikies(by keyword: String?) -> [WikiEntity] {
		let context = getContext()
		guard let keyword = keyword else { return [WikiEntity]() }
		let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
//		fetchRequest.predicate = NSPredicate(format: "keyword == %@", keyword.lowercased())
		guard let set = try? context.fetch(fetchRequest).first?.wikies else { return [WikiEntity]() }
		return (Array(set) as? [Wiki])?.map { WikiEntity(title: $0.title, summary: $0.summary, thumbnailImg: $0.thumbnailImg, imageData: $0.imageData) } ?? [WikiEntity]()
	}
}
