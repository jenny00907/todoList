//
//  Model.swift
//  Todo
//
//  Created by Jenny Woorim Lee on 2021/02/16.
//

import Foundation
import RealmSwift

class Category:Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
    
}
