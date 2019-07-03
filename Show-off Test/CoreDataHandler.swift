//
//  CoreDataHandler.swift
//  Show-off Test
//
//  Created by Asaf Baibekov on 03/07/2019.
//  Copyright © 2019 Asaf Baibekov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler {

	private class func getContext() -> NSManagedObjectContext {
		let delegate = UIApplication.shared.delegate as! AppDelegate
		return delegate.persistentContainer.viewContext
	}

	private class func saveContext() {
		let context = getContext()
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print(error.localizedDescription)
				print("unable to save data")
			}
		}
	}

	class func save(wikiEntities: [WikiEntity], with keyword: String?) {
		guard let keyword = keyword else { return }
		let context = getContext()
		let storeKeyword = Keyword(context: context)
		storeKeyword.keyword = keyword.lowercased()
		replaceAllWikies(in: storeKeyword, with: wikiEntities)
		saveContext()
	}

	class func replaceAllWikies(in keyword: Keyword, with wikiEntities: [WikiEntity]) {
		saveContext()
		keyword.mutableSetValue(forKey: "wikies").removeAllObjects()
		saveContext()
		keyword.wikies = Set(wikiEntities.map { wikiEntity -> Wiki in
			let wiki = NSEntityDescription.insertNewObject(forEntityName: "Wiki", into: getContext()) as! Wiki
			wiki.title = wikiEntity.title
			wiki.summary = wikiEntity.summary
			wiki.thumbnailImg = wikiEntity.thumbnailImg
			wiki.imageData = wikiEntity.imageData
			return wiki
		}) as NSSet
		saveContext()
	}

	class func getWikiEntities(by keyword: String?) -> [WikiEntity] {
		let context = getContext()
		guard let keyword = keyword else { return [WikiEntity]() }
		let fetchRequest: NSFetchRequest<Keyword> = Keyword.fetchRequest()
		fetchRequest.predicate = NSPredicate(format: "keyword == %@", keyword.lowercased())
		guard let set = try? context.fetch(fetchRequest).first?.wikies else { return [WikiEntity]() }
		return (Array(set) as? [Wiki])?.map { WikiEntity(title: $0.title, summary: $0.summary, thumbnailImg: $0.thumbnailImg, imageData: $0.imageData) } ?? [WikiEntity]()
	}

}
