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

class NoteViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var isNewImage :Bool = false
    var note: Note?
    weak var delegate: NoteViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.text = self.note?.text
        self.imageView.image = self.note?.image()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IBAction
    @IBAction func done(_ sender: Any) {
        self.note?.text = self.textView.text
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
