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
    var commentLabel = UILabel()
    
    var preset : PresetMessageViewModel!
    var delegate :PresetEditViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Preset Message"
        view.backgroundColor = .systemBackground
        
        setupTextField()
        setupCommentLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
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
            ])
    }
    
    func setupCommentLabel(){
        self.view.addSubview(commentLabel)
        commentLabel.textAlignment = .center
        commentLabel.text = "default"
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            commentLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            ])
    }
    
    func configure(preset: PresetMessageViewModel){
        self.preset = preset
        textField.text = preset.text
    }


}
// MARK: TextFieldDelegate
extension PresetEditViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        commentLabel.text = "Updating..."
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text != " " else {
            return false
        }
        preset.text = text
        self.delegate?.presetEdit(updatedPreset: self.preset)
        commentLabel.text = "Updated!"
        return true
    }
    
}
