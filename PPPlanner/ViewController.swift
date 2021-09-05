//
//  ViewController.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import UIKit
import FSCalendar
import CoreData

var selectedDate = Date()
var events = [EventsListItem]()
let colorLabels = [UIColor.clear
                  ,UIColor(red: 1.00, green: 0.24, blue: 0.18, alpha: 1.00)
                  ,UIColor(red: 1.00, green: 0.58, blue: 0.00, alpha: 1.00)
                  ,UIColor(red: 1.00, green: 0.80, blue: 0.00, alpha: 1.00)
                  ,UIColor(red: 0.69, green: 0.82, blue: 0.32, alpha: 1.00)
                  ,UIColor(red: 0.08, green: 0.78, blue: 0.35, alpha: 1.00)
                  ,UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.00)
                  ,UIColor(red: 0.76, green: 0.46, blue: 0.86, alpha: 1.00)]

class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{

    //MAIN VC
    @IBOutlet var tableView: UITableView!
    @IBOutlet var calendarView: FSCalendar!
    //POPUP WINDOW
    @IBOutlet var blurView: UIVisualEffectView!
    @IBOutlet var popupView: UIView!
    @IBOutlet var popupView2: UIView!
    //ADD POPUP VIEW
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    //DETAIL ADD POPUP VIEW
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var nameField2: UITextField!
    @IBOutlet weak var startTF: UITextField!
    @IBOutlet weak var endTF: UITextField!
    @IBOutlet weak var noteField: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var timeHolderView: UIStackView!
    @IBOutlet var nameHolderView: UIStackView!
    @IBOutlet var lineView: UIView!
    @IBOutlet var lineView2: UIView!





    var selectedColorLabel: Int!
    var placeholderLabel : UILabel!
    var currentDate: Date!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let datePicker2 = UIDatePicker()
    let datePicker3 = UIDatePicker()

    
    private let reuseIdentifier = "calendarCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                overrideUserInterfaceStyle = .light
            }
        
        // view setups
//        self.title = "hello，马大夫"
        navigationController?.isNavigationBarHidden = true
        blurView.bounds = self.view.bounds
        popupView.layer.cornerRadius = 5
        popupView.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.4)
        nameField.layer.cornerRadius = 10
        
        popupView2.layer.cornerRadius = 5
        popupView2.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width*0.9, height: self.view.bounds.height*0.75)
        
