//
//  Item.swift
//  Todoey
//
//  Created by Umair Latif on 09/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import Foundation

class Item : Encodable, Decodable {
    
    var title : String = ""
    var done : Bool = false
    
}
