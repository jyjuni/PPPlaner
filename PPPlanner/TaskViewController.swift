//
//  TaskViewController.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import UIKit

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    
    var event:EventsListItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = event!.name
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }
    
    @objc func deleteTask(){
        return
    }
    
    
    

    

}
