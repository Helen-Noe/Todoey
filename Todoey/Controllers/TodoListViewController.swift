//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	var itemArray = [Item]()
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
	
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		print(dataFilePath!)
		
		loadItems()
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
//			self.itemArray.append(textField.text!)

			let newItem = Item()
			newItem.title = textField.text ?? "New Item"
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
		let encoder = PropertyListEncoder()

		do{
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch{
			print("Error in coding item array \(error)")
		}

		tableView.reloadData()
	}
	
	func loadItems(){
		if let data = try? Data(contentsOf: dataFilePath!){
			let decoder = PropertyListDecoder()
			do{
				itemArray = try decoder.decode([Item].self, from: data)
			} catch{
				print("Error decoding item array, \(error)")
			}
			
		}
	}

}
