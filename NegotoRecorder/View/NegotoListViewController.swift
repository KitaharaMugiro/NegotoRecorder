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
        let usecase = IntervalUsecase()
        let negotos = usecase.getNegotoIntervals()
        let monooto = usecase.getMonootoIntervals()
        statisticView.setText(monooto: monooto.count, negoto: negotos.count)
        
        if(type == .negoto) {
            self.intervals = negotos
        } else {
            self.intervals = monooto
        }
        self.tableView.update()
        
        //音声認識中のAudioのカウントを数える
        let count = AudioRecognizeTaskHandler().getNumberOfAudiosNotRecognizedYet()
        self.audioKindButtons.setWeAreRecognizingAudios(count : count)
        
    }
}

extension NegotListViewController: UITableViewDataSource {
    //Mark: セルの編集ができるようにする。
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let interval = intervals[index]
        let usecase = IntervalUsecase()
        usecase.deleteInteval(id: interval.id)
        intervals.remove(at: index)
        tableView.deleteRows(at: [indexPath], with: .fade)
        if interval.title != "" {
            let title = "wantFilter".localized
            let message = String(format: "deleteTheWord".localized, interval.title)
            AlertView.actionSheet(presenter: self, title: title, message: message) {
                let usecase = IntervalUsecase()
                usecase.addFilteringWord(title : interval.title)
                let negoto = usecase.getNegotoIntervals()
                self.intervals = negoto
                self.tableView.update()
            }
        }
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return intervals.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // change neumorphicLayer?.cornerType according to its row position
        let data = self.intervals[indexPath.row]
        let audioPlayer = AudioPlayer()
        let cell = NegotoCell()
        let seconds = Int(data.endTime - data.startTime)
        cell.data =  NegotoCellData(title: data.title, date: data.createdAt , negotoId: data.id, fileName: data.filename, seconds: seconds)
        cell.setPlayer(audioPlayer)
        cell.setColor(view.backgroundColor ?? MyColors.theme)
        cell.height(110)
        cell.selectionStyle = .none;
        
        return cell
  }
}

extension NegotListViewController: UITableViewDelegate {
    
}

extension NegotListViewController: AudioKindButtonsDelegate {
    func onTapped(type: AudioKind) {
        self.onChangeAudioKind(type:type)
    }
    
}
