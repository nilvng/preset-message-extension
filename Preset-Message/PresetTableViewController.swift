//
//  ViewController.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

class PresetTableViewController: UITableViewController {

    var items : [PresetMessageViewModel] = []
    lazy var presenter  = Presenter(store: PresetMessageSQLStore(), view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = "Preset Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "presetCell")
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputCell")
        
        populateData()
    }
    
    func populateData(){
        
//        items = [
//            PresetMessageViewModel.greeting,
//            PresetMessageViewModel.brb,
//            PresetMessageViewModel.seeyah
//        ]
        
        self.presenter.getPresets()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.item == 0, let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as? InputTableViewCell{
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath)

        cell.textLabel!.text = items[indexPath.item - 1].text
        return cell
    }
    
//- MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TODO: update preset
        let m = items[indexPath.item - 1]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let p = self.items[indexPath.item - 1]
            self.tableDelete(indexPath: indexPath)
            self.presenter.deletePreset(p)
        }
    }

}

// MARK: Cell Delegate
extension PresetTableViewController : InputTableViewCellDelegate {
    func inputCell(submitted text: String) {
        let newPreset = PresetMessageViewModel(text: text)
        self.tableAdd(preset: newPreset)
        self.presenter.createPreset(newPreset)
    }
    
}
// MARK: PresetMessageView
extension PresetTableViewController : PresetMessageView {
    func setPresets(_ presets: [PresetMessageViewModel]) {
        self.items = presets
        self.tableView.reloadData()
    }
}

// MARK: UI Data
extension PresetTableViewController {
    func tableAdd(preset: PresetMessageViewModel){
        self.items.append(preset)
        tableView.reloadData()
    }
    
    func tableDelete(indexPath: IndexPath){
        self.items.remove(at: indexPath.item - 1)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
