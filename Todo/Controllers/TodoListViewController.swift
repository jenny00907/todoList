//
//  ViewController.swift
//  Todo
//
//  Created by Jenny Woorim Lee on 2021/01/29.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Items]()
    let context = (UIApplication.shared.delegate as!
                    AppDelegate).persistentContainer.viewContext
    
    var selectedCategories : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let items = itemArray[indexPath.row]
        
        cell.textLabel?.text = items.item
        
        cell.accessoryType = items.check == true ? .checkmark : .none //value = condition ? valueiftrue : valueiffalse
        
        
        return cell
    }
    
    //TabelView Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        itemArray[indexPath.row].check = !itemArray[indexPath.row].check
        
//        context.delete(itemArray[indexPath.row])//temporary
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
        tableView.deselectRow(at: indexPath, animated:true)
        
    }
    
    //Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let new = Items(context: self.context)
            new.item = textField.text!
            new.check = false
            self.itemArray.append(new)
            new.parentCategory = self.selectedCategories
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
        
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder =  "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func saveItems(){
        do{
            try context.save()
            
        } catch {
            print("Error Saving the context \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request : NSFetchRequest<Items> = Items.fetchRequest(), predicate : NSPredicate? = nil){ //load(read) data from database
    
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategories!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do  {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data \(error)")
        }
        
        tableView.reloadData()
    }
        
}

//Mark: - SearchBar methods

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Items> = Items.fetchRequest()
        
        let predicate = NSPredicate(format: "item CONTAINS %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDes = NSSortDescriptor(key: "item", ascending: true)
        
        request.sortDescriptors = [sortDes]
        
        loadItems(with: request)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
