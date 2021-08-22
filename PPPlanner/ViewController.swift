//
//  ViewController.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import UIKit
import FSCalendar

var selectedDate = Date()
var events = [EventsListItem]()


class ViewController: UIViewController, FSCalendarDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var calendar: FSCalendar!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "totay's tasks"
        getAllItems()
        
        tableView.delegate = self
        tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        
    }
    
    //core data
    func getAllItems(){
        do
        {
            events = try context.fetch(EventsListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch{
            //error
        }
    }
    
    func eventsforDate(date:Date) -> [EventsListItem]
    {
        var daysEvent = [EventsListItem]()
        for event in events
        {
            if(Calendar.current.isDate(event.date!, inSameDayAs:date))
            {
                daysEvent.append(event)
            }
        }
        return daysEvent
    }
    
//    func deleteItem(item: EventsListItem){
//        context.delete(item)
//        do
//        {
//            try context.save()
//        }
//        catch{
//            //error
//        }
//    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected")
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let date_formatted = formatter.string(from: date)
        navigationItem.title = date_formatted
        selectedDate = date
        tableView.reloadData()

    }
    
    

    
    
    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "NEW TASK"
//        vc.update = {
//            DispatchQueue.main.async {
//                self.updateTasks()
//            }
//        }
        tableView.reloadData()
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if eventsforDate(date: date).count > 0{
            return 1
        }
        return 0
    }
}
    
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "新任务"
        vc.event = eventsforDate(date: selectedDate)[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tasks.count
        return eventsforDate(date: selectedDate).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        let event = eventsforDate(date: selectedDate)[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let date_formatted = formatter.string(from: event.date!)
        navigationItem.title = date_formatted
        var name: String!
        name = event.name
        cell.textLabel?.text = "\(name ?? "") \(date_formatted)"
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

