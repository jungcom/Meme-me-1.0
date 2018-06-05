//
//  ViewController.swift
//  ImagePickerPractice
//
//  Created by Anthony Lee on 5/24/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

struct Meme{
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttoncamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Do any additional setup after loading the view, typically from a nib.
        
        if image.image == nil {
            shareButton.isEnabled = false
            image.backgroundColor = UIColor.black
        }
        
        // MARK: Set Delegates
        topTextField.delegate = topTextFieldDel
        bottomTextField.delegate = topTextFieldDel
        
        // Set attributes for textfields
        setAttributeForTextField(topTextField, defaultTextField: "TOP")
        setAttributeForTextField(bottomTextField, defaultTextField: "BOTTOM")
        
    }
    //MARK: Set attributes for TextFields
    func setAttributeForTextField(_ textField: UITextField, defaultTextField: String){
        let memeTextAttributes:[String: Any] = [
            NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
            NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 60)!,
            NSAttributedStringKey.strokeWidth.rawValue: -2,]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultTextField
        textField.textAlignment = .center
    }

    // MARK: Actions for camera and album button
    @IBAction func openAlbum(_ sender: Any){
        presentImagePicker("photoLibrary")
    }
    
    @IBAction func openCamera(_ sender: Any){
        presentImagePicker("camera")
    }
    
    
    func presentImagePicker(_ sourceType: String){
        let picker = UIImagePickerController()
        picker.delegate = self
        switch sourceType {
        case "camera":
            picker.sourceType = .camera
        case "photoLibrary":
            picker.sourceType = .photoLibrary
        default:
            break
        }
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
            view.frame.origin.y = -getKeyboardHeight(notification)
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
    
    //MARK: Create a meme image
    func generateMemedImage() -> UIImage {
        //hide toolbar
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        print("frame size is: \(self.view.frame.size)")
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show toolbar
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        
        return memedImage
    }
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: self.image.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
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

    //Implement Cancel Button
    @IBAction func cancel(_ sender:Any){
        dismiss(animated: true, completion: nil)
    }
}

