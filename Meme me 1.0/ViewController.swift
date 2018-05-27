//
//  ViewController.swift
//  ImagePickerPractice
//
//  Created by Anthony Lee on 5/24/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

struct Meme{
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var buttonimage: UIBarButtonItem!
    @IBOutlet weak var buttoncamera: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var meme: Meme!
    let topTextFieldDel = TopTextFieldDelegate()
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -2,]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttoncamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Do any additional setup after loading the view, typically from a nib.
        
        if image.image == nil {
            shareButton.isEnabled = false
            image.backgroundColor = UIColor.black
        }
        
        // MARK: Set Delegates and attributes
        topTextField.delegate = topTextFieldDel
        bottomTextField.delegate = topTextFieldDel
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.center
    }

    // MARK: Actions for camera and album button
    @IBAction func openAlbum(_ sender: Any){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    //Delegate function for imagepickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.contentMode = .scaleAspectFit
            image.image = pickedImage
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Implementation of moving view according to keyboard
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: create a meme image
    func generateMemedImage() -> UIImage {
        //hide toolbar
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show toolbar
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: self.image.image!, memedImage: generateMemedImage())
    }
    
    //Implement share button
    @IBAction func share(_ sender: Any){
        let meme = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {
            activity, completed, items, error -> Void in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

