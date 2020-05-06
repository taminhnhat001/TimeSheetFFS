//
//  Home.swift
//  LoginForm
//
//  Created by Duc on 3/19/20.
//  Copyright © 2020 Duc. All rights reserved.
//
// Test Push GitHub
import UIKit
import SwiftyJSON

var isFilter:Bool = false //
var arrList:[List] = [] // Mang luu cac phan tu List

class Home: UIViewController {

    @IBOutlet weak var lblHello: UILabel!
    @IBOutlet weak var lblTotalTask: UILabel!
    @IBOutlet weak var txtTotalDuration: UITextField!
    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var imgFilter: UIImageView!
    
    var h:Int = 0
    var m:Int = 0
    var totalDuration:Int = 0 //Luu tong thoi gian cac task
    
    var totalTask:String = "" // Tong cac task
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Đổi màu img Filter thành màu đỏ
        imgFilter.image = imgFilter.image?.withRenderingMode(.alwaysTemplate)
        imgFilter.tintColor = UIColor.red
        
        lblHello.text = "Hello \(userName)"
        self.navigationItem.title = "TimeSheet"
        self.navigationItem.hidesBackButton = true
        
        myTable.register(UINib.init(nibName: "CellList", bundle: nil), forCellReuseIdentifier: "CellList")
        myTable.dataSource = self
        myTable.delegate = self
        myTable.tableFooterView = UIView()
        
