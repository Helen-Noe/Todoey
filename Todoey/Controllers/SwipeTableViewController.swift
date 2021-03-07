//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Thin Myat Noe on 7/3/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	// table view data source methods
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		<#code#>
	}
	
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }

		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			
			print ("Cell Deleted")
			
//			self.context.delete(self.categoryArray[indexPath.row])
//			self.categoryArray.remove(at: indexPath.row)
//
//			self.saveItems()
			
			
//			print(indexPath.row)
		}

		// customize the action appearance
		deleteAction.image = UIImage(named: "delete-icon")

		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .destructive
//		options.transitionStyle = .border
		return options
	}
}
