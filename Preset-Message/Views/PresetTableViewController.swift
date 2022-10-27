//
//  ViewController.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

class PresetTableViewController: UITableViewController {

    var cellID = "presetCell"
    var itemsByCategory : [PresetMessageTagModel] = []
    var items : [PresetMessageViewModel] = []
    
    var categories = Categories.allCases
    var numRecords : [Int] = []
    
    lazy var presenter  = Presenter(store: PresetMessageSQLStore(), view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
//        let data = [PresetMessageViewModel.greeting,
//                    PresetMessageViewModel.brb,
//                    PresetMessageViewModel.seeyah]
//        self.items = data
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
        categories.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsByCategory[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        categories[section].getText()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID) ?? UITableViewCell(style: .value1, reuseIdentifier: self.cellID)

        let itemsOfCategory = self.itemsByCategory[indexPath.section].items
        
        cell.textLabel?.text = itemsOfCategory[indexPath.row].text
        
        cell.textLabel?.numberOfLines = -1
//        cell.detailTextLabel?.text = items[indexPath.item].category?.rawValue ?? ""
        return cell
    }
    
//- MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// TODO: update preset
        let m = self.itemsByCategory[indexPath.section].items[indexPath.row]
        let editVC = PresetEditViewController()
        editVC.configure(preset: m)
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let p = self.items[indexPath.item]
            self.tableDelete(indexPath: indexPath)
//            self.presenter.deletePreset(p)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let inputView =  TextInputTableHeaderView()
//        inputView.delegate = self
//        return inputView
        nil
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
        self.itemsByCategory = []
        
        for category in categories {
            var tagModel = PresetMessageTagModel(categoryName: category)
            tagModel.setItems(data: self.items)
            self.itemsByCategory.append(tagModel)
        }
        
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
