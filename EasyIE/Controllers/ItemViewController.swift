//
//  ItemViewController.swift
//  EasyIE
//
//  Created by Gökhan KOCA on 7.03.2018.
//  Copyright © 2018 easy-ie. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet var itemViewModel: ItemViewModel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 90.0
		itemViewModel.loadItems()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if itemViewModel.getNumberOfItemsToDisplay() > 0 && itemViewModel.itemViewNeedsUpdate {
			tableView.reloadData()
			let indexPath = IndexPath(item: itemViewModel.getNumberOfItemsToDisplay() - 1, section: 0)
			
			Dispatch.main {
				self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
			}
			itemViewModel.itemViewNeedsUpdate = false
		}
	}
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "AddItemVCSegue" {
			if let addItemNavVC = segue.destination as? UINavigationController {
				if let addItemVC = addItemNavVC.viewControllers.first as? AddItemViewController {
					addItemVC.parentVC = self
				}
			}
		}
	}
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemViewModel.getNumberOfItemsToDisplay()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as! ItemTableViewCell
		let amount = itemViewModel.getItemAmountAtIndex(indexPath.row)
		
		cell.amountLabel.text = amount > 0 ? "+" + String(amount) : String(amount)
		cell.amountLabel.textColor = amount > 0 ? UIColor.AppColor.colorIncome : UIColor.AppColor.colorExpense
		var tags = ""
		for tag in itemViewModel.getItemTagsAtIndex(indexPath.row) {
			tags += tag.value
			tags += " | "
		}
		if tags.count > 3 {
			tags.removeLast(3)
		}
		cell.tagsLabel.text = tags
		cell.dateLabel.text = itemViewModel.getItemDateStringAtIndex(indexPath.row)
		if itemViewModel.getItemIsFixedAtIndex(indexPath.row) {
			switch itemViewModel.getItemCycleTypeAtIndex(indexPath.row) {
			case .undefined:
				fatalError("wrong data, inspect it.")
				break
			case .firstDayOfMonth:
				cell.detailLabel.text = "Fixed : First Day Of Month"
				break
			case .lastDayOfMonth:
				cell.detailLabel.text = "Fixed : Last Day Of Month"
				break
			case .firstWorkDayOfMonth:
				cell.detailLabel.text = "Fixed : First Work Day Of Month"
				break
			case .lastWorkDayOfMonth:
				cell.detailLabel.text = "Fixed : Last Work Day Of Month"
				break
			case .fixedDayOfMonth:
				cell.detailLabel.text = "Fixed : Day of month"
//				 DaysOFMonth(rawValue: itemViewModel.getItemCycleValueAtIndex(indexPath.row)) 
				
				
				break
			case .fixedDayOfWeek:
				cell.detailLabel.text = "Fixed : Day of week"
				break
			}
		} else {
			cell.detailLabel.text = ""
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableViewAutomaticDimension
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
