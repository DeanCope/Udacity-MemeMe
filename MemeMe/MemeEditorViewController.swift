//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Dean Copeland on 3/20/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actionButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        // The stroke width needs to be negative to allow both stroke and fill
        //(otherwise the text will be "transparent")
        NSStrokeWidthAttributeName: -4.0,
        ]
    
    // The values in this struct must be kept in synch with the storyboard
    private struct Storyboard {
        static let cameraButtonTag = 0
        static let albumButtonTag = 1
        static let topTextFieldTag = 0
        static let bottomTextFieldTag = 1
    }
    
    private struct TextDefaults {
        static let top = "TOP"
        static let bottom = "BOTTOM"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetUI()
    }
    
    private func resetUI() {
        setup(textField: topTextField, initialText: TextDefaults.top)
        setup(textField: bottomTextField, initialText: TextDefaults.bottom)
        imageView.image = nil
        setupUI()
    }
    
    private func setup(textField: UITextField, initialText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.delegate = self
        textField.textAlignment = .center
        textField.text = initialText
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        // Only display the camera button if a camera is available on the device (i.e. not the simulator)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    private func setupUI() {
        actionButton.isEnabled = (imageView.image == nil) ? false : true

    }
    
    // MARK: - Actions
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        imagePicker.sourceType = (sender.tag == Storyboard.cameraButtonTag) ? .camera : .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        setupUI()
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func share(_ sender: Any) {
        
        // Generate a memed image
        let memedImage = generateMemedImage()

        // Define an instance of the ActivityViewController and 
        // pass the ActivityViewController memedImage as an activity Item
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {(_, completed, _, _) in
            if (completed) {
                self.save(memedImage)
            }
        }
        
        // The following two lines are required for iPad
        controller.popoverPresentationController?.sourceView = self.view
        controller.popoverPresentationController?.sourceRect = self.view.bounds

        // Present the ActivityViewController
        present(controller, animated: true, completion: nil)
        
    }
    
    private func save(_ memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        // Save it in the AppDelegate so it can be shared with other VCs
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
        dismiss(animated: true)
    }
    
    private func generateMemedImage() -> UIImage {
        
        hideToolBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolBars(false)
        
        return memedImage
    }
    
    private func hideToolBars(_ hidden: Bool) {
        navigationBar.isHidden = hidden
        bottomToolBar.isHidden = hidden
    }
    
    
    // MARK: - ImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true)
        setupUI()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Whe the user starts to edit, clear the default text, if needed
        switch (textField.tag, textField.text!) {
        case (Storyboard.topTextFieldTag, TextDefaults.top):
            textField.text = ""
        case (Storyboard.bottomTextFieldTag, TextDefaults.bottom):
            textField.text = ""
        default: break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Keyboard notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // We only need to move the view frame up for the bottom text
        // field, not the top text field
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0// + getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }


}