//        noteField.layer.borderColor = UIColor.lightGray.cgColor
//        noteField.layer.borderWidth = 0.2
//        noteField.layer.cornerRadius = 5
        noteField.delegate = self
        
        nameField.delegate = self
        nameField2.delegate = self
        startTF.delegate = self
        endTF.delegate = self
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "描述..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 14.0)
        placeholderLabel.sizeToFit()
        noteField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteField.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !noteField.text.isEmpty
        timeHolderView.layer.cornerRadius = 10
        nameHolderView.layer.cornerRadius = 10

        datePicker2.minuteInterval = 15
        datePicker2.datePickerMode = .dateAndTime
        datePicker2.addTarget(self, action: #selector(startDateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker2.frame.size = CGSize(width: 0, height: 300)
        datePicker2.preferredDatePickerStyle = .wheels
            
        datePicker3.minuteInterval = 15
        datePicker3.datePickerMode = .dateAndTime
        datePicker3.addTarget(self, action: #selector(endDateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker3.frame.size = CGSize(width: 0, height: 300)
        datePicker3.preferredDatePickerStyle = .wheels

        lineView.layer.borderWidth = 0.1
        lineView.layer.borderColor = UIColor.gray.cgColor
        lineView2.layer.borderWidth = 0.1
        lineView2.layer.borderColor = UIColor.gray.cgColor
        
//        tableView.register(TableCell.self, forCellReuseIdentifier: "tablecell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        calendarView.delegate = self
        calendarView.dataSource = self
//        calendar.locale = NSLocale.init(localeIdentifier: "zh-CN") as Locale
        calendarView.appearance.headerDateFormat = "yyyy/MM"
        calendarView.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendarView.calendarWeekdayView.weekdayLabels[1].text = "一"
        calendarView.calendarWeekdayView.weekdayLabels[2].text = "二"
        calendarView.calendarWeekdayView.weekdayLabels[3].text = "三"
        calendarView.calendarWeekdayView.weekdayLabels[4].text = "四"
        calendarView.calendarWeekdayView.weekdayLabels[5].text = "五"
        calendarView.calendarWeekdayView.weekdayLabels[6].text = "六"

        
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //update events list
        getAllItems()
    }
    
    //prev-next button
    private var currentPage: Date?

    private lazy var today: Date = {
        return Date()
    }()
    
    @IBAction func monthForthButtonPressed(_ sender: Any) {
        self.moveCurrentPage(moveUp: true)
    }
        
    @IBAction func monthBackButtonPressed(_ sender: Any) {
            
        self.moveCurrentPage(moveUp: false)
    }

    func moveCurrentPage(moveUp: Bool) {
            
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = moveUp ? 1 : -1
        
        currentPage = calendar.date(byAdding: dateComponents, to: currentPage ?? today)
        calendarView.setCurrentPage(self.currentPage!, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
            placeholderLabel.isHidden = !textView.text.isEmpty
        }
    
    @IBAction func didTapAdd() {
        //prepare
        datePicker.date = selectedDate
        
        animateIn(desiredView: blurView)
        animateIn(desiredView: popupView)

    }
    
    @IBAction func didTapFold(_ sender: Any) {
        if calendarView.scope == .month {
//            calendar.scope = .week
            calendarView.setScope(.week, animated: true)

        } else {
            calendarView.setScope(.month, animated: true)
//            calendar.scope = .month
        }
        calendarView.reloadData()
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
        calendarView.reloadData()
        tableView.reloadData()
        clearAll()

        animateOut(desiredView: popupView)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func didTapBack2(_ sender: Any) {
        animateOut(desiredView: popupView)
        animateOut(desiredView: popupView2)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func didTapSave2(_ sender: Any) {
        guard let name = nameField2.text, !name.isEmpty else {
            return
        }
        
        if self.selectedColorLabel == nil{
            self.selectedColorLabel = 0
        }

        createItem(name: name, id: Int64(events.count), startDate: datePicker2.date, endDate: datePicker3.date, colorLabel: self.selectedColorLabel, note:noteField.text)
        
        getAllItems()
        calendarView.reloadData()
        tableView.reloadData()
        clearAll()

        animateOut(desiredView: popupView)
        animateOut(desiredView: popupView2)
        animateOut(desiredView: blurView)
    }
    
    @IBAction func didTapMore(_ sender: Any) {
        
        
        animateIn2(desiredView: popupView2)
        
        guard let name = nameField.text, !name.isEmpty else {
            return
        }
        
//        let date = datePicker.date
        
//        createItem(name: name, id: Int64(events.count), date: datePicker.date)
        
        nameField2.text = name
        startTF.text = formatDate(date: datePicker.date)
        datePicker2.date = datePicker.date
        datePicker3.date = datePicker.date

        //start date
        startTF.inputView = datePicker2
//        startTF.text = formatDate(date: datePicker2.date)
        
        //end date
        endTF.inputView = datePicker3
//        endTF.text = formatDate(date: datePicker2.date)
        
    }
    
    func clearAll(){
        
        nameField.text?.removeAll()
        nameField2.text?.removeAll()
        noteField.text?.removeAll()
        datePicker.date = Date()
        datePicker2.date = Date()
        datePicker3.date = Date()
        collectionView.indexPathsForSelectedItems?
            .forEach { collectionView.deselectItem(at: $0, animated: false) }
    }
    
   
    
    
    func dateForDay(isoDate: String){
        let isoDate = "2016-04-14T10:44:00+0000"

        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:isoDate)!
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
        navigationController?.isNavigationBarHidden = true

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
    
    func animateIn2(desiredView: UIView){
        navigationController?.isNavigationBarHidden = true

        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        
        desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 0.53)
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
        navigationController?.isNavigationBarHidden = true
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

    func createItem(name:String, id:Int64, startDate:Date, endDate:Date, colorLabel:Int, note:String){
        let newItem = EventsListItem(context:context)
        newItem.name = name
        newItem.id = id
        newItem.date = startDate
        newItem.endDate = endDate
        newItem.colorLabel = Int64(colorLabel)
        newItem.desc = note

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
        return daysEvent.sorted(by: { $0.date!.compare($1.date!) == .orderedAscending })
    }
    

   
    
    func colorsForDate(date: Date) -> [UIColor]? {

        var colors = [UIColor]()
        for event in eventsforDate(date: date)
        {
            if(event.colorLabel != 0){
                if(!colors.contains(colorLabels[Int(event.colorLabel)]))
                {
                    colors.append(colorLabels[Int(event.colorLabel)])
                }
            }
        }
        print("\(colors)")
        return colors
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return true;
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        datePicker.isHidden = true
//        datePicker2.isHidden = true
//        datePicker3.isHidden = true
    }
}


extension ViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if eventsforDate(date: date).count > 0{
            return colorsForDate(date: date)!.count
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return colorsForDate(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return colorsForDate(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let colors = colorsForDate(date: date)!
        if(colors.isEmpty){
            return UIColor.systemBlue
        }
        else{
            return colors[0]
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("selected")
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM月dd日"
//        let date_formatted_title = formatter.string(fromtitle: date)
//        navigationItem.title = date_formatted_title
        selectedDate = date
        self.currentDate = date
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        self.selectedColorLabel = indexPath.row+1
        let selectedColor = colorLabels[indexPath.row+1]
        print("\(String(describing: selectedColor))")
        imageIcon.tintColor = selectedColor

    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //unhighlight selected cell
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let collectionViewHeight = (self.collectionView?.frame.height)!
        let itemsHeight        = self.collectionView?.contentSize.height

        let topInset = ( collectionViewHeight - itemsHeight! ) / 4
        
        return UIEdgeInsets(top: topInset, left: topInset, bottom: topInset, right: topInset)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height:30)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
        


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorLabels.count-1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = colorLabels[indexPath.row+1]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "编辑任务"
        vc.event = eventsforDate(date: selectedDate)[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsforDate(date: selectedDate).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath) as? TableCell{
            let event = eventsforDate(date: selectedDate)[indexPath.row]
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let date_formatted = formatter.string(from: event.date!)
    //        cell.textLabel?.text = "\(String(describing: event.name))"
            let name = event.name!
            cell.nameTF?.text = "\(name)"
            cell.timeTF?.text = "\(date_formatted)"
            cell.colorLabel?.tintColor = colorLabels[Int(event.colorLabel)]
            return cell
        }
        return UITableViewCell()
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
        calendarView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        tableView.reloadData()
        calendarView.reloadData()
    }
}

