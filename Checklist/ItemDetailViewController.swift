//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Сергей Герасимов on 15.10.2022.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject{
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController)
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: CheckListItem)
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: CheckListItem)
}


class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarBotton: UIBarButtonItem!
    
    weak var delegate: AddItemViewControllerDelegate?
    
    var itemToEdit: CheckListItem?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit{
            title = "Edit item"
            textField.text = item.text
            doneBarBotton.isEnabled = true
        }
    }
// MARK: - Actions
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done(){
        if let item = itemToEdit{
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            
    }else{
        let item = CheckListItem()
        item.text = textField.text!
        
        delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
// MARK: - Table view delegate
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath?{
        return nil
    }
//MARK: - Text field delegate
    

    
    func textField(_ textField: UITextField,
         shouldChangeCharactersIn range: NSRange,
                   replacementString string: String
    ) -> Bool{
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarBotton.isEnabled = !newText.isEmpty
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarBotton.isEnabled = false
        return true
    }
//    weak var delegate: AddItemViewControllerDelegate?
}
