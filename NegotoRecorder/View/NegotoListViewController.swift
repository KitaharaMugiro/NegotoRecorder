//
//  NegotoListViewController.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
import EMTNeumorphicView
import AVFoundation

class NegotListViewController: UIViewController {
    private lazy var titleView : HeaderLabel = {
        let view = HeaderLabel()
        return view
    }()
    
    private lazy var statisticView : StatisticView = {
        let view = StatisticView()
        return view
    }()
    
    private lazy var audioKindButtons : AudioKindButtons = {
        let view = AudioKindButtons(color: MyColors.theme)
        view.delegate = self
        return view
    }()
    
    private var intervals : [ActivatedIntervalViewModel] = []

    private lazy var tableView : NegotoDailyTable = {
        let view = NegotoDailyTable(dataSource: self, tableDelegate: self)
        return view
    }()
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleView.getView())
        self.view.addSubview(statisticView.getView())
        self.view.addSubview(audioKindButtons.getView())
        tableView.addMySelfToViewCompletely(view: self.view, under: audioKindButtons.getView())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateTableAndStatistic()
    }
    
    override func viewDidLayoutSubviews() {
        let width = self.view.frame.width
        titleView.setLayoutTopCenter(width: width)
        statisticView.setLayoutUnder(view: titleView.getView())
        audioKindButtons.setLayoutUnder(view: statisticView.getView(), width: width)
    }
    
    fileprivate func onChangeAudioKind(type: AudioKind) {
        self.updateTableAndStatistic(type:type)
    }
    
    fileprivate func updateTableAndStatistic(type: AudioKind = .negoto) {
        //DBからレコードを取得する
        let repository = AudioRecordRepository()
        let negotos = repository.getAllAvailableIntervals(suffix:50)
        let allIntervals = repository.getAllIntervals()
        statisticView.setText(monooto: allIntervals.count, negoto: negotos.count)
        
        if(type == .negoto) {
            self.intervals = negotos
        } else {
            self.intervals = allIntervals.filter {a in
                return a.title == ""
            }
        }
        
        self.tableView.update()
    }
}

extension NegotListViewController: UITableViewDataSource {
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return intervals.count
     }
    
    // Set the spacing between sections
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 20
      }
    
    // Make the background color show through
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let headerView = UIView()
         headerView.backgroundColor = UIColor.clear
         return headerView
     }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // change neumorphicLayer?.cornerType according to its row position
        let data = self.intervals[indexPath.section]

        let type: EMTNeumorphicLayerCornerType = .all
        let cellId = String(format: "cell%d", type.rawValue)
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        cell = EMTNeumorphicTableCell(style: .default, reuseIdentifier: cellId) //毎回セルを作る
        if cell == nil {
            cell = EMTNeumorphicTableCell(style: .default, reuseIdentifier: cellId)
        }
        
        if let cell = cell as? EMTNeumorphicTableCell {
            let audioPlayer = AudioPlayer()
            let _cell = NegotoCell()
            let seconds = Int(data.endTime - data.startTime)
            _cell.data =  NegotoCellData(title: data.title, date: data.createdAt , negotoId: data.id, fileName: data.filename, seconds: seconds)
            _cell.setPlayer(audioPlayer)
            
            cell.addSubview(_cell)
            _cell.anchor(top: cell.topAnchor, left: cell.leftAnchor, bottom: cell.bottomAnchor, right: cell.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
            cell.height(90)
            cell.neumorphicLayer?.cornerType = type
            cell.selectionStyle = .none;
            cell.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
            cell.neumorphicLayer?.cornerRadius = 20
            cell.neumorphicLayer?.elementDepth = 3
        }
        return cell!
  }
}

extension NegotListViewController: UITableViewDelegate {
    
}

extension NegotListViewController: AudioKindButtonsDelegate {
    func onTapped(type: AudioKind) {
        self.onChangeAudioKind(type:type)
    }
    
}
