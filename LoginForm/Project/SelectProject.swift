//
//  SelectProject.swift
//  LoginForm
//
//  Created by Duc on 3/25/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import UIKit

var arrProjectNameFilter:[Project] = [] //Mang hien thi ten Project
var arrProjectNameFilterSelected:[String] = [] //Mang sau khi da chon dc ten Project de loc

protocol ProjectTableViewDelegate {
    func reloadTable()
}

class SelectProject: UIViewController {

    var projectDelegate: ProjectTableViewDelegate?
    
    @IBOutlet weak var tableProjectName: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Select Project"
        self.navigationItem.setHidesBackButton(true, animated: true)
        tableProjectName.tableFooterView = UIView()
        //Select Row/Checkmark
        tableProjectName.isEditing = true
        tableProjectName.allowsMultipleSelectionDuringEditing = true
        
        tableProjectName.register(UINib.init(nibName: "CellProjectName", bundle: nil), forCellReuseIdentifier: "CellProjectName")
        tableProjectName.dataSource = self
        tableProjectName.delegate = self
        
        getProjectName()
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
                        self.tableProjectName.reloadData()
                    }
                } catch {
                    print("Loi getProjectName")
                    print(error)
                }
            }
            
        }
        task.resume()
    }
    
    
    @IBAction func backToFilter(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func done(_ sender: UIButton) {
        self.projectDelegate?.reloadTable()
        self.navigationController?.popViewController(animated: true)
    }
}

extension SelectProject: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectDeselectCell(tableView: tableView, indexPath: indexPath)
    }
}

extension SelectProject: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProjectNameFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CellProjectName", for: indexPath) as? CellProjectName {
            cell.projectName.text = arrProjectNameFilter[indexPath.row].name
            return cell
        }
        return UITableViewCell()
    }
}

extension SelectProject {
    // Select and DeSelect TableViewCell
    
    func selectDeselectCell(tableView: UITableView, indexPath: IndexPath) {
        arrProjectNameFilterSelected.removeAll()
        if let arr = tableView.indexPathsForSelectedRows{
            for index in arr {
                arrProjectNameFilterSelected.append(arrProjectNameFilter[index.row].name ?? "")
            }
        }
    }
}
