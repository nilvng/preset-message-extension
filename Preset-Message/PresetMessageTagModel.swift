//
//  PresetMessageTagModel.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 26/10/2022.
//

import Foundation

enum Categories : Int, CaseIterable {
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
