//
//  ViewController.swift
//  Todoey
//
//  Created by Umair Latif on 09/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //var defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
        
        //Delete From CoreData
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: itemArray[indexPath.row])
        
        self.SaveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Mark - Add New Item
    
    @IBAction func AddNewItemButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //When user press the add item button on alert
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
        
        do{
            
            try context.save()
            
        } catch{
            
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        } catch{
            
            print("Error Load Data \(error)")
        }
        
        tableView.reloadData()
    }
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request)
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

