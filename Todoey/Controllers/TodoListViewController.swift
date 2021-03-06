//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class TodoListViewController: SwipeTableViewController{
	
	@IBOutlet weak var searchBar: UISearchBar!
	var itemArray = [Item?]()
	
	var selectedCategory: Category?{
		didSet{
			loadItems()
			tableView.rowHeight = 80.0
			tableView.separatorStyle = .none
		}
	}
	
	// for core data
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if let colourHex = selectedCategory?.color{
			
			title = selectedCategory?.name
			
			guard let navBar = navigationController?.navigationBar else{fatalError("Navigation controller does not exist")}
			
			if let navBarColour = UIColor(hexString: colourHex){
				
				navBar.barTintColor = navBarColour
				navBar.backgroundColor = navBarColour
				
				navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
				
				navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor :ContrastColorOf(navBarColour, returnFlat: true)]
				
				searchBar.barTintColor = navBarColour
			}
			
			
			
		}
	}
	
	// MARK: - TableView Datasource Methods
	
	// set the number of rows first
	// populate data into each cell
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = itemArray[indexPath.row]{
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done ? .checkmark : .none
			
			if let colour = UIColor(hexString: selectedCategory!.color!)?.darken(byPercentage:CGFloat(indexPath.row) / CGFloat(itemArray.count) ){
				cell.backgroundColor = colour
				cell.textLabel?.textColor =  ContrastColorOf(colour, returnFlat: true)
			} else{
				cell.textLabel?.text = "No Item Added"
			}
		}
		return cell
	}
	
	// MARK: - TableView Delegate Methods
	
	// Action on selected row
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let item = itemArray[indexPath.row]
		
		
		// working on check mark
		item?.done = !item!.done
		
//		// delete
//		// remove item from db
//		context.delete(item)
//		// remove item from array
//		itemArray.remove(at: indexPath.row)
//		// save item in db
		saveItems()
		self.tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)
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
			newItem.parentCategory = self.selectedCategory
			
			self.itemArray.append(newItem)
			self.saveItems()
			self.tableView.reloadData()

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
	}
	
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate{
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else{
			request.predicate = categoryPredicate
		}
		
		do{
			itemArray = try context.fetch(request)
		} catch{
			print("Error fetching data from context \(error)")
		}
		self.tableView.reloadData()
	}
	
	// MARK: - delete data from swipe

	override func updateModel(at indexPath: IndexPath) {
		self.context.delete(self.itemArray[indexPath.row]!)
		self.itemArray.remove(at: indexPath.row)
		self.saveItems()
	}
	
}



// MARK: - UISearch Bar Delegate

extension TodoListViewController: UISearchBarDelegate{
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		let request: NSFetchRequest<Item> = Item.fetchRequest()

		// how data should be fetch or filter
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadItems(with: request, predicate: predicate)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0{
			loadItems()
			
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
			
		}
	}
}
