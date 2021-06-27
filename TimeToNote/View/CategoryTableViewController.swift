//
//  CategoryTableViewController.swift
//  TimeToNote
//
//  Created by Thahi on 26/06/2021.
//

import UIKit
import CoreData
class CategoryTableViewController: UITableViewController {

    var catagories = [Catagory]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
loadCategories()
    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return catagories.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell" , for: indexPath)
        cell.textLabel?.text = catagories[indexPath.row].name
        return cell
    }
    
    //TableView DelegateMeth
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TimeToNoteViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = catagories[indexPath.row]
        }
        
    }
//data manipulation method
    func saveCategory(){
        do{
        try context.save()
        }catch{
            print("errors saving category\(error)")
        }
        tableView.reloadData()
    }

    func loadCategories(){
        let request: NSFetchRequest<Catagory> = Catagory.fetchRequest()
        do{
            catagories = try context.fetch(request)
        }catch{
            print("error loading categories\(error)")
            
        }
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Catagory(context: self.context)
            newCategory.name = textField.text!
            self.catagories.append(newCategory)
            
            self.saveCategory()
    }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "add a new category"
        }
        present(alert, animated: true, completion: nil)
}
}
