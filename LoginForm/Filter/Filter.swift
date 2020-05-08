//
//  Filter.swift
//  LoginForm
//
//  Created by Duc on 3/25/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

protocol TableViewDelegate {
    func reloadTableView()
}

var arrListFilterDate:[List] = [] //Mảng lọc theo NGÀY
var arrListFilterTrangThaiDaDuyet:[List] = [] //Mảng lọc theo trạng thái ĐẪ DUYỆT (REVIEWED)
var arrListFilterTrangThaiChuaDuyet:[List] = [] //Mảng lọc theo trạng thái CHƯA DUYỆT (OPEN)
var arrListFilterTrangThaiDong:[List] = [] //Mảng lọc theo trạng thái ĐÓNG (CLOSED)
var arrListFilterDaDuyetChuaDuyet:[List] = [] // Mảng lọc theo ĐÃ DUYỆT + CHƯA DUYỆT
var arrListFilterDaDuyetDong:[List] = [] // Mảng lọc theo ĐÃ DUYỆT + ĐÓNG
var arrListFilterChuaDuyetDong:[List] = [] // Mảng lọc theo CHƯA DUYỆT + ĐÓNG
var arrListFilterDaDuyetChuaDuyetDuAn:[List] = [] // Mảng lọc theo ĐÃ DUYỆT + CHƯA DUYỆT + DỰ ÁN
var arrListFilterDaDuyetDongDuAn:[List] = [] // Mảng lọc theo ĐÃ DUYỆT + ĐÓNG + DỰ ÁN
var arrListFilterChuaDuyetDongDuAn:[List] = [] // Mảng lọc theo CHƯA DUYỆT + ĐÓNG + DỰ ÁN
var arrListFilterTrangThai:[List] = [] //Mảng lọc theo ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG
var arrListFilterTrangThaiDuAn:[List] = [] // Mảng lọc theo ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG + DỰ ÁN
var arrListFilterDuAn:[List] = [] //Mảng lọc theo TÊN DỰ ÁN
var arrListFilterDuAnDaDuyet:[List] = [] //Mảng lọc theo DỰ ÁN + ĐÃ DUYỆT
var arrListFilterDuAnChuaDuyet:[List] = [] //Mảng lọc theo DỰ ÁN + CHƯA DUYỆT
var arrListFilterDuAnDong:[List] = [] // Mảng lọc theo DỰ ÁN + ĐÓNG
var arrListFilterDaDuyetDuAn:[List] = [] // Mảng lọc theo NGÀY + ĐÃ DUYỆT + DỰ ÁN
var arrListFilterChuaDuyetDuAn:[List] = [] // Mảng lọc theo NGÀY + CHƯA DUYỆT + DỰ ÁN
var arrListFilterDongDuAn:[List] = [] // Mảng lọc. theo NGÀY + ĐÓNG + DỰ ÁN

var totalDurationFilter:Int = 0

var isFilterDate:Bool = false
var isFilterTrangThaiDaDuyet:Bool = false
var isFilterTrangThaiChuaDuyet:Bool = false
var isFilterTrangThaiDong:Bool = false
var isFilterDuAn:Bool = false

class Filter: UIViewController {

    var delegate:TableViewDelegate?
    
    private var datePickerTuNgay: UIDatePicker?
    private var datePickerDenNgay: UIDatePicker?
    
    @IBOutlet weak var bt_C_HanhChinh: UIButton!
    @IBOutlet weak var bt_T_HanhChinh: UIButton!
    @IBOutlet weak var bt_C_ThemGio: UIButton!
    @IBOutlet weak var bt_T_ThemGio: UIButton!
    @IBOutlet weak var bt_C_DaDuyet: UIButton!
    @IBOutlet weak var bt_T_DaDuyet: UIButton!
    @IBOutlet weak var bt_C_ChuaDuyet: UIButton!
    @IBOutlet weak var bt_T_ChuaDuyet: UIButton!
    @IBOutlet weak var bt_C_Dong: UIButton!
    @IBOutlet weak var bt_T_Dong: UIButton!
    
    @IBOutlet weak var txtTuNgay: UITextField! 
    @IBOutlet weak var txtDenNgay: UITextField!
    
