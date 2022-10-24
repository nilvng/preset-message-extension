//
//  InputTableViewCell.swift
//  Preset-Message
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

protocol InputTableViewCellDelegate {
    func inputCell(submitted: String)
}

class TextInputTableHeaderView: UITableViewHeaderFooterView {
    
    var delegate : InputTableViewCellDelegate?
    
    static var identifier = "textInputHeader"
    
    var textField = UITextField()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
        textField.placeholder = "Enter new preset message..."
        textField.clearButtonMode = .whileEditing
        
        setupTextField()
    }
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTextField(){
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}

extension TextInputTableHeaderView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text{
            self.delegate?.inputCell(submitted: text)
        }
        textField.text = "" // clear field
        return true
    }
    
}
