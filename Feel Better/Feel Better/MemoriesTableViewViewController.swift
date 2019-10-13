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

    var documentIDs: [String] = []
	// var memoriesTableViewArray: [Memory] = []
	
	var cameBackFromUnwind: Bool = false
	
    
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        Firebase.database.fetchAll { [weak self] (result) in
            switch result {
            case .success(let ids):
                self?.documentIDs = ids
            case .failure(let error):
                print(error)
            }
        }
	}
	
	override func viewWillAppear(_ animated: Bool) {
		// Deselects the selected cell when returning
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if cameBackFromUnwind {
			self.alert = UIAlertController(title: nil, message: "Memory Saved", preferredStyle: .alert)
			self.present(self.alert, animated: true, completion: nil)
			hapticNotification.notificationOccurred(.success)
			cameBackFromUnwind = false
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
				self.dismiss(animated: true, completion: nil)}
		}
	}
	
	//MARK: Tableview Data Sources
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return documentIDs.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cellIdentifier = "MemoryTableViewCell"
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            as? MemoryTableViewCell else {
			fatalError("The cell is not an instance of the ViewCell class")
		}
        Firebase.database.getMemory(withID: documentIDs[indexPath.row]) { (result) in
            switch result {
            case .success(let memory):
                cell.setMemory(memory)
            case .failure(let error):
                print(error)
            }
        }
		return cell
	}
	
	//MARK: Deleting Memories
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
            Firebase.database.deleteMemory(withID: documentIDs.remove(at: indexPath.row))
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	//MARK: Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
		switch(segue.identifier ?? "") {
		case "AddNewMemory":
			return
		case "ShowMemoryDetail":
			guard let destinationViewController = segue.destination as?
				MemoryDetailsViewController else {
					fatalError("Unexpeceted Destination: \(segue.destination)")
			}
			guard let selectedeventcell = sender as? MemoryTableViewCell else {
				fatalError("Unexpected sender: \(String(describing: sender))")
			}
			guard let indexPath = tableView.indexPath(for: selectedeventcell) else {fatalError("The Selected Cell is not being displayed by the table")
			}
			// let selectedMemory = memoriesTableViewArray[indexPath.row]
            
			destinationViewController.memoryFromSegue = selectedMemory
			
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
	
	@IBAction func unwindCancel(sender: UIStoryboardSegue) { }
	
	//MARK: saving memory
	@IBAction func unwindToMemories(sender: UIStoryboardSegue) {
		if let sourceViewController = sender.source as? NewMemoryViewController,
            let memoryToSave = sourceViewController.memoryToSave {
			cameBackFromUnwind = true
			if let selectedIndexPath = tableView.indexPathForSelectedRow {
                TextAnalzyer.keyPhrases(in: memoryToSave.content) { (result) in
                    let tags = (try? result.get()) ?? []
                    Firebase.database.replaceMemory(withID: self.documentIDs[selectedIndexPath.row],
                                                    with: memoryToSave, tags: tags)
                }
				tableView.reloadRows(at: [selectedIndexPath], with: .none)
			} else {
                //Adding a new event instead of editing it.
                let newIndexPath = IndexPath(row: 0, section: 0)
                TextAnalzyer.keyPhrases(in: memoryToSave.content) { (result) in
                    let tags = (try? result.get()) ?? []
                    let id = Firebase.database.saveNewMemory(memoryToSave, tags: tags)
                    self.documentIDs.insert(id, at: 0)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                        }
                    }
                }
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
