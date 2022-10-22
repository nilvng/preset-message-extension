//
//  PresetMessage.swift
//  Message-Preset
//
//  Created by Nil Nguyen on 22/10/2022.
//

import Foundation
import UIKit

struct PresetMessage{
    var text : String
    
    var queryItems : [URLQueryItem] {
        [URLQueryItem(name: "preset", value: self.text)]
    }
}

extension PresetMessage {
    static let greeting = PresetMessage(text: "Hey, hows it goin?")
    static let brb = PresetMessage(text: "Ill be right back")
    static let seeyah = PresetMessage(text: "see yah!")
}

