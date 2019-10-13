//
//  NewMemoryViewController.swift
//  Feel Better
//
//  Created by Lucas Wang on 2019-10-12.
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import KeyboardLayoutGuide

class NewMemoryViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
	
	@IBOutlet weak var newMemoryTitle: UITextField!
	@IBOutlet weak var newMemoryContent: UITextView!
	@IBOutlet weak var newMemoryImage: UIImageView!
	@IBOutlet weak var newMemoryResultEmoji: UILabel!
	@IBOutlet weak var newMemoryAnalyzerState: UILabel!
	
	// Keyboard Layout Guide UI Elements
	@IBOutlet weak var newMemoryKeyboardLayoutGuideView: UIView!
	@IBOutlet weak var newMemoryOverride80To100: UIButton!
	@IBOutlet weak var newMemoryOverride60To80: UIButton!
	@IBOutlet weak var newMemoryOverride40To60: UIButton!
	@IBOutlet weak var newMemoryOverride20To40: UIButton!
	@IBOutlet weak var newMemoryOverride0To20: UIButton!
	
	@IBOutlet weak var saveMemoryBarButton: UIBarButtonItem!
	
	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	private func updateSaveButtonState() {
		let text = newMemoryContent.text ?? ""
        saveMemoryBarButton.isEnabled = !text.isEmpty
	}
	
	let hapticNotification = UINotificationFeedbackGenerator()
	var alert = UIAlertController()
	
	var memoryToSave: Memory?
	
	//MARK: UIImagePicker
	let UIImagePicker = UIImagePickerController()
	@IBAction func UIImageTapped(_ sender: UITapGestureRecognizer) {
		newMemoryContent.resignFirstResponder()
		UIImagePicker.allowsEditing = false
		UIImagePicker.sourceType = .photoLibrary
		present(UIImagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newMemoryImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
	
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		newMemoryTitle.returnKeyType = .done
		newMemoryTitle.delegate = self
		newMemoryContent.returnKeyType = .done
		newMemoryContent.delegate = self
		UIImagePicker.delegate = self
		updateSaveButtonState()
		
		// Keyboard Layout Guide; pin manual sentiments override view to the keyboard
		newMemoryKeyboardLayoutGuideView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
	}
	
	//MARK: newMemoryTitle actions
	func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveMemoryBarButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Placeholder text behaviour for newMemoryContent, auto Text Analytics API calling is also done through textViewDidBeginEdiitng and textViewDidEndEditing
	func textViewDidBeginEditing(_ textView: UITextView){
		if textView.text == "I feel......"{
			textView.text = ""
		}
	}
		
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if(text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		return true
	}

	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text == ""{
			textView.text = "I feel......"
		}
	}
	
	//MARK: Seugue to tableview with created memory to save
	
	
}
