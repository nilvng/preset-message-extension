//
//  PresetMessageSQL.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 24/10/2022.
//

import Foundation
import GRDB

struct PresetMessageSQL : Codable, FetchableRecord, PersistableRecord{
    var pid: Int64?
    var text : String
    var category : Int?
    
    func toViewModel() -> PresetMessageViewModel{
        var vm = PresetMessageViewModel(text: self.text)
        vm.id = self.pid
        if let category = category {
            vm.category = Categories(rawValue: category)
        }
        return vm
    }
    
    static func from(viewModel: PresetMessageViewModel) -> PresetMessageSQL {
        return PresetMessageSQL(pid: viewModel.id,
                                text: viewModel.text,
                                category: viewModel.category?.rawValue)
    }
}
