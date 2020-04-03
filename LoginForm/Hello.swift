//
//  Hello.swift
//  LoginForm
//
//  Created by Duc on 3/19/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

class Hello: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "VC") as? ViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
