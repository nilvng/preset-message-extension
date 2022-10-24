//
//  PresetEditViewController.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 24/10/2022.
//

import UIKit
protocol PresetEditViewDelegate : AnyObject {
    func presetEdit(updatedPreset: PresetMessageViewModel)
}
class PresetEditViewController: UIViewController {
    
    var textField = UITextField()
    var preset : PresetMessageViewModel!
    var delegate :PresetEditViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTextField()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupTextField(){
        self.view.addSubview(textField)
        textField.delegate = self
        textField.borderStyle = .line
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0),
//            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func configure(preset: PresetMessageViewModel){
        self.preset = preset
        textField.text = preset.text
    }


}

extension PresetEditViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != " " else {
            return false
        }
        preset.text = text
        self.delegate?.presetEdit(updatedPreset: self.preset)
        return false
    }
    
}
