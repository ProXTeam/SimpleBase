//
//  RealmManager.swift
//  SongProcessor
//
//  Created by DoLH on 12/26/17.
//  Copyright © 2017 SMJ. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {

    class func config(){
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 3,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
                migration.enumerateObjects(ofType: RecordSave.className()) { oldObject, newObject in
                    
                    migration.enumerateObjects(ofType: RecordSave.className()) { oldObject, newObject in
                        // combine name fields into a single field
                        if (oldSchemaVersion < 2) {
                            newObject!["record_parent"] = ""
                        }
                        if oldSchemaVersion < 3{
                            newObject!["record_beat_vol"] = Double(1)
                            newObject!["record_vocal_vol"] = Double(1)
                        }
                        
                    }
                    
                }
                
        })
        
        
        Realm.Configuration.defaultConfiguration = config
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        _ = try! Realm()
        
        
    }
    
}
