//
//  HelloVC.swift
//  LoginForm
//
//  Created by Duc on 3/19/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

class HelloVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "VC", sender: self)
    }

}
