//
//  PresetMessageTagModel.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 26/10/2022.
//

import Foundation

struct PresetMessageTagModel {
    var categoryName : Categories
    var items : [PresetMessageViewModel] = []
    
    mutating func setItems(data: [PresetMessageViewModel]){
        if categoryName == .Others {
            items = data.filter { $0.category == categoryName || $0.category == nil }
        } else{
            items = data.filter { $0.category == categoryName}
        }
        
    }
}
