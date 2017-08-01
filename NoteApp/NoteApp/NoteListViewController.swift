//
//  NoteListViewController.swift
//  NoteApp
//
//  Created by Jayla on 2017/7/25.
//  Copyright © 2017年 wuyilong. All rights reserved.
//

import UIKit
import CoreData

class NoteListViewController: UIViewController,UITableViewDataSource,NoteViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var notes :[Note] = []
    required init?(coder aDecoder: NSCoder) {
//        for index in 0 ..< 10{
//            let note = Note()
//            note.text = "Note\(index)"
//            self.notes.append(note)
//        }
        super.init(coder: aDecoder)
//        self.loadFromFile()
        self.loadFromCoreData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //File Archiving
    func loadFromFile() {
        let homeURL = NSURL(fileURLWithPath: NSHomeDirectory())
        let documentURL = homeURL.appendingPathComponent("Documents")
        let fileURL = documentURL?.appendingPathComponent("notes.archive")
        
        if let notes = NSKeyedUnarchiver.unarchiveObject(withFile: (fileURL?.path)!) as? [Note]{
            self.notes = notes
        }else{
            self.notes = []
        }
    }
    func saveToFile() {
        let homeURL = NSURL(fileURLWithPath: NSHomeDirectory())
        let documentURL = homeURL.appendingPathComponent("Documents")
        let fileURL = documentURL?.appendingPathComponent("notes.archive")
        
        NSKeyedArchiver.archiveRootObject(self.notes, toFile: (fileURL?.path)!)
    }
    
    @IBAction func addNote(_ sender: Any) {
        //        let note = Note()
        let moc = CoreDataHelper.shared.managedObjectContext
        var note : Note!
        moc.performAndWait {
            note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: moc) as! Note
        }
        note.text = "New Note"
        do{
            try self.saveToCoreData()
            //self.notes.append(note)
            self.notes.insert(note, at: 0)
            
            let indexPath = NSIndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }catch{
            print("add note error\(error)")
        }
        //        self.saveToFile()
    }
    
    //MARK: CoreData
    func loadFromCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        moc.performAndWait {
            do{
            let result = try moc.fetch(request)
                self.notes = result as! [Note]
            }catch{
                print("error\(error)")
                self.notes = []
            }
        }
    }
    func saveToCoreData() throws {
        let moc = CoreDataHelper.shared.managedObjectContext
        var e : Error?
        moc.performAndWait {
            if moc.hasChanges {
                do{
                try moc.save()
                }catch{
                    print("error saving\(error)")
                    e = error
                }
            }
        }
        if let error = e {
            throw error
        }

    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let note = self.notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.imageView?.image = note.thumbnailImage()
        cell.imageView?.layer.cornerRadius = 20
        cell.imageView?.layer.borderWidth = 0.5
        cell.imageView?.layer.borderColor = UIColor.darkGray.cgColor
        cell.imageView?.clipsToBounds = true
        cell.showsReorderControl = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let note = self.notes[sourceIndexPath.row]
        self.notes.remove(at: sourceIndexPath.row)
        self.notes.insert(note, at: destinationIndexPath.row)
        self.saveToFile()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let note = self.notes[indexPath.row]
            let moc = CoreDataHelper.shared.managedObjectContext
            moc.performAndWait {
                moc.delete(note)
            }
            do{
                try self.saveToCoreData()
                self.notes.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }catch{
                print("delete notr error\(error)")
            }
            //            self.saveToFile()
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteViewController"{
            let noteViewController = segue.destination as! NoteViewController
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let note = self.notes[indexPath.row]
                noteViewController.note = note
                noteViewController.delegate = self
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    func didFinishUpdateNote(note: Note) {
        if let index = self.notes.index(of: note){
            do{
                try self.saveToCoreData()
                let indexPath = NSIndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath as IndexPath], with: .automatic)
            }catch{
                print("updating note error\(error)")
            }
            
//            self.saveToFile()
        }
    }
    

}
