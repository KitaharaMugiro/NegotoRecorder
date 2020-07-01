//
//  NegotoDailyTable.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import EMTNeumorphicView
class NegotoDailyTable  {
    var tableView : UITableView
    
    init(dataSource: UITableViewDataSource, tableDelegate:UITableViewDelegate) {
        let tableView = UITableView()
        tableView.dataSource = dataSource
        tableView.delegate = tableDelegate
        tableView.tableFooterView = UIView()
        tableView.register(EMTNeumorphicTableCell.self, forCellReuseIdentifier: "cell")
        tableView.allowsSelection = false
        self.tableView = tableView
    }
    
    func addMySelfToViewCompletely(view:UIView, under:UIView) {
        view.addSubview(tableView)
        tableView.backgroundColor = view.backgroundColor
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: under.bottomAnchor , constant: 10).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-20).isActive = true
     }
    
    func update() {
        self.tableView.reloadData()
    }
}
