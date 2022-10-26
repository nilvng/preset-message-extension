//
//  PresetMessageViewModel.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import Foundation

enum Categories : Int {
    case Others
    case Friend
    case Family
    case Business
    
    func getText() -> String {
        switch self {
        case .Friend:
            return "Friend"
        case .Family:
            return "Family"
        case .Business:
            return "Business"
        default:
            return "Others"
        }
    }
    
}

struct PresetMessageViewModel{

    var id : Int64?
    var text : String
    var category : Categories?
    
    var queryItems : [URLQueryItem] {
        [URLQueryItem(name: "preset", value: self.text)]
    }
    
}

extension PresetMessageViewModel {
    static let greeting = PresetMessageViewModel(text: "Hey, hows it goin?", category: .Friend)
    static let brb = PresetMessageViewModel(text: "Ill be right back", category: .Family)
    static let seeyah = PresetMessageViewModel(text: "see yah!")
}
