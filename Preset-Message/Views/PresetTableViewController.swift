//
//  ViewController.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

class PresetTableViewController: UITableViewController {

    var cellID = "presetCell"
    var items : [PresetMessageViewModel] = []
    lazy var presenter  = Presenter(store: PresetMessageSQLStore(), view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = "Preset Messages"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: self.cellID)
        tableView.register(TextInputTableHeaderView.self,
                           forHeaderFooterViewReuseIdentifier: TextInputTableHeaderView.identifier)
        populateData()
    }
    
    func populateData(){
        self.presenter.getPresets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.populateData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)

        cell.textLabel?.text = items[indexPath.item].text
        cell.textLabel?.numberOfLines = -1
        
        return cell
    }
    
//- MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TODO: update preset
        let m = items[indexPath.item]
        let editVC = PresetEditViewController()
        editVC.configure(preset: m)
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let p = self.items[indexPath.item]
            self.tableDelete(indexPath: indexPath)
            self.presenter.deletePreset(p)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let inputView =  TextInputTableHeaderView()
        inputView.delegate = self
        return inputView
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
    func createdPreset(id: Int64) {
        guard self.items.count > 0 else{return}
        self.items[self.items.count - 1].id = id
    }
    
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
        self.items.remove(at: indexPath.item)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension PresetTableViewController : PresetEditViewDelegate {
    
    func presetEdit(updatedPreset: PresetMessageViewModel) {
        self.presenter.editPreset(updatedPreset)
    }
    
    
}
