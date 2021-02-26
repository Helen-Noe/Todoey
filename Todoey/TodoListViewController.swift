//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
	
	let itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
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
		cell.textLabel?.text = itemArray[indexPath.row]
//		print(indexPath.row)
		return cell
	}
	
	// MARK: - TableView Delegate Methods
	
	// Action on selected row
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print(itemArray[indexPath.row])
		
		// working on check mark
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		}
		else{
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}


}

