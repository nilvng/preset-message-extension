//
//  PresetMessageViewModel.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import Foundation

struct PresetMessageViewModel{
    init(text: String) {
        self.text = text
    }
    var id : Int64?
    var text : String
    var queryItems : [URLQueryItem] {
        [URLQueryItem(name: "preset", value: self.text)]
    }
    
}

extension PresetMessageViewModel {
    static let greeting = PresetMessageViewModel(text: "Hey, hows it goin?")
    static let brb = PresetMessageViewModel(text: "Ill be right back")
    static let seeyah = PresetMessageViewModel(text: "see yah!")
}
