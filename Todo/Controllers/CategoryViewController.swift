//
//  CategoryViewController.swift
//  Todo
//
//  Created by Jenny Woorim Lee on 2021/02/14.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm() //declaring new realm !!
    
    var categories : Results<Category>?
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        loadCategories()
        tableView.separatorStyle = .none

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else{
            fatalError("Navigation Controller does not exist.")
        }
        navBar.backgroundColor = UIColor(hexString: "#163539")
    }
    //MARK: - TableView DataSource Methods
    //return number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    //insert in the certain row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        
        if let category = categories?[indexPath.row] {
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError("Error setting color")}
            cell.backgroundColor = categoryColor
            //print(categoryColor)
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
         
        return cell
        
    }

    override func updateModel(at indexPath: IndexPath){
        if let categoryDeletion = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryDeletion)
                }
            } catch {
                print("Error deleting category,\(error)")
            }
        }
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()

    }
    
    func save(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        
            
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        
        }
        
        present(alert, animated: true, completion: nil)
    }
        
        
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    //when the row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategories = categories?[indexPath.row]
        }
    }
    
   
    
    
    
}
