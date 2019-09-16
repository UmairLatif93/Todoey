//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Umair Latif on 16/09/2019.
//  Copyright © 2019 Umair Latif. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
     var itemArray = [Category]()
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

         loadData()
    }
    
    //Mark - TableView DataSource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let nItem = itemArray[indexPath.row]
        cell.textLabel?.text = nItem.name
        
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
            
            destinationVC.selectedCategory = itemArray[indexPath.row]
        }
    }
    
    //Mark - Data Manipulation Methods
    
    func SaveItems(){
        
        do{
            
            try context.save()
            
        } catch{
            
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            itemArray = try context.fetch(request)
        } catch{
            
            print("Error Load Data \(error)")
        }
        
        tableView.reloadData()
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //When user press the add item button on alert
            
            if textField.text != ""{
                
            let newItem = Category(context : self.context)
            newItem.name = textField.text!
            self.itemArray.append(newItem)
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")

            self.SaveItems()
                
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
