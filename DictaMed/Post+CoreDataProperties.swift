//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Adrian Mateoaea on 23.02.2016.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var createdAt: NSDate?
    @NSManaged var updatedAt: NSDate?
    @NSManaged var title: String?
    @NSManaged var translation: String?
    @NSManaged var collection: String?
    @NSManaged var id: String?
    @NSManaged var validated: NSNumber?

}
