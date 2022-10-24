//
//  PresetManager.swift
//  Preset-Message-Extension
//
//  Created by Nil Nguyen on 24/10/2022.
//

import Foundation
import GRDB

class PresetManager {
    
    var dbConnection : DatabaseQueue?
    
    init() {
        do {
            try openConnection(path: "presets.sqlite")
            try defineSchema()
        }catch{
            print("Can't setup SQLite table PresetMessage")
        }
        
    }
    func openConnection(path: String) throws{
        let fileManager = FileManager()
        let folderURL = try fileManager.containerURL(forSecurityApplicationGroupIdentifier: "blinq.challenge")!.appendingPathComponent("database", isDirectory: true)
        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        // Connect to a database on disk
        // See https://github.com/groue/GRDB.swift/blob/master/README.md#database-connections
        let dbURL = folderURL.appendingPathComponent(path)
        print("db path: ", dbURL.path)
        dbConnection = try DatabaseQueue(path: dbURL.path)
    }
    func defineSchema() throws{
        try dbConnection?.write { db in
            try db.create(table: "presetMessageSQL", ifNotExists: true){ t in
                t.autoIncrementedPrimaryKey("pid")
                t.column("text", .text).notNull()
            }
        }
    }
    
    func fetchAll(completion : @escaping ([PresetMessageSQL]?) -> Void) throws{
        let res = try dbConnection?.write { db in
            return try PresetMessageSQL.fetchAll(db)
        }
        completion(res)
    }
    
}
