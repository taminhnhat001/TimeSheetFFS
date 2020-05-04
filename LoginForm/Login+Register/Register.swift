//
//  Register.swift
//  LoginForm
//
//  Created by Duc on 3/19/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

class Register: UIViewController {

    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRepeatPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func Register(_ sender: UIButton) {
        //Tao thong bao vs moi truong hop nhap sai thong tin
        if (txtUsername.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Thiếu USERNAME", message: "Vui lòng đăng ký lại", preferredStyle: UIAlertController.Style.alert)
            let btnOK:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (bnt) in
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                self.txtRepeatPassword.text = ""
            }
            alert.addAction(btnOK)
            present(alert, animated: true, completion: nil)
        }
        if (txtPassword.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Thiếu PASSWORD", message: "Vui lòng đăng ký lại", preferredStyle: UIAlertController.Style.alert)
            let btnOK:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (btn) in
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                self.txtRepeatPassword.text = ""
            }
            alert.addAction(btnOK)
            present(alert, animated: true, completion: nil)
        }
        if (txtRepeatPassword.text == "") {
            let alert:UIAlertController = UIAlertController(title: "Thiếu REPEATPASSWORD", message: "Vui lòng đăng ký lại", preferredStyle: UIAlertController.Style.alert)
            let btnOK:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (btn) in
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                self.txtRepeatPassword.text = ""
            }
            alert.addAction(btnOK)
            present(alert, animated: true, completion: nil)
        }
        if (txtPassword.text != txtRepeatPassword.text) {
            let alert:UIAlertController = UIAlertController(title: "Thông tin không trùng lặp", message: "Mật khẩu không khớp, vui lòng đăng ký lại", preferredStyle: UIAlertController.Style.alert)
            let btnOK:UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) { (btn) in
                self.txtUsername.text = ""
                self.txtPassword.text = ""
                self.txtRepeatPassword.text = ""
            }
            alert.addAction(btnOK)
            present(alert, animated: true, completion: nil)
        }
    }
}
