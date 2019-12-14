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
	
	// Image Suggestion Pop Up View and Elements
	@IBOutlet weak var imageSuggestionView: UIView!
    @IBOutlet var imageSuggestionViews: [UIImageView]!
    
	@IBOutlet weak var saveMemoryBarButton: UIBarButtonItem!
	@IBAction func bringUpSavePopUpView(_ sender: UIBarButtonItem) {
        let buttons = [
            newMemoryOverride0To20,
            newMemoryOverride20To40,
            newMemoryOverride40To60,
            newMemoryOverride60To80,
            newMemoryOverride80To100
        ]
        
		// Azure sentiment API and returning sentiments and displaying accordingly
        //TextAnalzyer.analyzeSentiment(of: self.newMemoryContent.text) { (result) in
            //self.newMemorySentiment = try! result.get().score
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    buttons.forEach { $0?.titleLabel?.font = .systemFont(ofSize: 40) }
                    
                    switch self.newMemorySentiment {
                    case 0..<20:
                        self.newMemoryOverride0To20.titleLabel?.font = .systemFont(ofSize: 65)
                    case 20..<40:
                        self.newMemoryOverride20To40.titleLabel?.font = .systemFont(ofSize: 65)
                    case 40..<60:
                        self.newMemoryOverride40To60.titleLabel?.font = .systemFont(ofSize: 65)
                    case 60..<80:
                        self.newMemoryOverride60To80.titleLabel?.font = .systemFont(ofSize: 65)
                    case 80..<100:
                        self.newMemoryOverride80To100.titleLabel?.font = .systemFont(ofSize: 65)
                    default: ()
                    }
                }
            }
        //}
		
		newMemorySavePopUpView.setIsHidden(false, animated: true)
		let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = baseView.bounds
        visualEffectView.tag = 1
        baseView.addSubview(visualEffectView)
        saveMemoryBarButton.isEnabled = false
	}
	
	// to dismiss SavePopUpView on tap outside the view and remove blur
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if touches.first?.view?.tag == 1 {
			newMemorySavePopUpView.setIsHidden(true, animated: true)
			super.touchesEnded(touches , with: event)
		}
		baseView.subviews.filter({$0.tag == 1}).forEach({$0.removeFromSuperview()})
		saveMemoryBarButton.isEnabled = true
	}
	
	@IBAction func cancel(_ sender: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}
	
	let hapticNotification = UINotificationFeedbackGenerator()
	var alert = UIAlertController()
	
    var memoryToSave: LocalMemory?
	var newMemorySentiment: Int = 1 // change to -5 with functional API
	
	// MARK: UIImagePicker
	let UIImagePicker = UIImagePickerController()
	@IBAction func UIImageTapped(_ sender: UITapGestureRecognizer) {
		newMemoryContent.resignFirstResponder()
		UIImagePicker.allowsEditing = false
		UIImagePicker.sourceType = .photoLibrary
		present(UIImagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
		
		imageSuggestionView.isHidden = true
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
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
    
    //MARK: Placeholder text behaviour for newMemoryContent, auto image suggestion API calling is also done through textViewDidBeginEdiitng and textViewDidEndEditing
	func textViewDidBeginEditing(_ textView: UITextView){
		if textView.text == "I feel......" {
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
		if textView.text == "" {
			textView.text = "I feel......"
		}
		// calls auto image suggestion
//		let currentDate = Date()
//		let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
//		ImageSuggestionProvider.provider.relevantImage(between: yesterday, and: currentDate, for: newMemoryContent.text, then: processImageSuggestions(suggestions:))
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
        if let button = sender as? UIButton,
            let label = button.titleLabel,
            label.font.pointSize != 65 {
            switch button {
            case newMemoryOverride0To20: newMemorySentiment = 10
            case newMemoryOverride20To40: newMemorySentiment = 30
            case newMemoryOverride40To60: newMemorySentiment = 50
            case newMemoryOverride60To80: newMemorySentiment = 70
            case newMemoryOverride80To100: newMemorySentiment = 90
            default: break
            }
        }
		let dateToSave = Date()
		let defaultImageData = UIImage(named: "Tap to Select Image")?.pngData()
		let currentImageData = newMemoryImage.image?.pngData()
		var imageToSave: UIImage?
		if defaultImageData == currentImageData {
			imageToSave = nil
		} else {
			imageToSave = newMemoryImage.image
		}
		
        memoryToSave = LocalMemory(title: titleToSave ?? "", content: contentToSave ?? "", sentiment: newMemorySentiment, saveDate: dateToSave, image: imageToSave)
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
	
	//MARK: applies the array of images returned from releventImages to display on the UI and prompt the user to select one or cancel
	private func processImageSuggestions(suggestions: [ImageSuggestionProvider.ImageSuggestion]) {
		let images: [UIImage] = suggestions.prefix(6).map { $0.0 }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                self.imageSuggestionView.isHidden = images.isEmpty
                
                for i in images.indices {
                    self.imageSuggestionViews[i].image = images[i]
                }
                for i in images.count..<self.imageSuggestionViews.count {
                    self.imageSuggestionViews[i].image = nil
                }
            }
        }
	}
	
	@IBAction func suggestion1Tapped(_ sender: UITapGestureRecognizer) {
		newMemoryImage.image = imageSuggestionViews[0].image
		imageSuggestionView.isHidden = true
	}
	@IBAction func suggestion2Tapped(_ sender: UITapGestureRecognizer) {
		newMemoryImage.image = imageSuggestionViews[1].image
		imageSuggestionView.isHidden = true
	}
	@IBAction func suggestion3Tapped(_ sender: UITapGestureRecognizer) {
		newMemoryImage.image = imageSuggestionViews[2].image
		imageSuggestionView.isHidden = true
	}
	@IBAction func suggestion4Tapped(_ sender: UITapGestureRecognizer) {
		newMemoryImage.image = imageSuggestionViews[3].image
		imageSuggestionView.isHidden = true
	}
	@IBAction func suggestion5Tapped(_ sender: UITapGestureRecognizer) {
		newMemoryImage.image = imageSuggestionViews[4].image
		imageSuggestionView.isHidden = true
	}
	@IBAction func suggestion6Tapped(_ sender: UITapGestureRecognizer) {
		newMemoryImage.image = imageSuggestionViews[5].image
		imageSuggestionView.isHidden = true
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
