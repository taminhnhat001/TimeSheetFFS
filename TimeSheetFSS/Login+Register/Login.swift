//
//  ViewController.swift
//  LoginForm
//
//  Created by Duc on 3/19/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit
import SwiftyJSON

var userName:String = ""
var checkSuccess:Bool = true
var apiKey:String = ""
var session:URLSession = URLSession()
var autoID:Int = 0

class ViewController: UIViewController {
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassWord: UITextField!
    @IBOutlet weak var v_Or: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtUserName.text = ""
        txtPassWord.text = ""
        v_Or.layer.cornerRadius = v_Or.frame.size.width / 2
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        txtPassWord.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
    }

    @IBAction func Login(_ sender: UIButton) {
        userName = txtUserName.text ?? ""
        
        //Alert thong bao ko thanh cong
        if (txtUserName.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Không thành công", message: "Thông tin bạn nhập bị thiếu hoặc không chính xác. Vui lòng đăng nhập lại", preferredStyle: UIAlertController.Style.alert)
            let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (btn) in
                self.txtUserName.text = ""
                self.txtPassWord.text = ""
            }
            alert.addAction(btnOk)
            present(alert, animated: true, completion: nil)
        }
        if (txtPassWord.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Không thành công", message: "Thông tin bạn nhập bị thiếu hoặc không chính xác. Vui lòng đăng nhập lại", preferredStyle: UIAlertController.Style.alert)
            let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (btn) in
                self.txtUserName.text = ""
                self.txtPassWord.text = ""
            }
            alert.addAction(btnOk)
            present(alert, animated: true, completion: nil)
        }
        
        //Neu thanh cong thi`:
        loginUser(username: txtUserName.text ?? "", pass: txtPassWord.text ?? "")
        
    }
    
    @IBAction func Register(_ sender: UIButton) {
        //Chuyen sang man hinh REGISTER
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "Register") as? Register
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func loginUser(username: String, pass: String) {
        //Prepare URL
        let urlString = "https://ts.fss.com.vn/core/json.php"
        guard let url = URL(string: urlString) else { return }
        
        //Prepare URL request
        autoID += 1 //ID tu tang doi voi moi lan request
        let parameterDictionary = ["jsonrpc":"2.0",
                                   "method":"authenticate",
                                   "params":["\(username)","\(pass)"],
                                   "id": autoID] as [String : Any] //Param chuyen vao
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //HTTP Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        //Perform HTTP Request
        session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                //print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let myJson = json as? [String:Any] {
                        if let myResult = myJson["result"] as? [String:Any] {
                            if let mySuccess = myResult["success"] as? Bool {
                                //Kiem tra neu success = 1 thi` dieu kien thanh cong, = 0 thi loi~
                                if mySuccess == false {
                                    checkSuccess = false
                                } else {
                                    checkSuccess = true
                                }
                            }
                            //apiKey dong.
                            if let myItems = myResult["items"] as? [[String:Any]] {
                                for myApi in myItems {
                                    apiKey = myApi["apiKey"] as? String ?? ""
                                }
                            }
                        }
                    }
                    print(json)
                } catch {
                    checkSuccess = false
                    print("here")
                    print(data.toString() ?? "")
                }
                //Main thread sau khi kiem tra neu POST API thanh cong thi cho dang nhap, khong thi thong bao cho nguoi dung
                DispatchQueue.main.async {
                    print("checkSuccess: + \(checkSuccess)")
                    if (checkSuccess) {
                        let sb = UIStoryboard(name: "Main", bundle: nil)
                        let vc = sb.instantiateViewController(withIdentifier: "Home") as? Home
                        self.navigationController?.pushViewController(vc!, animated: true)
                    }
                    else {
                        let alert:UIAlertController = UIAlertController(title: "Không thành công", message: "Thông tin bạn nhập bị thiếu hoặc không chính xác. Vui lòng đăng nhập lại", preferredStyle: UIAlertController.Style.alert)
                        let btnOk:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (btn) in
                            self.txtUserName.text = ""
                            self.txtPassWord.text = ""
                        }
                        alert.addAction(btnOk)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
}

extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}
