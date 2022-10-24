//
//  PresetMessageStore.swift
//  Message-Preset MessagesExtension
//
//  Created by Nil Nguyen on 21/10/2022.
//

import Foundation

struct PresetMessageStore {
    
    fileprivate var presetMessages = [String]()
    
    /// singleton
    private init(presetMessages: [String]) {
        self.presetMessages = presetMessages
    }

    /// Loads previously created `PresetMessage`s and returns a `PresetMessageHistory` instance.
    static func load() -> PresetMessageStore {
        var presetMessages = [String]()
        let defaults = UserDefaults.standard
        
//        if let savedPresetMessages = defaults.object(forKey: presetMessageHistory.userDefaultsKey) as? [String] {
//            PresetMessages = savedPresetMessages.compactMap { urlString in
//                guard let url = URL(string: urlString) else { return nil }
//                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
//                guard let queryItems = components.queryItems else { return nil }
//
//                return PresetMessage(queryItems: queryItems)
//            }
//        }
        
        // If no ice creams have been loaded, create some tasty examples.
        if presetMessages.isEmpty {
            presetMessages.append("Hi, how are you?")
            let historyToSave = PresetMessageStore(presetMessages: presetMessages)
            historyToSave.save()
        }
        
        return PresetMessageStore(presetMessages: presetMessages)
    }
    
    /// Saves the history.

    func save() {
        // Save a maximum number ice creams.
//        let presetMessagesToSave = presetMessages.suffix(PresetMessageHistory.maximumHistorySize)
//
//        // Map the ice creams to an array of URL strings.
//        let PresetMessageURLStrings: [String] = PresetMessagesToSave.compactMap { PresetMessage in
//            var components = URLComponents()
//            components.queryItems = PresetMessage.queryItems
//            return components.url?.absoluteString
//        }
//
//        let defaults = UserDefaults.standard
//        defaults.set(PresetMessageURLStrings as AnyObject, forKey: PresetMessageHistory.userDefaultsKey)
    }
    
    mutating func append(_ PresetMessage: String) {
        // Ensure that no duplicates are inserted into the history
        var newPresetMessages = self.presetMessages.filter { $0 != PresetMessage }
        newPresetMessages.append(PresetMessage)
        presetMessages = newPresetMessages
    }

}

/// Extends `PresetMessageHistory` to conform to the `Sequence` protocol so it can be used in for..in statements.

extension PresetMessageStore: Sequence {

    typealias Iterator = AnyIterator<String>
    
    func makeIterator() -> Iterator {
        var index = 0
        
        return Iterator {
            guard index < self.presetMessages.count else { return nil }
            
            let PresetMessage = self.presetMessages[index]
            index += 1
            
            return PresetMessage
        }
    }
    
}
