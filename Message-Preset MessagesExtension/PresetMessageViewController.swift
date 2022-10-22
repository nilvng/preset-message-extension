//
//  PresetMessageViewController.swift
//  Message-Preset
//
//  Created by Nil Nguyen on 21/10/2022.
//

import Foundation
import UIKit
protocol PresetMessageViewControllerDelegate : AnyObject{
    func messageDidSelect(message: PresetMessage)
}
class PresetMessageViewController : UITableViewController{
    
    var items : [PresetMessage] = []
    var delegate : PresetMessageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "presetCell")
        items = [
            PresetMessage.greeting,
            PresetMessage.brb,
            PresetMessage.seeyah
        ]
        
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
