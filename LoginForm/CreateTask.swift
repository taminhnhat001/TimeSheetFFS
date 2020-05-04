//
//  CreateTask.swift
//  LoginForm
//
//  Created by Duc on 3/31/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

class CreateTask: UIViewController {

    private var datePicker:UIDatePicker?
    private var datePickerStartT:UIDatePicker?
    private var datePickerEndT:UIDatePicker?
    
    @IBOutlet weak var btnProject: UIButton!
    @IBOutlet weak var btnActivity: UIButton!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtStartT: UITextField!
    @IBOutlet weak var txtEndT: UITextField!
    
    var projectID:String = "" //Dùng để truyền tham số Project ID để lấy Activity tương ứng vs Project
    var arrActivityName:[Activity] = [] // Mảng chứa các Activity (gồm name và id)
    var projectSelected:String = "" //Tên project hiện lên để chọn
    var projectIDSelected:String = "" //ProjectID truyền cho param
    var activitySelected:String = "" //Tên activity hiện lên để chọn
    var activityIDSelected:String = "" // ActivityID truyền cho param
    var descSelected:String = "" //Mô tả truyền cho param
    var starTSelected:String = "" //Thời gian bắt đầu truyền cho param
    var endTSelected:String = "" //Thời gian kết thúc truyền cho param
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create Task"
        self.navigationItem.hidesBackButton = true
        
        createDatePicker()
        createDatePickerStartT()
        createDatePickerEndT()
        
