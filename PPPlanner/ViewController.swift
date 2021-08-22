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
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var popupView2: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //ADD POPUP
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!


    //DETAIL ADD POPUP
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var nameField2: UITextField!
    @IBOutlet weak var startTF: UITextField!
    @IBOutlet weak var endTF: UITextField!
   
    
    let colorLabels = [UIColor.init(red: CGFloat(217/256), green: CGFloat(93/256), blue: CGFloat(76/256), alpha: CGFloat(1)), UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let reuseIdentifier = "calendarCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // view setups
        self.title = "today's tasks"
        blurView.bounds = self.view.bounds
        popupView.layer.cornerRadius = 5
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.4)
        
        popupView2.layer.cornerRadius = 5
        popupView2.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.8)
        
//        let datePicker2 = UIDatePicker()
//        datePicker2.datePickerMode = .dateAndTime
//        datePicker2.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
//        datePicker2.frame.size = CGSize(width: 0, height: 300)
//        datePicker2.preferredDatePickerStyle = .wheels
//
//        startTF.inputView = datePicker2
//        startTF.text = formatDate(date: Date())
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        calendar.delegate = self
        calendar.dataSource = self
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //update events list
        getAllItems()
    }
    
   
    
    @IBAction func didTapAdd() {
        //prepare
        datePicker.date = selectedDate
        
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView)
//        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
//        vc.title = "NEW TASK"
//        DispatchQueue.main.async {
//                tableView.reloadData()
//                calendar.reloadData()
//        }
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func didTapSaved(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else {
            return
        }
        
        createItem(name: name, id: Int64(events.count), date: datePicker.date)
        
        getAllItems()
        calendar.reloadData()
        tableView.reloadData()
        
        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func didTapBack2(_ sender: Any) {
        animateOut(desiredView: popupView)
        animateOut(desiredView: popupView2)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func didTapSave2(_ sender: Any) {
        guard let name = nameField.text, !name.isEmpty else {
            return
        }
        
        createItem(name: name, id: Int64(events.count), date: datePicker.date)
        
        getAllItems()
        calendar.reloadData()
        tableView.reloadData()
        
        animateOut(desiredView: popupView)
        animateOut(desiredView: popupView2)
        animateOut(desiredView: blurView)
    }
    
    
    
   
    @IBAction func didTapMore(_ sender: Any) {
        animateIn(desiredView: popupView2)
        
        //start date
        let datePicker2 = UIDatePicker()
        datePicker2.datePickerMode = .dateAndTime
        datePicker2.addTarget(self, action: #selector(startDateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker2.frame.size = CGSize(width: 0, height: 300)
        datePicker2.preferredDatePickerStyle = .wheels
        
        startTF.inputView = datePicker2
        startTF.text = formatDate(date: Date())
        
        //end date
        let datePicker3 = UIDatePicker()
        datePicker3.datePickerMode = .dateAndTime
        datePicker3.addTarget(self, action: #selector(endDateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker3.frame.size = CGSize(width: 0, height: 300)
        datePicker3.preferredDatePickerStyle = .wheels
        
        endTF.inputView = datePicker3
        endTF.text = formatDate(date: Date())
        
        
    }
    
    @objc func startDateChange(datePicker: UIDatePicker){
        startTF.text = formatDate(date: datePicker.date)
    }
    
    @objc func endDateChange(datePicker: UIDatePicker){
        endTF.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE YYYY-MM-dd h:mm"
        return formatter.string(from: date)
    }

    
    func animateIn(desiredView: UIView){
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroundView.center
        
        //animate the effect
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
            }
        )
    }
    
    func animateOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
            }
        )
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
    
    func createItem(name:String, id:Int64, date:Date){
        let newItem = EventsListItem(context:context)
        newItem.name = name
        newItem.id = id
        newItem.date = date
        do
        {
            try context.save()
            events.append(newItem)

        }
        catch{
            //error
            print("context save error!")
        }
    }
    
    func updateItem(item: EventsListItem, name:String, date:Date){
        item.name? = name
        item.date? = date
        do
        {
            try context.save()
            
        }
        catch{
            //error
        }
    }
    
    func deleteItem(item: EventsListItem){
        context.delete(item)
        do
        {
            try context.save()
            getAllItems()
        }
        catch{
            //error
        }
    }
    
//    @objc func saveTask() {
//
//
//        guard let name = field.text, !name.isEmpty else {
//            return
//        }
//
//        createItem(name: name, id: Int64(events.count), date: datePicker.date)
//        navigationController?.popViewController(animated: true)
//    }
    
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
    

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected")
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE YYYY-MM-dd"
        let date_formatted = formatter.string(from: date)
        navigationItem.title = date_formatted
        selectedDate = date
        tableView.reloadData()

    }
    
    func colorsForDate(date: Date) -> [UIColor]? {
        //single label color
//        if ...{
//                return [UIColor.yellow]
//            }
         return [UIColor.blue]
        //multiple labels
        
        //no labels
//        return []
    }
}


extension ViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if eventsforDate(date: date).count > 0{
            return colorsForDate(date: date)!.count
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return colorsForDate(date: date)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        <#code#>
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colorLabels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = self.colorLabels[indexPath.row]
        cell.layer.cornerRadius = cell.frame.height/2
        return cell
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            //delete from events
            let eventToDelete = eventsforDate(date: selectedDate)[indexPath.row]
            deleteItem(item: eventToDelete)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
        calendar.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        calendar.reloadData()
    }
}

