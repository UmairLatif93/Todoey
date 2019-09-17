//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Umair Latif on 16/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray : Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()

         loadData()
    }
    
    //Mark - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = itemArray?[indexPath.row].name ?? "No Categories Added Yet"
        
        return cell
    }
    
    //Mark - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //self.SaveItems()
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = itemArray?[indexPath.row]
        }
    }
    
    //Mark - Data Manipulation Methods
    
    func Save(category : Category){
        
        do{
            
            try realm.write {
                
                realm.add(category)
            }
            
        } catch{
            
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(){
        
        itemArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //When user press the add item button on alert
            
            if textField.text != ""{
                
            let newItem = Category()
            newItem.name = textField.text!

            self.Save(category: newItem)
                
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
            
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
