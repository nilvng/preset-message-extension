//
//  Presenter.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 24/10/2022.
//

import Foundation

protocol PresetMessageView : AnyObject {
    func setPresets(_ presets : [PresetMessageViewModel])
//    func updatedPreset(_ preset: PresetMessageViewModel)
}

class Presenter {

    var store : PresetMessageSQLStore
    var view : PresetMessageView
    
    init(store: PresetMessageSQLStore, view: PresetMessageView) {
        self.store = store
        self.view = view
    }
    
    func getPresets(){
        do{
            try store.getAll { presets in
                guard let presets = presets else {
                    return
                }
                let mappedPresets = presets.map { $0.toViewModel()}
                self.view.setPresets(mappedPresets)
            }
        } catch {
            print("Error: fetch presets")
        }
    }
    
    func createPreset(_ preset: PresetMessageViewModel){
        do{
            var mapped = PresetMessageSQL.from(viewModel: preset) // this is updated with new id, if it has not existed
            try store.save(&mapped)
        } catch let e {
            print("Error: save preset")
            print(e.localizedDescription)
        }
    }
    
    func deletePreset(_ preset: PresetMessageViewModel){
        do{
            guard let id = preset.id else {
                return
            }
            try store.delete(ids: [id])
        }catch let e {
            print("Error: delete preset")
            print(e.localizedDescription)
        }
    }
    
    func editPreset(_ preset: PresetMessageViewModel){
        createPreset(preset)
    }
    
}


