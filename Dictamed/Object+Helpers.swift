//
//  Object+Helpers.swift
//  Dictamed
//
//  Created by Adrian Mateoaea on 14.06.2016.
//  Copyright © 2016 Adrian Mateoaea. All rights reserved.
//

import Foundation
import RealmSwift

extension Object {
    
    func add(update update: Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: update)
        }
    }
    
    static func get<T: Object>(filter: String) -> [T] {
        let realm = try! Realm()
        return realm.objects(T).filter(filter).map { $0 }
    }
    
    static func getAll<T: Object>() -> [T] {
        let realm = try! Realm()
        return realm.objects(T).map { $0 }
    }
    
    static func getById<T: Object>(id: String) -> T? {
        let realm = try! Realm()
        return realm.objectForPrimaryKey(T.self, key: id)
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
    static func deleteAll() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
}

extension Array where Element: Object {
    
    func addAll(update update: Bool = false) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: update)
        }
    }
    
    func delete() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
    
}
