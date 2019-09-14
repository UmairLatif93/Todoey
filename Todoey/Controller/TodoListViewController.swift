//
//  ViewController.swift
//  Todoey
//
//  Created by Umair Latif on 09/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    //var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
//        let newItem = Item()
//        newItem.title = "Umair Latif"
//        itemArray.append(newItem)
        
        
//        if let itmes = defaults.array(forKey: "ToDoListArray") as? [Item] {
//
//            itemArray = itmes
//        }
        
        //load data
        
        loadData()
    }

    //Mark - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let nItem = itemArray[indexPath.row]
        
        cell.textLabel?.text = nItem.title
        
        cell.accessoryType = nItem.done ? .checkmark : .none
        
        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.SaveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Mark - Add New Item
    
    @IBAction func AddNewItemButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //When user press the add item button on alert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.SaveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Data Manpulation Method
    
    func SaveItems(){
        
        let encoder = PropertyListEncoder()
        
        do{
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        } catch{
            
            print("Error Encodeing \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(){
        
        if let data = try? Data.init(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do{
                
            itemArray = try decoder.decode([Item].self, from: data)
                
            } catch{
                
                print(error)
            }
        }
    }
    
}

