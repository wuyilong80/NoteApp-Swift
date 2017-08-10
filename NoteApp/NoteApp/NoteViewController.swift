//
//  NoteViewController.swift
//  NoteApp
//
//  Created by Jayla on 2017/7/25.
//  Copyright © 2017年 wuyilong. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate: class {
    func didFinishUpdateNote(note: Note)
}

class NoteViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate {

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapButton: UIButton!
    
    var isNewImage :Bool = false
    var note: Note?
    weak var delegate: NoteViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textView.layer.borderColor = UIColor.black.cgColor
        self.textView.layer.borderWidth = 1
        self.textView.layer.cornerRadius = 10
        
        self.titleTextView.layer.borderWidth = 0.5
        self.titleTextView.layer.borderColor = UIColor.gray.cgColor
        self.titleTextView.layer.cornerRadius = 5
        
        self.placeTextView.layer.borderWidth = 0.5
        self.placeTextView.layer.borderColor = UIColor.gray.cgColor
        self.placeTextView.layer.cornerRadius = 5
        
        self.titleTextView.text = self.note?.titleText
        self.textView.text = self.note?.text
        self.placeTextView.text = self.note?.placeText
        self.imageView.image = self.note?.image()
        
        textView.delegate = self
        titleTextView.delegate = self
        placeTextView.delegate = self
        
        let mapImage = UIImage(named: "mapicon")
        mapButton.setImage(mapImage, for: UIControlState.normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (textView.text == "\n"){
//            textView.resignFirstResponder()
//        }
//        if (titleTextView.text == "\n") {
//            titleTextView.resignFirstResponder()
//        }
//        if (placeTextView.text == "\n") {
//            placeTextView.resignFirstResponder()
//        }
//    }
    
    //MARK: IBAction
    @IBAction func done(_ sender: Any) {
        self.note?.titleText = self.titleTextView.text
        self.note?.text = self.textView.text
        self.note?.placeText = self.placeTextView.text
//        self.note?.image = self.imageView.image
        if self.isNewImage{
        
            let uuid = NSUUID()
            let homeURL = NSURL(fileURLWithPath: NSHomeDirectory())
            let documentURL = homeURL.appendingPathComponent("Documents")
            let imageName = "\(uuid.uuidString).jpg"
            let fileURL = documentURL?.appendingPathComponent(imageName)
            if let image = self.imageView.image,let imageData = UIImageJPEGRepresentation(image, 1){
                do{
                    try imageData.write(to: fileURL!, options: [.atomicWrite])
                    if let oldImageName = self.note?.imageName{
                        let oldFileURL = documentURL?.appendingPathComponent(oldImageName)
                        try FileManager.default.removeItem(at: oldFileURL!)
                    }
                    note?.imageName = imageName
                }catch{
                    print(error)
                }
            }
        }
        self.delegate?.didFinishUpdateNote(note: self.note!)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func camera(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .savedPhotosAlbum
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func mapButtonPress(_ sender: Any) {
    }
   
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        self.imageView.image = image;
        }
        self.isNewImage = true
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
