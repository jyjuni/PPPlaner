//
//  EntryViewController.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var field: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var update: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        datePicker.date = selectedDate

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }
   
    
    @objc func saveTask() {
        
        
        guard let name = field.text, !name.isEmpty else {
            return
        }
        
        //        let newEvent = Event()
        //        newEvent.id = eventsList.count
        //        newEvent.name = name
        //        newEvent.date = datePicker.date
        
//        createItem(name: name, id: Int64(events.count), date: datePicker.date)
        navigationController?.popViewController(animated: true)
    }

}
