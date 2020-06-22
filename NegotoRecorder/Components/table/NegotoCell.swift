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
    var interval : ActivatedIntervalViewModel
}

class NegotoCell : UITableViewCell {
    var data : NegotoCellData? {
        didSet{
            self.titleLabel.text = data?.title
            if let _date = data?.date {
                self.dateLable.text = CommonUtils.stringFromDate(date: _date, format: "yyyy年MM月dd日 HH時mm分")
            }
            
        }
    }
    
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let dateLable: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
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
        dateLable.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width, height: 0, enableInsets: false)
        titleLabel.anchor(top: dateLable.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: frame.size.width, height: 0, enableInsets: false)
        playButton.setRightBottom(view: self, color: MyColors.theme.cgColor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPlayer(_ player: AudioPlayer) {
        guard let d = data else {return}
        player.preparePlay(fileName: d.fileName)
        self.playButton.setPlayer(player)
    }
    
}
