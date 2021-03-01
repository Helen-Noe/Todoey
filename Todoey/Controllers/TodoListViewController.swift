//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	
	// for core data
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
//		loadItems()
    }
	
	// MARK: - TableView Datasource Methods
	
	// set the number of rows first
	// populate data into each cell
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell",for: indexPath)
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		cell.accessoryType = item.done ? .checkmark : .none
		
		return cell
	}
	
	// MARK: - TableView Delegate Methods
	
	// Action on selected row
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let item = itemArray[indexPath.row]
		
		// working on check mark
		item.done = !item.done
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		saveItems()
	}
	
	// MARK: - Add new items
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New TodoeyItem", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			// what will happen when user click add button

			// Core Data (Save/Create)
			let newItem = Item(context: self.context)
			newItem.title = textField.text ?? "New Item"
			newItem.done = false
			
			self.itemArray.append(newItem)
			self.saveItems()

		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Model Manipulation Method
	func saveItems(){

		do{
			try context.save()
		} catch{
			print("Error Saving Context, \(error)")
		}

		self.tableView.reloadData()
	}
	
	func loadItems(){
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		do{
			itemArray = try context.fetch(request)
		} catch{
			print("Error fetching data from context \(error)")
		}
		
	}

}
