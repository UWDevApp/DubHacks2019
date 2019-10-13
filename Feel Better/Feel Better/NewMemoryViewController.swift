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
	@IBOutlet weak var baseView: UIView!
	
	// Keyboard Layout Guide UI Elements
	@IBOutlet weak var newMemorySavePopUpView: UIView!
	@IBOutlet weak var newMemoryOverride80To100: UIButton!
	@IBOutlet weak var newMemoryOverride60To80: UIButton!
	@IBOutlet weak var newMemoryOverride40To60: UIButton!
	@IBOutlet weak var newMemoryOverride20To40: UIButton!
	@IBOutlet weak var newMemoryOverride0To20: UIButton!
	
	@IBOutlet weak var saveMemoryBarButton: UIBarButtonItem!
	@IBAction func bringUpSavePopUpView(_ sender: UIBarButtonItem) {
		newMemorySavePopUpView.setIsHidden(false, animated: true)
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = baseView.bounds
        visualEffectView.tag = 1
        baseView.addSubview(visualEffectView)
        saveMemoryBarButton.isEnabled = false
	}
	
	// to dismiss SavePopUpView on tap outside the view and remove blur
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		if touches.first?.view?.tag == 1{
			newMemorySavePopUpView.setIsHidden(true, animated: true)
			super.touchesEnded(touches , with: event)
		}
		baseView.subviews.filter({$0.tag == 1}).forEach({$0.removeFromSuperview()})
		saveMemoryBarButton.isEnabled = true
	}
	
	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
//	private func updateSaveButtonState() {
//		let text = newMemoryContent.text ?? ""
//        saveMemoryBarButton.isEnabled = !text.isEmpty
//	}
	
	let hapticNotification = UINotificationFeedbackGenerator()
	var alert = UIAlertController()
	
	var memoryToSave: Memory?
	var newMemorySentiment: Int = 0
	
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
		//updateSaveButtonState()
		saveMemoryBarButton.isEnabled = false
		newMemorySavePopUpView.isHidden = true
		
		// rounded corner for pop up view
		newMemorySavePopUpView.layer.cornerRadius = 10;
		newMemorySavePopUpView.layer.masksToBounds = true;
	}
	
	override func viewDidAppear(_ animated: Bool) {
		newMemorySavePopUpView.isHidden = true
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
        //updateSaveButtonState()
        saveMemoryBarButton.isEnabled = true
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
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		super.prepare(for: segue, sender: sender)
//		guard let saveButton = sender as? UIBarButtonItem, saveButton === saveMemoryBarButton else {
//			print("Cancelling Action,  The Save Button was not pressed")
//			return
//		}
		
		let titleToSave = newMemoryTitle.text
		let contentToSave = newMemoryContent.text
		let sentimentToSave = newMemorySentiment
		let dateToSave = Date()
		let defaultImageData = UIImage(named: "Tap to Select Image")?.pngData()
		let currentImageData = newMemoryImage.image?.pngData()
		var imageToSave: UIImage?
		if defaultImageData == currentImageData {
			imageToSave = nil
		} else {
			imageToSave = newMemoryImage.image
		}
		
		memoryToSave = Memory(title: titleToSave ?? "", content: contentToSave ?? "", sentiment: sentimentToSave, saveDate: dateToSave, image: imageToSave)
	}
	
	//MARK: Result / Override PopUp
	
	
	@IBAction func to100Override(_ sender: UIButton) {
		newMemorySentiment = 90
		//performSegue(withIdentifier: "unwindToMemories", sender: nil)
	}
	@IBAction func to80Override(_ sender: UIButton) {
		newMemorySentiment = 70
		//performSegue(withIdentifier: "unwindToMemories", sender: nil)
	}
	@IBAction func to60Override(_ sender: UIButton) {
		newMemorySentiment = 50
		//performSegue(withIdentifier: "unwindToMemories", sender: nil)
	}
	@IBAction func to40Override(_ sender: UIButton) {
		newMemorySentiment = 30
		//performSegue(withIdentifier: "unwindToMemories", sender: nil)
	}
	@IBAction func to20Override(_ sender: UIButton) {
		newMemorySentiment = 10
		//performSegue(withIdentifier: "unwindToMemories", sender: nil)
	}
}

//MARK: extension to UIView to animate isHidden
extension UIView {
    func setIsHidden(_ hidden: Bool, animated: Bool) {
        if animated {
            if self.isHidden && !hidden {
                self.alpha = 0.0
                self.isHidden = false
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = hidden ? 0.0 : 1.0
            }) { (complete) in
                self.isHidden = hidden
            }
        } else {
            self.isHidden = hidden
        }
    }
}