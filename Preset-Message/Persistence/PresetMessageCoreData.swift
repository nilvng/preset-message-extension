////
////  PresetMessageManager.swift
////  Preset-Message
////
////  Created by Nil Nguyen on 22/10/2022.
////
//
//import Foundation
//
//import CoreData
//
//struct CoreDataManager {
//
//    static let shared = CoreDataManager()
//
//    let persistentContainer: NSPersistentContainer = {
//
//        let container = NSPersistentContainer(name: "Preset_Message")
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error {
//                fatalError("Loading of store failed \(error)")
//            }
//        }
//
//        return container
//    }()
//
//    @discardableResult
//    func createPresetMessage(text: String) -> PresetMessage? {
//        let context = persistentContainer.viewContext
//
//        // old way
//        // let resetMessage = NSEntityDescription.insertNewObject(forEntityName: "PresetMessage", into: context) as! PresetMessage // NSManagedObject
//
//        // new way
//        let presetMessage = PresetMessage(context: context)
//
//        presetMessage.text = text
//
//        do {
//            try context.save()
//            return presetMessage
//        } catch let error {
//            print("Failed to create: \(error)")
//        }
//
//        return nil
//    }
//
//    func fetchPresetMessages() -> [PresetMessage]? {
//        let context = persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<PresetMessage>(entityName: "PresetMessage")
//
//        do {
//            let employees = try context.fetch(fetchRequest)
//            return employees
//        } catch let error {
//            print("Failed to fetch companies: \(error)")
//        }
//
//        return nil
//    }
//
//    func fetchPresetMessage(withName name: String) -> PresetMessage? {
//        let context = persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<PresetMessage>(entityName: "PresetMessage")
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//
//        do {
//            let employees = try context.fetch(fetchRequest)
//            return employees.first
//        } catch let error {
//            print("Failed to fetch: \(error)")
//        }
//
//        return nil
//    }
//
//    func updatePresetMessage(employee: PresetMessage) {
//        let context = persistentContainer.viewContext
//
//        do {
//            try context.save()
//        } catch let error {
//            print("Failed to update: \(error)")
//        }
//    }
//
//    func deletePresetMessage(presetMessage: PresetMessage) {
//        let context = persistentContainer.viewContext
//        context.delete(presetMessage)
//
//        do {
//            try context.save()
//        } catch let error {
//            print("Failed to delete: \(error)")
//        }
//    }
//
//}
