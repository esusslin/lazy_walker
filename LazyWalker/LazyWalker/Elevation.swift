//
//  Elevation.swift
//  LazyWalker
//
//  Created by Emmet Susslin on 2/21/17.
//  Copyright © 2017 Emmet Susslin. All rights reserved.
//

import Foundation
import RealmSwift

class Elevation: Object {
    
    dynamic var distance: Int = Int(0)
    dynamic var elevation: Int = Int(0)
    
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}