    @IBOutlet weak var projectTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Tạo datePicker trong phần gõ ngày
        createDatePickerTuNgay()
        createDatePickerDenNgay()
        
        self.navigationItem.title = "Filter"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        bt_C_HanhChinh.isHidden = false
        bt_T_HanhChinh.isHidden = true
        bt_C_ThemGio.isHidden = false
        bt_T_ThemGio.isHidden = true
        bt_C_DaDuyet.isHidden = false
        bt_T_DaDuyet.isHidden = true
        bt_C_ChuaDuyet.isHidden = false
        bt_T_ChuaDuyet.isHidden = true
        bt_C_Dong.isHidden = false
        bt_T_Dong.isHidden = true
        
        projectTableView.tableFooterView = UIView()
        projectTableView.register(UINib(nibName: "CellProject", bundle: nil), forCellReuseIdentifier: "CellProject")
        projectTableView.delegate = self
        projectTableView.dataSource = self
    }
    
    //Tạo DatePicker từ ngày đến ngày
    func createDatePickerTuNgay() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // barbutton
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedTuNgay))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        txtTuNgay.inputAccessoryView = toolbar
        // assign date picker to the text field
        datePickerTuNgay = UIDatePicker()
        datePickerTuNgay?.datePickerMode = .date
        txtTuNgay.inputView = datePickerTuNgay
    }
    @objc func donePressedTuNgay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        txtTuNgay.text = dateFormatter.string(from: datePickerTuNgay!.date)
        view.endEditing(true)
    }
    func createDatePickerDenNgay() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // barbutton
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDenNgay))
        toolbar.setItems([doneBtn], animated: true)
        // assign toolbar
        txtDenNgay.inputAccessoryView = toolbar
        // assign date picker to the text field
        datePickerDenNgay = UIDatePicker()
        datePickerDenNgay?.datePickerMode = .date
        txtDenNgay.inputView = datePickerDenNgay
    }
    @objc func donePressedDenNgay() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "dd/MM/yyyy"
        txtDenNgay.text = dateFormatter.string(from: datePickerDenNgay!.date)
        view.endEditing(true)
    }
    
    func filterList() {
        //KHÔNG LỌC GÌ (1)
        if ((txtTuNgay.text == "" ||
            txtDenNgay.text == "") &&
            bt_T_DaDuyet.isHidden == true &&
            bt_T_ChuaDuyet.isHidden == true &&
            bt_T_Dong.isHidden == true &&
            arrProjectNameFilterSelected.isEmpty == true) {
            return
        }
        
        //Lọc theo mỗi tên của PROJECT: (2)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == true) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterDuAn in arrList {
                for tenDuAn in arrProjectNameFilterSelected {
                    if (listFilterDuAn.projectName == tenDuAn) {
                        arrListFilterDuAn.append(listFilterDuAn)
                        totalDurationFilter += listFilterDuAn.duration ?? 0
                    }
                }
            }
            return
        }
        
        //Lọc theo mỗi trạng thái ĐÃ DUYỆT: (3)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == true) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDaDuyet in arrList {
                if (listFilterTrangThaiDaDuyet.status == "Reviewed") {
                    arrListFilterTrangThaiDaDuyet.append(listFilterTrangThaiDaDuyet)
                    totalDurationFilter += listFilterTrangThaiDaDuyet.duration ?? 0
                }
            }
            return
        }
        
        //Lọc theo mỗi trạng thái CHƯA DUYỆT: (4)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == true) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = false
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiChuaDuyet in arrList {
                if (listFilterTrangThaiChuaDuyet.status == "Open") {
                    arrListFilterTrangThaiChuaDuyet.append(listFilterTrangThaiChuaDuyet)
                    totalDurationFilter += listFilterTrangThaiChuaDuyet.duration ?? 0
                }
            }
            return
        }
        
        //Lọc theo mỗi trạng thái ĐÓNG: (5)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == false && arrProjectNameFilterSelected.isEmpty == true) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDong in arrList {
                if (listFilterTrangThaiDong.status == "Closed") {
                    arrListFilterTrangThaiDong.append(listFilterTrangThaiDong)
                    totalDurationFilter += listFilterTrangThaiDong.duration ?? 0
                }
            }
            return
        }
        
        //Lọc theo ĐÃ DUYỆT + CHƯA DUYỆT: (6)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == true) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = false
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDaDuyetChuaDuyet in arrList {
                if (listFilterTrangThaiDaDuyetChuaDuyet.status == "Reviewed" || listFilterTrangThaiDaDuyetChuaDuyet.status == "Open") {
                    arrListFilterDaDuyetChuaDuyet.append(listFilterTrangThaiDaDuyetChuaDuyet)
                    totalDurationFilter += listFilterTrangThaiDaDuyetChuaDuyet.duration ?? 0
                }
            }
            //Lọc theo ĐÃ DUYỆT + CHƯA DUYỆT + DỰ ÁN (7)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterDaDuyetChuaDuyetDuAn in arrListFilterDaDuyetChuaDuyet {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterDaDuyetChuaDuyetDuAn.projectName == tenDuAn) {
                            arrListFilterDaDuyetChuaDuyetDuAn.append(listFilterDaDuyetChuaDuyetDuAn)
                            totalDurationFilter += listFilterDaDuyetChuaDuyetDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
        //Lọc theo ĐÃ DUYỆT + ĐÓNG: (8)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == false) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDaDuyetDong in arrList {
                if (listFilterTrangThaiDaDuyetDong.status == "Reviewed" || listFilterTrangThaiDaDuyetDong.status == "Closed") {
                    arrListFilterDaDuyetDong.append(listFilterTrangThaiDaDuyetDong)
                    totalDurationFilter += listFilterTrangThaiDaDuyetDong.duration ?? 0
                }
            }
            //Lọc theo ĐÃ DUYỆT + ĐÓNG + DỰ ÁN (9)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterDaDuyetDongDuAn in arrListFilterDaDuyetDong {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterDaDuyetDongDuAn.projectName == tenDuAn) {
                            arrListFilterDaDuyetDongDuAn.append(listFilterDaDuyetDongDuAn)
                            totalDurationFilter += listFilterDaDuyetDongDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
        //Lọc theo CHƯA DUYỆT + ĐÓNG: (10)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == false) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiChuaDuyetDong in arrList {
                if (listFilterTrangThaiChuaDuyetDong.status == "Open" || listFilterTrangThaiChuaDuyetDong.status == "Closed") {
                    arrListFilterChuaDuyetDong.append(listFilterTrangThaiChuaDuyetDong)
                    totalDurationFilter += listFilterTrangThaiChuaDuyetDong.duration ?? 0
                }
            }
            //Lọc theo CHƯA DUYỆT + ĐÓNG + DỰ ÁN (11)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterChuaDuyetDongDuAn in arrListFilterChuaDuyetDong {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterChuaDuyetDongDuAn.projectName == tenDuAn) {
                            arrListFilterChuaDuyetDongDuAn.append(listFilterChuaDuyetDongDuAn)
                            totalDurationFilter += listFilterChuaDuyetDongDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
        //Lọc theo ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG: (12)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == false) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThai in arrList {
                if (listFilterTrangThai.status == "Open" || listFilterTrangThai.status == "Closed" || listFilterTrangThai.status == "Reviewed") {
                    arrListFilterTrangThai.append(listFilterTrangThai)
                    totalDurationFilter += listFilterTrangThai.duration ?? 0
                }
            }
            //Lọc theo ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG + DỰ ÁN (13)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterTrangThaiDuAn in arrListFilterTrangThai {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterTrangThaiDuAn.projectName == tenDuAn) {
                            arrListFilterTrangThaiDuAn.append(listFilterTrangThaiDuAn)
                            totalDurationFilter += listFilterTrangThaiDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        //Lọc theo ĐÃ DUYỆT + DỰ ÁN (14)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterDuAnDaDuyet in arrList {
                for tenDuAnDaDuyet in arrProjectNameFilterSelected {
                    if (listFilterDuAnDaDuyet.projectName == tenDuAnDaDuyet && listFilterDuAnDaDuyet.status == "Reviewed") {
                        arrListFilterDuAnDaDuyet.append(listFilterDuAnDaDuyet)
                        totalDurationFilter += listFilterDuAnDaDuyet.duration ?? 0
                    }
                }
            }
            return
        }
        //Lọc theo CHƯA DUYỆT + DỰ ÁN (15)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = false
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterDuAnChuaDuyet in arrList {
                for tenDuAnChuaDuyet in arrProjectNameFilterSelected {
                    if (listFilterDuAnChuaDuyet.projectName == tenDuAnChuaDuyet && listFilterDuAnChuaDuyet.status == "Open") {
                        arrListFilterDuAnChuaDuyet.append(listFilterDuAnChuaDuyet)
                        totalDurationFilter += listFilterDuAnChuaDuyet.duration ?? 0
                    }
                }
            }
            return
        }
        //Lọc theo ĐÓNG + DỰ ÁN (16)
        if (txtTuNgay.text == "" && txtDenNgay.text == "" && bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == false && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = false
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = true
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterDuAnDong in arrList {
                for tenDuAnDong in arrProjectNameFilterSelected {
                    if (listFilterDuAnDong.projectName == tenDuAnDong && listFilterDuAnDong.status == "Closed") {
                        arrListFilterDuAnDong.append(listFilterDuAnDong)
                        totalDurationFilter += listFilterDuAnDong.duration ?? 0
                    }
                }
            }
            return
        }
        
        let tuNgay:String = txtTuNgay.text ?? ""
        let denNgay:String = txtDenNgay.text ?? ""
        
        //Conver String dd/MM/yyyy -> date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateBatDau = dateFormatter.date(from: tuNgay)
        let dateKetThuc = dateFormatter.date(from: denNgay)
        
        //Conver date -> timeInterval1970(Double)
        let timeBatDau = dateBatDau?.timeIntervalSince1970
        let timeBatDauInt:Int = Int(timeBatDau!)
        let timeKetThuc = dateKetThuc?.timeIntervalSince1970
        let timeKetThucInt:Int = Int(timeKetThuc!)
        
        isFilter = true
        isFilterDate = true
        isFilterTrangThaiDaDuyet = false
        isFilterTrangThaiChuaDuyet = false
        isFilterTrangThaiDong = false
        isFilterDuAn = false
        
        //Lọc theo mỗi Ngày: (17)
        for listFilterDate in arrList {
            if (listFilterDate.dateInt! > timeBatDauInt) && (listFilterDate.dateInt! < timeKetThucInt) {
                arrListFilterDate.append(listFilterDate)
                totalDurationFilter += listFilterDate.duration ?? 0
            }
            if (timeKetThucInt <= timeBatDauInt) {
                let alertController:UIAlertController = UIAlertController(title: "Lỗi tìm ngày", message: "Ngày bắt đầu không thể giống hoặc sau ngày kết thúc. Vui lòng nhập lại", preferredStyle: .alert)
                let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: .default) { (btn) in
                    self.txtTuNgay.text = ""
                    self.txtDenNgay.text = ""
                }
                alertController.addAction(btnOk)
                present(alertController, animated: true, completion: nil)
            }
        }
        
        // Lọc theo NGÀY + DỰ ÁN: (18)
        if (bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterNgayDuAn in arrListFilterDate {
                for tenNgayDuAn in arrProjectNameFilterSelected {
                    if (listFilterNgayDuAn.projectName == tenNgayDuAn) {
                        arrListFilterDuAn.append(listFilterNgayDuAn)
                        totalDurationFilter += listFilterNgayDuAn.duration ?? 0
                    }
                }
            }
            return
        }
        
        // Lọc theo NGÀY + Trạng thái ĐÃ DUYỆT: (19)
        if (bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == true) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDaDuyet in arrListFilterDate {
                if (listFilterTrangThaiDaDuyet.status == "Reviewed") {
                    arrListFilterTrangThaiDaDuyet.append(listFilterTrangThaiDaDuyet)
                    totalDurationFilter += listFilterTrangThaiDaDuyet.duration ?? 0
                }
            }
            return
        }
        
        // Lọc theo NGÀY + Trạng thái CHƯA DUYỆT: (20)
        if (bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == true) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiChuaDuyet in arrListFilterDate {
                if (listFilterTrangThaiChuaDuyet.status == "Open") {
                    arrListFilterTrangThaiChuaDuyet.append(listFilterTrangThaiChuaDuyet)
                    totalDurationFilter += listFilterTrangThaiChuaDuyet.duration ?? 0
                }
            }
            return
        }
        
        //Lọc theo NGÀY + trạng thái ĐÓNG: (21)
        if (bt_T_ChuaDuyet.isHidden == true && bt_T_DaDuyet.isHidden == true && bt_T_Dong.isHidden == false && arrProjectNameFilterSelected.isEmpty == true) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDong in arrListFilterDate {
                if (listFilterTrangThaiDong.status == "Closed") {
                    arrListFilterTrangThaiDong.append(listFilterTrangThaiDong)
                    totalDurationFilter += listFilterTrangThaiDong.duration ?? 0
                }
            }
            return
        }
        
        // Lọc theo NGÀY + ĐÃ DUYỆT + DỰ ÁN: (22)
        if (bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = false
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterDaDuyetDuAn in arrListFilterDate {
                for tenDaDuyetDuAn in arrProjectNameFilterSelected {
                    if (listFilterDaDuyetDuAn.status == "Reviewed" && listFilterDaDuyetDuAn.projectName == tenDaDuyetDuAn) {
                        arrListFilterDaDuyetDuAn.append(listFilterDaDuyetDuAn)
                        totalDurationFilter += listFilterDaDuyetDuAn.duration ?? 0
                    }
                }
            }
            return
        }
        
        // Lọc theo NGÀY + CHƯA DUYỆT + DỰ ÁN: (23)
        if (bt_T_ChuaDuyet.isHidden == false && bt_T_DaDuyet.isHidden == true && bt_T_Dong.isHidden == true && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = false
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterChuaDuyetDuAn in arrListFilterDate {
                for tenChuaDuyetDuAn in arrProjectNameFilterSelected {
                    if (listFilterChuaDuyetDuAn.status == "Open" && listFilterChuaDuyetDuAn.projectName == tenChuaDuyetDuAn) {
                        arrListFilterChuaDuyetDuAn.append(listFilterChuaDuyetDuAn)
                        totalDurationFilter += listFilterChuaDuyetDuAn.duration ?? 0
                    }
                }
            }
            return 
        }
        
        //Lọc theo NGÀY + ĐÓNG + DỰ ÁN: (24)
        if (bt_T_ChuaDuyet.isHidden == true && bt_T_DaDuyet.isHidden == true && bt_T_Dong.isHidden == false && arrProjectNameFilterSelected.isEmpty == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = true
            isFilterDuAn = true
            totalDurationFilter = 0
            for listFilterDongDuAn in arrListFilterDate {
                for tenDongDuAn in arrProjectNameFilterSelected {
                    if (listFilterDongDuAn.status == "Closed" && listFilterDongDuAn.projectName == tenDongDuAn) {
                        arrListFilterDongDuAn.append(listFilterDongDuAn)
                        totalDurationFilter += listFilterDongDuAn.duration ?? 0
                    }
                }
            }
        }
        
        //Lọc theo NGÀY + ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG (25)
        if (bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThai in arrListFilterDate {
                if (listFilterTrangThai.status == "Open" || listFilterTrangThai.status == "Closed" || listFilterTrangThai.status == "Reviewed") {
                    arrListFilterTrangThai.append(listFilterTrangThai)
                    totalDurationFilter += listFilterTrangThai.duration ?? 0
                }
            }
            //Lọc theo NGÀY + ĐÃ DUYỆT + CHƯA DUYỆT + ĐÓNG + DỰ ÁN (26)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterTrangThaiDuAn in arrListFilterTrangThai {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterTrangThaiDuAn.projectName == tenDuAn) {
                            arrListFilterTrangThaiDuAn.append(listFilterTrangThaiDuAn)
                            totalDurationFilter += listFilterTrangThaiDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
        //Lọc theo NGÀY + ĐÃ DUYỆT + CHƯA DUYỆT (27)
        if (bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == true) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = false
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDaDuyetChuaDuyet in arrListFilterDate {
                if (listFilterTrangThaiDaDuyetChuaDuyet.status == "Reviewed" || listFilterTrangThaiDaDuyetChuaDuyet.status == "Open") {
                    arrListFilterDaDuyetChuaDuyet.append(listFilterTrangThaiDaDuyetChuaDuyet)
                    totalDurationFilter += listFilterTrangThaiDaDuyetChuaDuyet.duration ?? 0
                }
            }
            //Lọc theo NGÀY + ĐÃ DUYỆT + CHƯA DUYỆT + DỰ ÁN (28)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterDaDuyetChuaDuyetDuAn in arrListFilterDaDuyetChuaDuyet {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterDaDuyetChuaDuyetDuAn.projectName == tenDuAn) {
                            arrListFilterDaDuyetChuaDuyetDuAn.append(listFilterDaDuyetChuaDuyetDuAn)
                            totalDurationFilter += listFilterDaDuyetChuaDuyetDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
        //Lọc theo NGÀY + ĐÃ DUYỆT + ĐÓNG (29)
        if (bt_T_DaDuyet.isHidden == false && bt_T_ChuaDuyet.isHidden == true && bt_T_Dong.isHidden == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = true
            isFilterTrangThaiChuaDuyet = false
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiDaDuyetDong in arrListFilterDate {
                if (listFilterTrangThaiDaDuyetDong.status == "Reviewed" || listFilterTrangThaiDaDuyetDong.status == "Closed") {
                    arrListFilterDaDuyetDong.append(listFilterTrangThaiDaDuyetDong)
                    totalDurationFilter += listFilterTrangThaiDaDuyetDong.duration ?? 0
                }
            }
            //Lọc theo ĐÃ DUYỆT + ĐÓNG + DỰ ÁN (30)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterDaDuyetDongDuAn in arrListFilterDaDuyetDong {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterDaDuyetDongDuAn.projectName == tenDuAn) {
                            arrListFilterDaDuyetDongDuAn.append(listFilterDaDuyetDongDuAn)
                            totalDurationFilter += listFilterDaDuyetDongDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
        //Lọc theo NGÀY + CHƯA DUYỆT + ĐÓNG: (31)
        if (bt_T_DaDuyet.isHidden == true && bt_T_ChuaDuyet.isHidden == false && bt_T_Dong.isHidden == false) {
            isFilter = true
            isFilterDate = true
            isFilterTrangThaiDaDuyet = false
            isFilterTrangThaiChuaDuyet = true
            isFilterTrangThaiDong = true
            isFilterDuAn = false
            totalDurationFilter = 0
            for listFilterTrangThaiChuaDuyetDong in arrListFilterDate {
                if (listFilterTrangThaiChuaDuyetDong.status == "Open" || listFilterTrangThaiChuaDuyetDong.status == "Closed") {
                    arrListFilterChuaDuyetDong.append(listFilterTrangThaiChuaDuyetDong)
                    totalDurationFilter += listFilterTrangThaiChuaDuyetDong.duration ?? 0
                }
            }
            //Lọc theo NGÀY + CHƯA DUYỆT + ĐÓNG + DỰ ÁN (32)
            if (arrProjectNameFilterSelected.isEmpty == false) {
                isFilterDuAn = true
                totalDurationFilter = 0
                for listFilterChuaDuyetDongDuAn in arrListFilterChuaDuyetDong {
                    for tenDuAn in arrProjectNameFilterSelected {
                        if (listFilterChuaDuyetDongDuAn.projectName == tenDuAn) {
                            arrListFilterChuaDuyetDongDuAn.append(listFilterChuaDuyetDongDuAn)
                            totalDurationFilter += listFilterChuaDuyetDongDuAn.duration ?? 0
                        }
                    }
                }
                return
            }
            return
        }
        
    }
    
    @IBAction func c_HanhChinh(_ sender: UIButton) {
        bt_C_HanhChinh.isHidden = true
        bt_T_HanhChinh.isHidden = false
    }
    
    @IBAction func t_HanhChinh(_ sender: UIButton) {
        bt_C_HanhChinh.isHidden = false
        bt_T_HanhChinh.isHidden = true
    }
    
    @IBAction func c_ThemGio(_ sender: UIButton) {
        bt_C_ThemGio.isHidden = true
        bt_T_ThemGio.isHidden = false
    }
    
    @IBAction func t_ThemGio(_ sender: UIButton) {
        bt_C_ThemGio.isHidden = false
        bt_T_ThemGio.isHidden = true
    }
    
    @IBAction func c_DaDuyet(_ sender: UIButton) {
        bt_C_DaDuyet.isHidden = true
        bt_T_DaDuyet.isHidden = false
    }
    
    @IBAction func t_DaDuyet(_ sender: UIButton) {
        bt_C_DaDuyet.isHidden = false
        bt_T_DaDuyet.isHidden = true
    }
    
    @IBAction func c_ChuaDuyet(_ sender: UIButton) {
        bt_C_ChuaDuyet.isHidden = true
        bt_T_ChuaDuyet.isHidden = false
    }
    
    @IBAction func t_ChuaDuyet(_ sender: UIButton) {
        bt_C_ChuaDuyet.isHidden = false
        bt_T_ChuaDuyet.isHidden = true
    }
    
    @IBAction func c_Dong(_ sender: UIButton) {
        bt_C_Dong.isHidden = true
        bt_T_Dong.isHidden = false
    }
    
    @IBAction func t_Dong(_ sender: UIButton) {
        bt_C_Dong.isHidden = false
        bt_T_Dong.isHidden = true
    }
    
    @IBAction func clickSelectProject(_ sender: UIButton) {
        arrProjectNameFilter.removeAll()
        arrProjectNameFilterSelected.removeAll()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SelectProject") as? SelectProject
        vc?.projectDelegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func deleteAllFilterProject(_ sender: UIButton) {
        arrProjectNameFilterSelected.removeAll()
        projectTableView.reloadData()
    }
    
    @IBAction func backToHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filter(_ sender: UIButton) {
        if (txtTuNgay.text != "" && txtDenNgay.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Thiếu thông tin", message: "Thiếu thông tin 'Đến ngày', vui lòng nhập lại", preferredStyle: UIAlertController.Style.alert)
            let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil)
            alert.addAction(btnOk)
            present(alert, animated: true, completion: nil)
            return
        }
        if (txtTuNgay.text == "" && txtDenNgay.text != "") {
            let alert:UIAlertController = UIAlertController(title: "Thiếu thông tin", message: "Thiếu thông tin 'Từ ngày', vui lòng nhập lại", preferredStyle: UIAlertController.Style.alert)
            let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil)
            alert.addAction(btnOk)
            present(alert, animated: true, completion: nil)
            return
        }
        arrListFilterDate.removeAll()
        arrListFilterTrangThaiDaDuyet.removeAll()
        arrListFilterTrangThaiChuaDuyet.removeAll()
        arrListFilterTrangThaiDong.removeAll()
        arrListFilterDaDuyetChuaDuyet.removeAll()
        arrListFilterDaDuyetDong.removeAll()
        arrListFilterChuaDuyetDong.removeAll()
        arrListFilterTrangThai.removeAll()
        arrListFilterDuAn.removeAll()
        arrListFilterDuAnDaDuyet.removeAll()
        arrListFilterDuAnChuaDuyet.removeAll()
        arrListFilterDuAnDong.removeAll()
        arrListFilterDaDuyetDuAn.removeAll()
        arrListFilterChuaDuyetDuAn.removeAll()
        arrListFilterDongDuAn.removeAll()
        arrListFilterDaDuyetChuaDuyetDuAn.removeAll()
        arrListFilterDaDuyetDongDuAn.removeAll()
        arrListFilterChuaDuyetDongDuAn.removeAll()
        arrListFilterTrangThaiDuAn.removeAll()
        isFilter = false
        
        filterList()
        
        let vc = self.navigationController?.viewControllers[1]
        self.delegate?.reloadTableView()
        self.navigationController?.popToViewController(vc!, animated: true)
    }
}

extension Filter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}

extension Filter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProjectNameFilterSelected.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellProject", for: indexPath) as? CellProject {
            cell.lblProjectName.text = arrProjectNameFilterSelected[indexPath.row]
            cell.btnDelete.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: projectTableView)
        guard let indexPath = projectTableView.indexPathForRow(at: point) else { return }
        arrProjectNameFilterSelected.remove(at: indexPath.row)
        projectTableView.deleteRows(at: [indexPath], with: .left)
    }
}

extension Filter: ProjectTableViewDelegate {
    func reloadTable() {
        projectTableView.reloadData()
    }
}
