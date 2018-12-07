//
//  TodayViewController.swift
//  Widget
//
//  Created by Пользователь on 05/12/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import UIKit
import NotificationCenter

import Flutter
import SwiftSoup

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var widget_title: UILabel!
    
    @IBOutlet weak var widget_sutitle: UILabel!
    
    @IBOutlet weak var widget_summary: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        //widget_title.text = "\(hour):\(minutes):\(seconds)"
        
        getSummary()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getSummary(){
        
        let key = "flutter_assets/assets/2019/1/1"

        let s = readDataFromFile(file: key)
        
        print("Igor s="+s)
        
        
        let s_summary = getSummaryTextFromHtml(html:s)
        
        widget_summary.text=s_summary
        
//        guard let data = s_summary.data(using: String.Encoding.unicode) else { return }
//        try? widget_title.attributedText = NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        
    }
    
    func getSummaryTextFromHtml(html: String)->String{
        do{
            let doc: Document = try SwiftSoup.parse(html)
            let summary: Elements = try doc.getElementsByTag("summary")
           
            return try summary.text()
        } catch Exception.Error(let type, let message){
            print("Igor getSummaryTextFromHtml message:"+message)
            return ""
        } catch {
            return ""
        }
    }
    
    func readDataFromFile(file:String)-> String{
        guard let filepath = Bundle.main.path(forResource: file, ofType: nil)
            else {
                return "Нету1"
        }
        do {
            let contents = try String(contentsOfFile: filepath)
            return contents
        } catch {
            print("File Read Error for file \(file)")
            return "Нету2"
        }
    }
    
}
