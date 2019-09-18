//
//  Category.swift
//  Todoey
//
//  Created by Umair Latif on 17/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var bgColor : String = ""
    
    let item = List<Item>()
}
