//
//  PresetMessageViewController.swift
//  Message-Preset
//
//  Created by Nil Nguyen on 21/10/2022.
//

import Foundation
import UIKit
protocol PresetMessageViewControllerDelegate : AnyObject{
    func messageDidSelect(message: PresetMessageViewModel)
}
class PresetMessageViewController : UITableViewController{
    
    var items : [PresetMessageViewModel] = []
    var delegate : PresetMessageViewControllerDelegate?
    lazy var manager = PresetManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "presetCell")
        populateData()
    }
    
    func populateData(){
        print("populate data...")
        do{
            try self.manager.fetchAll { [weak self] presetSQLs in
                guard let presets = presetSQLs else {
                    return
                }
                let mappedPresets = presets.map { $0.toViewModel()}
                self?.setPresets(mappedPresets)
            }
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    func setPresets(_ presets: [PresetMessageViewModel]) {
        self.items = presets
        self.tableView.reloadData()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetCell", for: indexPath)

        cell.textLabel!.text = items[indexPath.item].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let m = items[indexPath.item]
        self.delegate?.messageDidSelect(message: m)
    }
}
