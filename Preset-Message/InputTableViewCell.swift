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

class InputTableViewCell: UITableViewCell {
    
    var delegate : InputTableViewCellDelegate?
    
    var textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textField.delegate = self
        textField.placeholder = "Enter new preset message..."
        setupTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("cell selected")
        // Configure the view for the selected state
    }

    func setupTextField(){
        contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            textField.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            textField.topAnchor.constraint(equalTo: contentView.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }
}

extension InputTableViewCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let text = textField.text{
            self.delegate?.inputCell(submitted: text)
        }
        textField.text = "" // clear field
        return true
    }
    
}
