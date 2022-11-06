//
//  ViewController.swift
//  Checklist
//
//  Created by Сергей Герасимов on 04.10.2022.
////    func itemDetailViewController(_ controller: AddItemViewController, didFinishAdding item: CheckListItem) {
//let newRowIndex = items.count
//items.append(item)
//
//let indexPath = IndexPath(row: newRowIndex, section: 0)
//let indexPaths = [indexPath]
//tableView.insertRows(at: indexPaths, with: .automatic)
//navigationController?.popViewController(animated: true)
//}
//
//func itemDetailViewController(_controller: AddItemViewController, didFinishEditing item: CheckListItem) {
//if let index = items.firstIndex(of: item) {
//let indexPath = IndexPath(row: index, section: 0)
//if let cell = tableView.cellForRow(at: indexPath) {
//configureText(for: cell, with: item)
//}
//}
//navigationController?.popViewController(animated: true)
//}


import SwiftUI
import UIKit
class ChecklistViewController: UITableViewController , AddItemViewControllerDelegate {
    //MARK: - Add item ViewController Delegates
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: CheckListItem) {
        let newRowIndex = items.count
        items.append(item)
    
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        saveCheckListItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: CheckListItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
    }
    }
    navigationController?.popViewController(animated: true)
        saveCheckListItems()
    }
    
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    var items = [CheckListItem]()
    
    var row0item = CheckListItem()
    var row1item = CheckListItem()
    var row2item = CheckListItem()
    var row3item = CheckListItem()
    var row4item = CheckListItem()
    
    func configureCheckmark(for cell: UITableViewCell, with item: CheckListItem){
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        }else{
            label.text = ""
        }
    }
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentsDirectory().appendingPathComponent("Checklist.plist")
    }
    
    func configureText(for cell: UITableViewCell, with item: CheckListItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    func saveCheckListItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }catch{
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    func loadCheckListItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let decoder = PropertyListDecoder()
            do{
                items = try decoder.decode([CheckListItem].self, from: data)
            }catch{
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let item1 = CheckListItem()
        item1.text = "Walk the dog"
        items.append(item1)
        
        let item2 = CheckListItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)

        let item3 = CheckListItem()
        item3.text = "Learn IOS development"
        item3.checked = true
        items.append(item3)
        
        let item4 = CheckListItem()
        item4.text = "Soccer practice"
        items.append(item4)
        
        let item5 = CheckListItem()
        item5.text = "Eat ice cream"
        item5.checked = true
        items.append(item5)
        
        let item6 = CheckListItem()
        item6.text = "Going to sleep"
        items.append(item6)
        
        print("Document folder is \(documentsDirectory())")
        print("Data fil path is \(dataFilePath())")
        // Do any additional setup after loading the view.
    }
    // MARK: - Table View Data Source
    override func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath){
          if let cell = tableView.cellForRow(at: indexPath){
              let item = items[indexPath.row]
              item.checked.toggle()
              configureCheckmark(for: cell, with: item)
          }
              
          tableView.deselectRow(at: indexPath, animated: true)
          saveCheckListItems()
      }
    
    override func tableView(
      _ tableView: UITableView,
      numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }
    

    override func tableView(
      _ tableView: UITableView,
      cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "ChecklistItem",
        for: indexPath)
        
        let item = items[indexPath.row]

        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
      return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath){
            //1
            items.remove(at: indexPath.row)
            //2
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            saveCheckListItems()
        }
    //MARK: - ACTIONS

    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?){
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }else if segue.identifier == "EditItem"{
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
}