        arrProjectNameFilter.removeAll()
        arrActivityName.removeAll()
        getProjectName()
        }
    
    //Tạo DatePicker Chọn ngày
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // barbutton
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDate))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        txtDate.inputAccessoryView = toolbar
        // assign date picker to the text field
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        txtDate.inputView = datePicker
    }
    @objc func donePressedDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        txtDate.text = dateFormatter.string(from: datePicker!.date)
        view.endEditing(true)
    }
    
    //Tạo DatePicker chọn giờ bắt đầu
    func createDatePickerStartT() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // barbutton
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStart))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        txtStartT.inputAccessoryView = toolbar
        // assign date picker to the text field
        datePickerStartT = UIDatePicker()
        datePickerStartT?.datePickerMode = .time
        txtStartT.inputView = datePickerStartT
    }
    @objc func donePressedStart() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "h:mm:a"
        txtStartT.text = dateFormatter.string(from: datePickerStartT!.date)
        view.endEditing(true)
    }
    //Tạo DatePicker chọn giờ kết thúc
    func createDatePickerEndT() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // barbutton
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEnd))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        txtEndT.inputAccessoryView = toolbar
        // assign date picker to the text field
        datePickerEndT = UIDatePicker()
        datePickerEndT?.datePickerMode = .time
        txtEndT.inputView = datePickerEndT
    }
    @objc func donePressedEnd() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "h:mm:a"
        txtEndT.text = dateFormatter.string(from: datePickerEndT!.date)
        view.endEditing(true)
    }
    
    func getProjectName() {
        let urlString = "https://ts.fss.com.vn/core/json.php"
        guard let url = URL(string: urlString) else { return }
        
        autoID += 1
        let parameter = ["jsonrpc":"2.0",
                         "method":"getProjects",
                         "params":[apiKey],
                         "id"    :autoID] as [String:Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        
        let sessionGetProjectName = URLSession.shared
        let task = sessionGetProjectName.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let myJson = json as? [String:Any] {
                        if let myResult = myJson["result"] as? [String:Any] {
                            if let myItems = myResult["items"] as? [[String:Any]] {
                                for myProject in myItems {
                                    let projectDic = Project(dic: myProject)
                                    arrProjectNameFilter.append(projectDic)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.btnProject.setTitle(arrProjectNameFilter[0].name, for: .normal)
                        self.projectIDSelected = arrProjectNameFilter[0].id ?? ""
                        self.projectID = arrProjectNameFilter[0].id ?? ""
                        self.getActivityName(projectID: self.projectID)
                    }
                } catch {
                    print("Loi getProjectName")
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    func getActivityName(projectID: String) {
        let urlString = "https://ts.fss.com.vn/core/json.php"
        guard let url = URL(string: urlString) else { return }
        
        autoID += 1
        let parameter = ["jsonrpc":"2.0",
                         "method":"getTasks",
                         "params":[apiKey, projectID],
                         "id": autoID] as [String:Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        
        let sessionGetActivityName = URLSession.shared
        let task = sessionGetActivityName.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let myJson = json as? [String:Any] {
                        if let myResult = myJson["result"] as? [String:Any] {
                            if let myItems = myResult["items"] as? [[String:Any]] {
                                for myActivity in myItems {
                                    let activityName = Activity(dic: myActivity)
                                    self.arrActivityName.append(activityName)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.btnActivity.setTitle(self.arrActivityName[0].name, for: .normal)
                        self.activityIDSelected = self.arrActivityName[0].id ?? ""
                    }
                } catch {
                    print("Loi activity name")
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func selectProject(_ sender: UIButton) {
        let alertActionSheet = UIAlertController(title: "Project", message: "Chọn Project", preferredStyle: .actionSheet)
        for indexProject in 0...arrProjectNameFilter.count-1 {
            let projectAction = UIAlertAction(title: arrProjectNameFilter[indexProject].name ?? "", style: .default) { (action) in
                self.btnProject.setTitle(arrProjectNameFilter[indexProject].name ?? "", for: .normal)
                self.projectSelected = arrProjectNameFilter[indexProject].name ?? ""
                self.projectIDSelected = arrProjectNameFilter[indexProject].id ?? ""
                //Set projectID
                self.arrActivityName.removeAll()
                self.projectID = arrProjectNameFilter[indexProject].id ?? ""
                self.getActivityName(projectID: self.projectID)
            }
            alertActionSheet.addAction(projectAction)
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { (action) in
            print("Close")
        }
        alertActionSheet.addAction(closeAction)
        self.present(alertActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func selectActivity(_ sender: UIButton) {
        let alertActionSheet = UIAlertController(title: "Activity", message: "Chọn Activity", preferredStyle: .actionSheet)
        for indexActivity in 0...arrActivityName.count-1 {
            let activityAction = UIAlertAction(title: arrActivityName[indexActivity].name, style: .default) { (action) in
                self.btnActivity.setTitle(self.arrActivityName[indexActivity].name, for: .normal)
                self.activitySelected = self.arrActivityName[indexActivity].name ?? ""
                self.activityIDSelected = self.arrActivityName[indexActivity].id ?? ""
            }
            alertActionSheet.addAction(activityAction)
        }
        let closeAction = UIAlertAction(title: "Close", style: .cancel) { (action) in
            print("Close")
        }
        alertActionSheet.addAction(closeAction)
        self.present(alertActionSheet, animated: true, completion: nil)
    }
    
    //Ra màn hình Home get TimeSheet
    @IBAction func toGetTimeSheet(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Home") as? Home
        self.navigationController?.customPushViewFromLeft(controller: vc!)
    }
    
    @IBAction func createTask(_ sender: UIButton) {
        if (txtDate.text == nil || txtStartT.text == "" || txtEndT.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Không thành công", message: "Điền đầy đủ thông tin các trường Ngày, Giờ bắt đầu, Giờ kết thúc", preferredStyle: UIAlertController.Style.alert)
            let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(btnOk)
            present(alert, animated: true, completion: nil)
        return
        }
        changeToStartEndTest()
        descSelected = txtDesc.text ?? ""
        setTimeSheet()
    }
    
    func changeToStartEndTest() {
        let ngay:String = txtDate.text ?? ""
        let start:String = txtStartT.text ?? ""
        let end:String = txtEndT.text ?? ""
        
        //Convert String dd/MM/yyyy -> date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let timeSFormatter = DateFormatter()
        timeSFormatter.dateFormat = "h:mm:a"
        let timeEFormatter = DateFormatter()
        timeEFormatter.dateFormat = "h:mm:a"
        
        let dateCreate = dateFormatter.date(from: ngay)
        let timeS = timeSFormatter.date(from: start)
        let timeE = timeEFormatter.date(from: end)
        
        //Conver date -> yyyy/MM/dd hh:mm
        let dateFormatterString = DateFormatter()
        dateFormatterString.dateFormat = "yyyy-MM-dd"
        let timeFormatterString = DateFormatter()
        timeFormatterString.dateFormat = "HH:mm"

        let stringDateCreate = dateFormatterString.string(from: dateCreate!)
        let stringTimeS = timeFormatterString.string(from: timeS!)
        let stringTimeE = timeFormatterString.string(from: timeE!)
        self.starTSelected = "\(stringDateCreate) \(stringTimeS)"
        self.endTSelected = "\(stringDateCreate) \(stringTimeE)"
    }
    
    func setTimeSheet() {
        let urlString = "https://ts.fss.com.vn/core/json.php"
        guard let url = URL(string: urlString) else { return }
        
        autoID += 1
        let parameter = ["jsonrpc":"2.0",
                         "method":"setTimesheetRecord",
                         "params":[apiKey,
                                   [
                                    "projectId":projectIDSelected,
                                    "taskId":activityIDSelected,
                                    "start":starTSelected,
                                    "end":endTSelected,
                                    "description":descSelected,
                                    "commentType":0,
                                    "statusId":1,
                                    "billable":0,
                                    "rate":0,
                                    "fixedRate":1
                            ], false],
                         "id": autoID] as [String:Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        
        let sessionSetTS = URLSession.shared
        let task = sessionSetTS.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Set TS Thanh Cong")
                } catch {
                    print("Loi setTimeSheet name")
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    //SwipeGesture (chuyển sang màn hình Home danh sách Time Sheet)
    @IBAction func swipeToTSList(_ sender: UISwipeGestureRecognizer) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Home") as? Home
        self.navigationController?.customPushViewFromLeft(controller: vc!)
    }
}

//Custom thêm navigation controller: Khi push màn hình hướng sẽ là từ trái sang phải (mặc định là từ phải sang trái)
extension UINavigationController {
    func customPushViewFromLeft(controller: UIViewController) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        pushViewController(controller, animated: false)
    }
}
