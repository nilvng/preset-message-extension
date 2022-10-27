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
    var tagButton  = UIButton()
    
    lazy var transparentView = UIView()
    lazy var dropDownView = UITableView()
    lazy var dropDownData = Categories.allCases
    var selectedBtn : UIButton?
    
    var preset : PresetMessageViewModel!
    var delegate :PresetEditViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Preset Message"
        view.backgroundColor = .systemBackground
        
        setupTextField()
        setupCommentLabel()
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: Setup Views
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
    
    func setupButton(){
        self.view.addSubview(tagButton)
        tagButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tagButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            tagButton.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 20.0),
            tagButton.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
            ])
        
        tagButton.layer.cornerRadius = 5
        tagButton.clipsToBounds = true
        tagButton.configuration = UIButton.Configuration.borderedProminent()
        tagButton.configuration?.contentInsets = .init(top: 5, leading: 100,
                                                       bottom: 5, trailing: 100)
        tagButton.addTarget(self, action: #selector(onClickSelectTag), for: .touchUpInside)
    }
    
    func setupCommentLabel(){
        self.view.addSubview(commentLabel)
        commentLabel.textAlignment = .center
        commentLabel.text = ""
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            commentLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            commentLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            ])
    }
    
    // MARK: Configuration
    func configure(preset: PresetMessageViewModel){
        self.preset = preset
        textField.text = preset.text
        tagButton.setTitle(preset.category?.getText() ?? "Tag", for: .normal)

    }
    
    // MARK: animation
    func addDropdownView(frames: CGRect){
        /// add transparent view
        self.transparentView.frame = self.view.frame
        self.transparentView.backgroundColor = .black.withAlphaComponent(0.9)
        self.view.addSubview(transparentView)
        
        /// add table view
        self.dropDownView.frame = CGRect(x: frames.origin.x,
                                 y: frames.origin.y + frames.height,
                                 width: frames.width,
                                 height: 0)
        self.view.addSubview(self.dropDownView)
        self.dropDownView.delegate = self
        self.dropDownView.dataSource = self
        self.dropDownView.register(UITableViewCell.self, forCellReuseIdentifier: "dropdownCell")
        self.dropDownView.reloadData()
        
        /// setAction dismiss in transparent view
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(removeDropdownView))
        self.transparentView.addGestureRecognizer(tapGesture)
        
        /// animate  tableView aka dropdownView
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.dropDownView.frame = CGRect(x: frames.origin.x,
                                             y: frames.origin.y + frames.height,
                                             width: frames.width,
                                             height: CGFloat(self.dropDownData.count  * 50))
        }, completion: nil)
    }
    
    @objc func onClickSelectTag(_ sender: Any){
        guard let selectBtn = sender as? UIButton else{
            return
        }
        self.selectedBtn = selectBtn
        addDropdownView(frames: selectBtn.frame)
    }
    
    @objc func removeDropdownView(){
        guard let frames = self.selectedBtn?.frame else {return}
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.dropDownView.frame = CGRect(x: frames.origin.x,
                                     y: frames.origin.y + frames.height,
                                     width: frames.width,
                                     height: 0)
            
        }, completion: nil)
        
    }
    
}
// MARK: TextFieldDelegate
extension PresetEditViewController : UITextFieldDelegate {
  
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        commentLabel.text = "Updating..."
        return true
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


extension PresetEditViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.dropDownData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dropdownCell", for: indexPath)
        cell.textLabel?.text = self.dropDownData[indexPath.item].getText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = self.dropDownData[indexPath.item]
        
        if self.preset.category == nil || self.preset.category != selectedCategory{ // update preset
            self.preset.category = selectedCategory
            self.tagButton.setTitle(selectedCategory.getText(), for: .normal)
            self.delegate?.presetEdit(updatedPreset: self.preset)
        }

        removeDropdownView()
    }
    
}
