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
        items = data.filter { $0.category == categoryName}
        
    }
}
