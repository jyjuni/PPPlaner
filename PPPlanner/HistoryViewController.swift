//
//  HistoryViewController.swift
//  PPPlanner
//
//  Created by Yijia Jin on 2021/8/29.
//

import UIKit

class HistoryViewController: UIViewController {
    
    
    @IBOutlet var titleTF: UILabel!
    @IBOutlet var tableView: UITableView!

    
    var name: String!
    var eventsNameList: [EventsListItem] = []
    

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var update: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 13.0, *) {
                // Always adopt a light interface style.
                overrideUserInterfaceStyle = .light
            }
        
        self.eventsNameList = eventsforName(name: self.name)
        titleTF.text = "\(self.name ?? "")的历史预约 (\(eventsNameList.count)个)"
//        updateViewConstraints()
//        view.backgroundColor = .clear
//
//        let singleFingerTap = UITapGestureRecognizer.init(target: self, action: #selector(handleTap(sender:)))
//        self.view.addGestureRecognizer(tapGesture)

    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        print("tap")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

//   @objc func tapToDismiss() {
//       print("tapToDimiss")
//       self.dismiss(animated: true, completion: nil)
//   }

    @IBAction func didTapBack(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height
        self.view.frame.origin.y =  UIScreen.main.bounds.height - (tableView.rowHeight * CGFloat(eventsNameList.count)) - 160
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        super.updateViewConstraints()
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
    
    func eventsforName(name: String) -> [EventsListItem]
    {
        
        var daysEvent = [EventsListItem]()
        for event in events
        {
            if(event.name == name)
            {
                daysEvent.append(event)
            }
        }
        return daysEvent.sorted(by: { $0.date!.compare($1.date!) == .orderedDescending })
        
    }

    
//    @IBAction func func goback() {
//    }

}

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
       let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
       let mask = CAShapeLayer()
       mask.path = path.cgPath
       layer.mask = mask
   }
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

//        let vc = storyboard?.instantiateViewController(identifier: "mocktask") as! MockTaskViewController
//        vc.title = "编辑任务"
//        vc.event = eventsNameList[indexPath.row]
//        print("hi", indexPath.row)
//
//        let navigation = UINavigationController(rootViewController: vc)
////        navigation.isNavigationBarHidden = true
////        self.navigationController?.present(navigation, animated: true, completion: nil)
////        dismiss(animated: true, completion: nil)
//
//        navigation.pushViewController(vc, animated: true)
    }
}



extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.name == nil){
            return 0
        }
        return eventsNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "hiscell", for: indexPath) as? HisCell{
            let event = eventsNameList[indexPath.row]
            let formatter_time = DateFormatter()
            formatter_time.dateFormat = "h:mm a"
            let formatter_date = DateFormatter()
            formatter_date.dateFormat = "yyyy年MM月dd日"
            let time_formatted = formatter_time.string(from: event.date!)
            let date_formatted = formatter_date.string(from: event.date!)
            cell.dateTF?.text = "\(date_formatted)"
            cell.timeTF?.text = "\(time_formatted)"
            cell.colorLabel?.tintColor = colorLabels[Int(event.colorLabel)]
            if(event.desc != nil){
                cell.descTF?.text = event.desc
            }
            return cell
        }
        return UITableViewCell()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
}

