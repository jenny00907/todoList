//
//  Item.swift
//  Todo
//
//  Created by Jenny Woorim Lee on 2021/02/16.
//

import Foundation
import RealmSwift

class Item:Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date: Date?

    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
