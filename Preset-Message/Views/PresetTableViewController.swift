//
//  ViewController.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

class PresetTableViewController: UITableViewController {

    var cellID = "presetCell"
    var newPresetTextField : UITextField?
    
    var itemsByCategory : [PresetMessageTagModel] = []
    var items : [PresetMessageViewModel] = []
    var categories = Categories.allCases
    var numRecords : [Int] = []
    
    lazy var presenter  = Presenter(store: PresetMessageSQLStore(), view: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Preset Messages"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(onClickAddPreset))
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
    
    @objc func onClickAddPreset(){
        let addAction = UIAlertAction(title: "Add", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let alertController = UIAlertController(title: "New preset", message: nil, preferredStyle: .alert)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        alertController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        alertController.addTextField()
        self.newPresetTextField = alertController.textFields![0]
        newPresetTextField?.delegate = self
        
        self.present(alertController, animated: true)
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
            let m = self.itemsByCategory[indexPath.section].items[indexPath.row]
            self.tableDelete(indexPath: indexPath)
            self.presenter.deletePreset(m)
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
        var model : PresetMessageTagModel = PresetMessageTagModel(categoryName: .Others)
        var index = -1
        for (i, tagModel) in self.itemsByCategory.enumerated() {

            if (preset.category == nil && tagModel.categoryName == .Others) ||
                (tagModel.categoryName == preset.category) {
                model = tagModel
                index = i
                break
            }
        }
        model.items.append(preset)
        if index > -1{
            self.itemsByCategory.append(model)
            self.itemsByCategory[index] = model
        }
        tableView.reloadData()
    }
    
    func tableDelete(indexPath: IndexPath){
        self.itemsByCategory[indexPath.section].items.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension PresetTableViewController : PresetEditViewDelegate {
    
    func presetEdit(updatedPreset: PresetMessageViewModel) {
        self.presenter.editPreset(updatedPreset)
    }
}

extension PresetTableViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text{
            self.inputCell(submitted: text)
        }
        textField.text = "" // clear field
        return true
    }
}