        getList(apiKey: apiKey)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Tổng các task và tổng số giờ các task
        //Nếu không lọc gì cả thì:
        if isFilter == false {
            lblTotalTask.text = totalTask + " task"
            h = secondsToHours(seconds: totalDuration)
            m = secondsToMinutes(seconds: totalDuration)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc mỗi NGÀY thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterDate.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc theo trạng thái ĐÃ DUYỆT (không ngày) thì:
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false ) {
            lblTotalTask.text = "\(arrListFilterTrangThaiDaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc theo trạng thái CHƯA DUYỆT (không ngày) thì:
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterTrangThaiChuaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
            
        //Nếu lọc theo trạng thái ĐÓNG (không ngày)thì:
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterTrangThaiDong.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc theo tên DỰ ÁN (không ngày) thì:
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc NGÀY + ĐÃ DUYỆT thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false ) {
            lblTotalTask.text = "\(arrListFilterTrangThaiDaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc NGÀY + CHƯA DUYỆT thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterTrangThaiChuaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
                
        //Nếu lọc NGÀY + ĐÓNG thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterTrangThaiDong.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc NGÀY + DỰ ÁN  thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
            }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterDaDuyetChuaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc ĐÃ DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterDaDuyetDong.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc CHƯA DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            lblTotalTask.text = "\(arrListFilterChuaDuyetDong.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc ĐÃ DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDuAnDaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc CHƯA DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDuAnChuaDuyet.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDuAnDong.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDaDuyetChuaDuyetDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc ĐÃ DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDaDuyetDongDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc CHƯA DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterChuaDuyetDongDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
            
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == false) {
                   lblTotalTask.text = "\(arrListFilterTrangThai.count) task"
                   h = secondsToHours(seconds: totalDurationFilter)
                   m = secondsToMinutes(seconds: totalDurationFilter)
                   txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterTrangThaiDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc theo NGÀY + ĐÃ DUYỆT + DỰ ÁN:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDaDuyetDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc theo NGÀY + CHƯA DUYỆT + DỰ ÁN:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterChuaDuyetDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
        //Nếu lọc theo NGÀY + ĐÓNG + DỰ ÁN:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            lblTotalTask.text = "\(arrListFilterDongDuAn.count) task"
            h = secondsToHours(seconds: totalDurationFilter)
            m = secondsToMinutes(seconds: totalDurationFilter)
            txtTotalDuration.placeholder = "\(h) : \(m)"
        }
    }
    
    //Ra màn hình lọc
    @IBAction func filter(_ sender: UIButton) {
        arrProjectNameFilterSelected.removeAll()
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Filter") as? Filter
        vc!.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //Ra màn hình Tạo Create Task
    @IBAction func toCreateTask(_ sender: UIButton) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CreateTask") as? CreateTask
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //SwipeGesture (Kéo về trái để chuyển sang CreateTask)
    @IBAction func swipeToCT(_ sender: UISwipeGestureRecognizer) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "CreateTask") as? CreateTask
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //Log Out
    @IBAction func LogOut(_ sender: UIButton) {
        isFilter = false
        arrList.removeAll()
        arrListFilterDate.removeAll()
        arrListFilterTrangThaiDaDuyet.removeAll()
        arrListFilterTrangThaiChuaDuyet.removeAll()
        arrListFilterTrangThaiDong.removeAll()
        arrListFilterDaDuyetChuaDuyet.removeAll()
        arrListFilterDaDuyetDong.removeAll()
        arrListFilterChuaDuyetDong.removeAll()
        arrListFilterTrangThai.removeAll()
        arrListFilterDaDuyetDuAn.removeAll()
        arrListFilterChuaDuyetDuAn.removeAll()
        arrListFilterDongDuAn.removeAll()
        arrListFilterDuAnDaDuyet.removeAll()
        arrListFilterDuAnChuaDuyet.removeAll()
        arrListFilterDuAnDong.removeAll()
        arrListFilterDaDuyetChuaDuyetDuAn.removeAll()
        arrListFilterDaDuyetDongDuAn.removeAll()
        arrListFilterChuaDuyetDongDuAn.removeAll()
        arrListFilterTrangThaiDuAn.removeAll()
        arrProjectNameFilterSelected.removeAll()
        self.navigationController?.popToRootViewController(animated: true)
        
        dismiss(animated: true, completion: nil)
        session.flush {
            print("Session flush done")
        }
    }
    
    func getList(apiKey: String) {
        let urlString = "https://ts.fss.com.vn/core/json.php"
        guard let url = URL(string: urlString) else { return }
        
        autoID += 1
        let parameter = ["jsonrpc":"2.0",
                         "method":"getTimesheet",
                         "params":[apiKey, 0, 0, -1, 0, 30],
                         "id"	:autoID] as [String:Any]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: []) else { return }
        request.httpBody = httpBody
        
        let sessionGetList = URLSession.shared
        let task = sessionGetList.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let myJson = json as? [String:Any] {
                        if let myResult = myJson["result"] as? [String:Any] {
                            if let myItems = myResult["items"] as? [[String:Any]] {
                                for myList in myItems {
                                    let listDic = List(dic: myList)
                                    arrList.append(listDic)
                                    self.totalDuration += listDic.duration ?? 0
                                }
                            }
                            if let myTotalTask = myResult["total"] as? String {
                                self.totalTask = myTotalTask
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.myTable.reloadData()
                    }
                } catch {
                    print("Loi r")
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    func secondsToHours(seconds: Int) -> Int {
        return seconds / 3600
    }
    
    func secondsToMinutes(seconds: Int) -> Int {
        return (seconds % 3600) / 60
    }
}

extension Home:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension Home:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Nếu không lọc gì thì:
        if isFilter == false {
            return arrList.count
        }
        //Nếu lọc mỗi NGÀY thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            return arrListFilterDate.count
        }
        //Nếu lọc theo trạng thái ĐÃ DUYỆT thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            return arrListFilterTrangThaiDaDuyet.count
        }
        //Nếu lọc theo trạng thái CHƯA DUYỆT thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            return arrListFilterTrangThaiChuaDuyet.count
        }
        //Nếu lọc theo trạng thái ĐÓNG thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            return arrListFilterTrangThaiDong.count
        }
        //Nếu lọc mỗi tên DỰ ÁN (không ngày ) thì:
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterDuAn.count
        }
        //Nếu lọc theo NGÀY + ĐÃ DUYỆT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            return arrListFilterTrangThaiDaDuyet.count
        }
        //Nếu lọc theo NGÀY + CHƯA DUYỆT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            return arrListFilterTrangThaiChuaDuyet.count
        }
        //Nếu lọc theo NGÀY + ĐÓNG:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            return arrListFilterTrangThaiDong.count
        }
        //Nếu lọc theo NGÀY + DỰ ÁN:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterDuAn.count
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            return arrListFilterDaDuyetChuaDuyet.count
        }
        //Nếu lọc ĐÃ DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            return arrListFilterDaDuyetDong.count
        }
        //Nếu lọc CHƯA DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            return arrListFilterChuaDuyetDong.count
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterDaDuyetChuaDuyetDuAn.count
        }
        //Nếu lọc ĐÃ DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            return arrListFilterDaDuyetDongDuAn.count
        }
        //Nếu lọc CHƯA DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            return arrListFilterChuaDuyetDongDuAn.count
        }
        //Nếu lọc ĐÃ DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterDuAnDaDuyet.count
        }
        //Nếu lọc CHƯA DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterDuAnChuaDuyet.count
        }
        //Nếu lọc ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            return arrListFilterDuAnDong.count
        }
        //Nếy lọc ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            return arrListFilterTrangThai.count
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            return arrListFilterTrangThaiDuAn.count
        }
        //Nếu lọc NGÀY + ĐÃ DUYỆT + PROJECT thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterDaDuyetDuAn.count
        }
        //Nếu lọc NGÀY + CHƯA DUYỆT + PROJECT thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            return arrListFilterChuaDuyetDuAn.count
        }
        //Nếu lọc NGÀY + ĐÓNG + PROJECT thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            return arrListFilterDongDuAn.count
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Nếu không lọc gì thì:
        if isFilter == false {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrList[indexPath.row].durationTime
                cell.activityName.text = arrList[indexPath.row].activityName
                cell.descriptionName.text = arrList[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrList[indexPath.row].projectName
                cell.DMY.text = arrList[indexPath.row].dateMonthYear
                cell.startTime.text = arrList[indexPath.row].startTime
                cell.endTime.text = arrList[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrList[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc mỗi NGÀY thì:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDate[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDate[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDate[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDate[indexPath.row].projectName
                cell.DMY.text = arrListFilterDate[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDate[indexPath.row].startTime
                cell.endTime.text = arrListFilterDate[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterDate[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc mỗi tên DỰ ÁN thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterDuAn[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterDuAn[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc theo trạng thái ĐÃ DUYỆT thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiDaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiDaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiDaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiDaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiDaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiDaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiDaDuyet[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc theo trạng thái CHƯA DUYỆT thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc theo trạng thái ĐÓNG thì (không ngày):
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiDong[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiDong[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiDong[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiDong[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiDong[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiDong[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiDong[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc NGÀY + DỰ ÁN:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterDuAn[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
            if (arrListFilterDuAn[indexPath.row].status == "Reviewed") {
                cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
            } else {
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
            }
            return cell
            }
        }
        //Nếu lọc NGÀY + ĐÃ DUYỆT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiDaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiDaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiDaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiDaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiDaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiDaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiDaDuyet[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc NGÀY + CHƯA DUYỆT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiChuaDuyet[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
                }
            }
        //Nếu lọc NGÀY + ĐÓNG:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiDong[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiDong[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiDong[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiDong[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiDong[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiDong[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiDong[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
                }
            }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterDaDuyetChuaDuyet[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterDaDuyetChuaDuyet[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc ĐÃ DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDaDuyetDong[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDaDuyetDong[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDaDuyetDong[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDaDuyetDong[indexPath.row].projectName
                cell.DMY.text = arrListFilterDaDuyetDong[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDaDuyetDong[indexPath.row].startTime
                cell.endTime.text = arrListFilterDaDuyetDong[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterDaDuyetDong[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc CHƯA DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterChuaDuyetDong[indexPath.row].durationTime
                cell.activityName.text = arrListFilterChuaDuyetDong[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterChuaDuyetDong[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterChuaDuyetDong[indexPath.row].projectName
                cell.DMY.text = arrListFilterChuaDuyetDong[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterChuaDuyetDong[indexPath.row].startTime
                cell.endTime.text = arrListFilterChuaDuyetDong[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc ĐÃ DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDuAnDaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDuAnDaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDuAnDaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDuAnDaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterDuAnDaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDuAnDaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterDuAnDaDuyet[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc CHƯA DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDuAnChuaDuyet[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDuAnChuaDuyet[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDuAnChuaDuyet[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDuAnChuaDuyet[indexPath.row].projectName
                cell.DMY.text = arrListFilterDuAnChuaDuyet[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDuAnChuaDuyet[indexPath.row].startTime
                cell.endTime.text = arrListFilterDuAnChuaDuyet[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDuAnDong[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDuAnDong[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDuAnDong[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDuAnDong[indexPath.row].projectName
                cell.DMY.text = arrListFilterDuAnDong[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDuAnDong[indexPath.row].startTime
                cell.endTime.text = arrListFilterDuAnDong[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterDaDuyetChuaDuyetDuAn[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc ĐÃ DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDaDuyetDongDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDaDuyetDongDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDaDuyetDongDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDaDuyetDongDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterDaDuyetDongDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDaDuyetDongDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterDaDuyetDongDuAn[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterDaDuyetDongDuAn[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc CHƯA DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterChuaDuyetDongDuAn[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếy lọc ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == false) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThai[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThai[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThai[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThai[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThai[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThai[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThai[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterTrangThai[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG + DỰ ÁN
        else if (isFilter == true && isFilterDate == false && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == true && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterTrangThaiDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterTrangThaiDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterTrangThaiDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterTrangThaiDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterTrangThaiDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterTrangThaiDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterTrangThaiDuAn[indexPath.row].endTime
                //New review thi` view xanh, con` lai view do?
                if (arrListFilterTrangThaiDuAn[indexPath.row].status == "Reviewed") {
                    cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                } else {
                    cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                }
                return cell
            }
        }
        //Nếu lọc NGÀY + ĐÃ DUYỆT + PROJECT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == true && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDaDuyetDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDaDuyetDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDaDuyetDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDaDuyetDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterDaDuyetDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDaDuyetDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterDaDuyetDuAn[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 117/255, green: 209/255, blue: 252/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc NGÀY + CHƯA DUYỆT + PROJECT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == true && isFilterTrangThaiDong == false && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterChuaDuyetDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterChuaDuyetDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterChuaDuyetDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterChuaDuyetDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterChuaDuyetDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterChuaDuyetDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterChuaDuyetDuAn[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        //Nếu lọc NGÀY + ĐÓNG + PROJECT:
        else if (isFilter == true && isFilterDate == true && isFilterTrangThaiDaDuyet == false && isFilterTrangThaiChuaDuyet == false && isFilterTrangThaiDong == true  && isFilterDuAn == true) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CellList", for: indexPath) as? CellList {
                cell.durationTime.text = arrListFilterDongDuAn[indexPath.row].durationTime
                cell.activityName.text = arrListFilterDongDuAn[indexPath.row].activityName
                cell.descriptionName.text = arrListFilterDongDuAn[indexPath.row].descriptionName ?? "null"
                cell.projectName.text = arrListFilterDongDuAn[indexPath.row].projectName
                cell.DMY.text = arrListFilterDongDuAn[indexPath.row].dateMonthYear
                cell.startTime.text = arrListFilterDongDuAn[indexPath.row].startTime
                cell.endTime.text = arrListFilterDongDuAn[indexPath.row].endTime
                cell.viewStatus.backgroundColor = UIColor(red: 220/255, green: 64/255, blue: 53/255, alpha: 1)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension Home: TableViewDelegate {
    func reloadTableView() {
        myTable.reloadData()
    }
}
