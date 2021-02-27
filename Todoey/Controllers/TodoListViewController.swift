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
	
	let defaults = UserDefaults.standard
	

    override func viewDidLoad() {
        super.viewDidLoad()
//		if let items = defaults.array(forKey: "TodoListArray") as? [String]{
//			itemArray = items
//		}
		
		let newItem = Item()
		newItem.title = "Find Mike"
		itemArray.append(newItem)
		
		let newItem2 = Item()
		newItem2.title = "Buy Eggos"
		itemArray.append(newItem2)
		
		let newItem3 = Item()
		newItem3.title = "Destory Demogorgon"
		itemArray.append(newItem3)
		
		print(itemArray)
		
        // Do any additional setup after loading the view.
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
//		print(indexPath.row)
		
		if item.done == true{
			cell.accessoryType = .checkmark
		} else{
			cell.accessoryType = .none
		}
		
		return cell
	}
	
	// MARK: - TableView Delegate Methods
	
	// Action on selected row
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print(itemArray[indexPath.row])
		
		let item = itemArray[indexPath.row]
		
		// working on check mark
		
		item.done = !item.done
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		tableView.reloadData()
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
			
			self.defaults.set(self.itemArray, forKey: "TodoListArray")
			self.tableView.reloadData()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}


}
