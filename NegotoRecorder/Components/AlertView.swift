//
//  AlertView.swift
//  NegotoRecorder
//
//  Created by kitaharamugirou on 2020/07/12.
//  Copyright © 2020 kitaharamugirou. All rights reserved.
//

import Foundation
import UIKit
class AlertView {
    static func singleOptionAlert(presenter:UIViewController , title : String, message : String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)

        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
        })

        // ③ UIAlertControllerにActionを追加
        alert.addAction(defaultAction)

        // ④ Alertを表示
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func textViewAlert(presenter:UIViewController , title : String, message : String, completion: @escaping(_ text:String) -> () ) {
        let alert:UIAlertController = UIAlertController(title:title,
            message: message,
            preferredStyle: UIAlertController.Style.alert)

        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertAction.Style.cancel,
            handler:{
            (action:UIAlertAction!) -> Void in
                print("Cancel")
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
                                                        style: UIAlertAction.Style.default,
            handler:{
            (action:UIAlertAction!) -> Void in
                let textFields:Array<UITextField>? =  alert.textFields as Array<UITextField>?
                if textFields != nil {
                    for textField:UITextField in textFields! {
                        completion(textField.text ?? "")
                    }
                }
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        //textfiledの追加
        alert.addTextField(configurationHandler: {(text:UITextField!) -> Void in
        })
        presenter.present(alert, animated: true, completion: nil)
    }
    
    static func actionSheet(presenter:UIViewController, title : String, message : String, okText:String="OK", completion: @escaping() -> ()) {
        let alert:UIAlertController = UIAlertController(title:title,
            message: message,
            preferredStyle: UIAlertController.Style.actionSheet)

        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
                                                       style: UIAlertAction.Style.cancel,
            handler:{
            (action:UIAlertAction!) -> Void in
                print("Cancel")
        })

        let defaultAction:UIAlertAction = UIAlertAction(title: okText,
                                                        style: UIAlertAction.Style.default,
            handler:{
            (action:UIAlertAction!) -> Void in
                completion()
        })
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        presenter.present(alert, animated: true, completion: nil)
        alert.view.tintColor = MyColors.theme
    }
}
