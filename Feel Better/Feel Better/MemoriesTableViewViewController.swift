//
//  SecondViewController.swift
//  Feel Better
//
//  Created by Apollo Zhu on 10/12/19.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import LocalAuthentication

class MemoriesTableViewController: UITableViewController {
    
	@IBOutlet var Memories_TableView: UITableView!
	@IBOutlet weak var Add_Memory_Button: UIBarButtonItem!
	
	let haptic_notification = UINotificationFeedbackGenerator()
	var Alert = UIAlertController()
	
	var memories_tableview_array: [Memory] = []
	
	//MARK: Alert controller template
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adding editing button to the top left
		navigationItem.leftBarButtonItem = editButtonItem
		
		// Add blur effect to tableview before ID is used to unlock
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
	   visualEffectView.frame = Memories_TableView.bounds
	   visualEffectView.tag = 1
	   Memories_TableView.addSubview(visualEffectView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
		// Deselects the selected cell when returning
        if let indexPath = tableView.indexPathForSelectedRow {
        tableView.deselectRow(at: indexPath, animated: true)}
        
        // Authentication
        if memories_authenticate == true {
			Memories_TableView.isUserInteractionEnabled = false
			self.Add_Memory_Button.isEnabled = false
			self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = false})
			authentication()
        
		}
	}
	
    override func viewDidAppear(_ animated: Bool) {
		//MARK:  Confirmation message and taptic for saving new event
        if saved_memory_success == true{
        //self.showAlertController("Memory Saved")
        self.Alert = UIAlertController(title: nil, message: "Memory Saved", preferredStyle: .alert)
        self.present(self.Alert, animated: true, completion: nil)
        haptic_notification.notificationOccurred(.success)
        saved_memory_success = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
        self.dismiss(animated: true, completion: nil)}
        }
    }
    
    //MARK: Local Authentication
	func authentication(){
		let context = LAContext()
		var error: NSError?
		
		// check if ID is available
		if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
			let reason = "Authenticate to Access Memories"
			context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason ) { success, error in
				if success {
					// Move to the main thread because a state update triggers UI changes.
					DispatchQueue.main.async { [unowned self] in
						self.Memories_TableView.isUserInteractionEnabled = true
						self.Add_Memory_Button.isEnabled = true
						self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = true})
					}
				} else {
					let reason = "Authenticate to Access Memories using password"
						context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

						if success {
						// Move to the main thread because a state update triggers UI changes.
							DispatchQueue.main.async { [unowned self] in
								self.Memories_TableView.isUserInteractionEnabled = true
								self.Add_Memory_Button.isEnabled = true
								self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = true})
								}
						} else {
							self.showAlertController("Authentication Failed")
						}
					}
				}
			}
		} else {
			let reason = "Authenticate to Access Memories using password"
			context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in

				if success {
				// Move to the main thread because a state update triggers UI changes.
				DispatchQueue.main.async { [unowned self] in
					self.Memories_TableView.isUserInteractionEnabled = true
					self.Add_Memory_Button.isEnabled = true
					self.view.subviews.filter({$0.tag == 1}).forEach({$0.isHidden = true})
					}
				} else {
					self.showAlertController("Authentication Failed")
				}
			}
		}
	}
	
	
	
	
	
}
