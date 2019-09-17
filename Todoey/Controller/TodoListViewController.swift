//
//  ViewController.swift
//  Todoey
//
//  Created by Umair Latif on 09/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    let realm = try! Realm()
    
    var itemArray : Results<Item>?
    
    var selectedCategory : Category? {
        
        didSet{
            
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
    }

    //Mark - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        } else {
            
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        return cell
    }
    
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            
            do {
                
                try realm.write {
                    
                    item.done = !item.done
                }
            } catch {
                
                print("Error Updating Data \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Mark - Add New Item
    
    @IBAction func AddNewItemButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //When user press the add item button on alert
            
            if textField.text != ""{
                
                if let currentCategory = self.selectedCategory {
                    
                    do{
                        
                        try self.realm.write {
                            
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.item.append(newItem)
                        }
                        
                    } catch{
                        
                        print("Error saving data \(error)")
                    }
            
                }
                
                self.tableView.reloadData()
                
            } else {
                
                let failureAlert = UIAlertController(title: "Error in saving Data", message: "Name cannot be empty", preferredStyle: .alert)
                
                self.present(failureAlert, animated: true, completion: nil)
                //failureAlert.dismiss(animated: true, completion: nil)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    failureAlert.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //Mark - Data Manpulation Method
    
    func loadData(){

        itemArray = selectedCategory?.item.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {

            self.loadData()

            DispatchQueue.main.async {

                searchBar.resignFirstResponder()
            }
        }
    }
}

