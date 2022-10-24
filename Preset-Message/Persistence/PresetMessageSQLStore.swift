//
//  PresetMessageSQLStore.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 24/10/2022.
//

import Foundation
import GRDB

class PresetMessageSQLStore {
    
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
        guard let folderURL = fileManager
            .containerURL(forSecurityApplicationGroupIdentifier: "blinq.challenge")?
            .appendingPathComponent("database", isDirectory: true) else {fatalError()}
        
        try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        
        // Connect to a database on disk
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
    
}

// MARK: CRUD
extension PresetMessageSQLStore{
    func getAll(completion : @escaping ([PresetMessageSQL]?) -> Void) throws {
        let res = try dbConnection?.write { db in
            return try PresetMessageSQL.fetchAll(db)
        }
        completion(res)
    }
    func save(_ msg: inout PresetMessageSQL) throws{
        try dbConnection?.write { db in
            try msg.save(db)
            msg.pid = db.lastInsertedRowID
        }
    }
    func delete(ids : [Int64]) throws {
        try dbConnection?.write { db in
            _ = try PresetMessageSQL.deleteAll(db, keys: ids)
        }
    }
//    func update(){}
}
