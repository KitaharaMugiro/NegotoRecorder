//
//  NegotoCell.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/06/21.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit

struct NegotoCellData {
    var title:String
    var date: Date
    var negotoId: String
    var fileName : String
    var seconds: Int
}

class NegotoCell : UITableViewCell {
    var data : NegotoCellData? {
        didSet{
            guard let _data = data else {return}
            self.titleLabel.text = _data.title
            self.secondsLabel.text = "(\(String(describing: _data.seconds))秒)"
            self.dateLable.text = CommonUtils.stringFromDate(date: _data.date, format: "yyyy年MM月dd日 HH時mm分")            
        }
    }
    
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = MyColors.gray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let dateLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = MyColors.gray
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let secondsLabel:UILabel = {
        let lbl = UILabel()
        lbl.textColor = MyColors.gray
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let playButton : PlayButton = {
        let view = PlayButton()
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(dateLable)
        addSubview(secondsLabel)
        dateLable.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: secondsLabel.leftAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0, enableInsets: false)
        secondsLabel.anchor(top: topAnchor, left: dateLable.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 0, enableInsets: false)
        titleLabel.anchor(top: dateLable.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width, height: 0, enableInsets: false)
        playButton.setRightBottom(view: self, color: MyColors.theme.cgColor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** この形だとTableViewのCellのように容易に廃棄されるviewではplayerが孤立する */
    func setPlayer(_ player: AudioPlayer) {
        guard let d = data else {return}
        print("setPlayer from NegotoCell")
        //you need to call setPlayer first before preparePlay because of delegate
        self.playButton.setPlayer(player)
        player.preparePlay(fileName: d.fileName)
    }
    
}
