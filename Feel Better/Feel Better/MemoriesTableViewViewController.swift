//
//  SecondViewController.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
//import LocalAuthentication

class MemoriesTableViewController: UITableViewController {
    
	@IBOutlet var memoriesTableView: UITableView!
	@IBOutlet weak var addMemoryButton: UIBarButtonItem!
	
	let hapticNotification = UINotificationFeedbackGenerator()
	var alert = UIAlertController()
	let dateFormatter = DateFormatter()
	
	var memoriesTableViewArray: [Memory] = []
	
	//MARK: alert controller template
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding editing button to the top left
		navigationItem.leftBarButtonItem = editButtonItem
		
		// Configure dateFormatter
		dateFormatter.locale = Locale(identifier: "en_US")
		dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd HH:mm:ss")
		
		// Add blur effect to tableview before ID is used to unlock
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
	   visualEffectView.frame = memoriesTableView.bounds
	   visualEffectView.tag = 1
	   memoriesTableView.addSubview(visualEffectView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
		// Deselects the selected cell when returning
        if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: true)}
	}
    
    //MARK: Local Authentication
//	func authentication(){
//		let context = LAContext()
//		var error: NSError?
//
//		// check if ID is available
//		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//			let reason = "Authenticate to Access Memories"
//			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in
//				if success {
//					// Move to the main thread because a state update triggers UI changes.
//					self.showAlertController("Welcome!")
//				} else {
//					let reason = "Authenticate to Access Memories using password"
//						context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
//
//						if success {
//						// Move to the main thread because a state update triggers UI changes.
//							self.showAlertController("Welcome!")
//						} else {
//							self.showAlertController("Authentication Failed")
//						}
//					}
//				}
//			}
//		} else {
//			let reason = "Authenticate to Access Memories using password"
//			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
//
//				if success {
//					self.showAlertController("Welcome!")
//				} else {
//					self.showAlertController("Authentication Failed")
//				}
//			}
//		}
//	}
	
	//MARK: Tableview Data Sources
	override func numberOfSections(in tableView: UITableView) -> Int {
		   // #warning Incomplete implementation, return the number of sections
		   return 1
	}
	   
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	   // #warning Incomplete implementation, return the number of rows
	   return memoriesTableViewArray.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cellIdentifier = "MemoryTableViewCell"
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MemoryTableViewCell else {
			fatalError("The cell is not an instance of the ViewCell class")
		}
		let memory = memoriesTableViewArray[indexPath.row]

		//MARK: Configure MemoryTableViewCell
		cell.memoryCellTitle.text = memory.title
		if memory.image != nil {
			cell.memoryCellUIImage.image = memory.image
		} else {
			cell.memoryCellUIImage.isHidden = true
		}
        cell.memoryCellEmoji.text = memory.sentimentEmoji
        cell.memoryCellDateString.text = dateFormatter.string(from: memory.saveDate)
		return cell
	}
		
	//MARK: Deleting Memories
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
			if editingStyle == .delete {
				memoriesTableViewArray.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	//MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		 super.prepare(for: segue, sender: sender)
		 switch(segue.identifier ?? "") {
			 case "AddNewItem":
				 return
			 case "ShowEventDetail":
				 guard let eventDetailsViewController = segue.destination as?
					 MemoryDetailsViewController else {
						 fatalError("Unexpeceted Destination: \(segue.destination)")
				 }
				 guard let selectedeventcell = sender as? MemoryTableViewCell else {
					 fatalError("Unexpected sender: \(String(describing: sender))")
				 }
				 guard let indexPath = tableView.indexPath(for: selectedeventcell) else {fatalError("The Selected Cell is not being displayed by the table")
				 }
				 let selectedMemory = memoriesTableViewArray[indexPath.row]
				 eventDetailsViewController.event = selectedMemory
				 
				 //case "EditEvent":
				// guard let editEventsViewController = segue.destination as?
			   //      NewEventViewController else {
			   //          fatalError("Unexpeceted Destination: \(segue.destination)")
			   //  }
			 default:
				 fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
				 //fatalError("Unexpected Segue Identifier; \(segue.identifier)")
		}
	}
	
	//MARK: saving memory
	@IBAction func unwindToEventList(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? NewEventViewController, let memoryToSave = sourceViewController.memoryFromSegue {
			
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
				memoriesTableViewArray[selectedIndexPath.row] = memoryToSave
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			} else {
				//Adding a new event instead of editing it.
				let newIndexPath = IndexPath(row: 0, section: 0)
				do {
					memoriesTableViewArray.insert(memoryToSave, at: 0)
					//memoriesTableViewArray.append(memory)
					
					//MARK:  Confirmation message and taptic for saving new event
					self.alert = UIAlertController(title: nil, message: "Memory Saved", preferredStyle: .alert)
					self.present(self.alert, animated: true, completion: nil)
					hapticNotification.notificationOccurred(.success)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
					self.dismiss(animated: true, completion: nil)}
				} catch let error as NSError {
					print("Could not save. \(error), \(error.userInfo)")
				}
				tableView.insertRows(at: [newIndexPath], with: .automatic)
			}
		}
	}

// end of class
}

// MARK: extension: function to return the previous viewController
extension UINavigationController {
    func previousViewController() -> UIViewController?{
        let lenght = self.viewControllers.count
        let previousViewController: UIViewController? = lenght >= 2 ? self.viewControllers[lenght-2] : nil
        return previousViewController
    }
}
