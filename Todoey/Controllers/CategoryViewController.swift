//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thin Myat Noe on 3/3/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryViewController: SwipeTableViewController{
	
	var categoryArray = [Category]()
	
	// for core data
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
		loadItems()
		tableView.rowHeight = 80.0
		tableView.separatorStyle = .none
    }

	override func viewWillAppear(_ animated: Bool) {
		guard let navBar = navigationController?.navigationBar else{
			fatalError("Nav bar do not exist")
		}
		navBar.barTintColor = UIColor(hexString: "1D9BF6")
		navBar.backgroundColor = UIColor(hexString: "1D9BF6")
	}
	
    // MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categoryArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		let category = categoryArray[indexPath.row]
		
		cell.textLabel?.text = category.name
		
		guard let categoryColor = UIColor(hexString: category.color!) else {
			fatalError()
		}
		
		cell.backgroundColor = categoryColor
		cell.textLabel?.textColor =  ContrastColorOf(categoryColor, returnFlat: true)
		
		return cell
	}
	
	// MARK: - Data Manipulation methods
	func saveItems(){
		do{
			try context.save()
		} catch{
			print("Error Saving Context, \(error)")
		}
	}
	
	func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
		do{
			categoryArray = try context.fetch(request)
		} catch{
			print("Error fetching data from context \(error)")
		}
		self.tableView.reloadData()
	}
	
	// MARK: - delete data from swipe
	
	override func updateModel(at indexPath: IndexPath) {
		self.context.delete(self.categoryArray[indexPath.row])
		self.categoryArray.remove(at: indexPath.row)
		self.saveItems()
	}
	
	// MARK: - Add new category
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Cateogry", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
			// what will happen when user click add button

			// Core Data (Save/Create)
			let newCategory = Category(context: self.context)
			newCategory.name = textField.text ?? "New Category"
			newCategory.color = UIColor.randomFlat().hexValue()
			
			self.categoryArray.append(newCategory)
			self.saveItems()
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create New Category"
			textField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Table view delegate
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItem", sender: self)
		
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let destinationVC = segue.destination as! TodoListViewController
		if let indexPath = tableView.indexPathForSelectedRow{
			destinationVC.selectedCategory = categoryArray[indexPath.row]
		}
	}
}



