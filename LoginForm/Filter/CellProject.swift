//
//  CellProject.swift
//  LoginForm
//
//  Created by Duc on 3/26/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit


class CellProject: UITableViewCell {

    @IBOutlet weak var lblProjectName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
