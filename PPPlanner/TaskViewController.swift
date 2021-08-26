//
//  TaskViewController.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import UIKit
import FSCalendar

class TaskViewController: UIViewController, UITextViewDelegate, FSCalendarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var event:EventsListItem!
    var selectedColorLabel: Int!
    var placeholderLabel : UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let datePicker2 = UIDatePicker()
    let datePicker3 = UIDatePicker()
    private let reuseIdentifier = "calendarCell"
    
    
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var nameField2: UITextField!
    @IBOutlet weak var startTF: UITextField!
    @IBOutlet weak var endTF: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noteField: UITextView!



    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(event.colorLabel == 0){
            imageIcon.tintColor = UIColor.darkGray
        }
        else{
            imageIcon.tintColor = colorLabels[Int(event.colorLabel)]
        }
        
        nameField2.text = event.name
        //start date
        datePicker2.date = event.date!
        startTF.inputView = datePicker2
        startTF.text = formatDate(date: datePicker2.date)

//        let endDate = event.date ?? Date()
        datePicker3.date = event.date ?? Date()
        endTF.inputView = datePicker3
        endTF.text = formatDate(date: datePicker3.date)
        
        
        if event.desc != nil{
            noteField.text = event.desc
        }
        
        //end date
        endTF.inputView = datePicker3
        endTF.text = formatDate(date: datePicker2.date)
        
        noteField.layer.borderColor = UIColor.lightGray.cgColor
        noteField.layer.borderWidth = 0.2
        noteField.layer.cornerRadius = 5
        noteField.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "描述..."
        placeholderLabel.font = UIFont.systemFont(ofSize: 14.0)
        placeholderLabel.sizeToFit()
        noteField.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (noteField.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !noteField.text.isEmpty
        
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
        
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(saveTask))
    }
    
    @objc func saveTask(){
        guard let name = nameField2.text, !name.isEmpty else {
            return
        }
        
        if self.selectedColorLabel == nil{
            self.selectedColorLabel = 0
        }
        
        updateItem(item: self.event!, name: name, startDate: datePicker2.date, endDate: datePicker3.date, colorLabel: self.selectedColorLabel, note:noteField.text)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    func updateItem(item: EventsListItem, name:String, startDate:Date, endDate:Date, colorLabel:Int, note:String){
        item.name = name
        item.date = startDate
        item.endDate = endDate
        item.colorLabel = Int64(colorLabel)
        item.desc = note
        do
        {
            try context.save()
            
        }
        catch{
            //error
        }
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
