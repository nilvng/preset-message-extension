//
//  ViewController.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

class PresetTableViewController: UITableViewController {

    var items : [PresetMessageViewModel] = []
//    var delegate : ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = "Preset Messages"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "presetCell")
        tableView.register(InputTableViewCell.self, forCellReuseIdentifier: "inputCell")

        items = [
            PresetMessageViewModel.greeting,
            PresetMessageViewModel.brb,
            PresetMessageViewModel.seeyah
        ]
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = items[indexPath.item - 1]
//        self.delegate?.messageDidSelect(message: m)
    }

}

extension PresetTableViewController : InputTableViewCellDelegate {
    func inputCell(submitted text: String) {
        items.append(PresetMessageViewModel(text: text))
        tableView.reloadData()
    }
    
    
}
