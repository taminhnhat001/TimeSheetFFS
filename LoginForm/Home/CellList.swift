//
//  CellList.swift
//  LoginForm
//
//  Created by Duc on 3/23/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

class CellList: UITableViewCell {

    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var DMY: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var descriptionName: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
