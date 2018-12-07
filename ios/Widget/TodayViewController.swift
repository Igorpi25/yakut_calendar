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
    
    let months=["Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Бала5ан ыйа","Алтынньы","Сэтинньи","Ахсынньы"];
    
    let weekdays=["Бас-ньа","Бэн-ник","Оп-ньук","Сэрэдэ","Чэппиэр","Бээт-сэ","Субуота"];
    
    @IBOutlet weak var widget_title: UILabel!
    
    @IBOutlet weak var widget_sutitle: UILabel!
    
    @IBOutlet weak var widget_summary: UILabel!
    
    @IBOutlet weak var widget_image: UIImageView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let date = Date()
        let calendar = Calendar.current
        
        let month_index = calendar.component(.month, from: date)
        let weekday_index = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        
        
        widget_title.text = months[month_index-1]+" "+String(day)
        widget_sutitle.text = weekdays[weekday_index-1]+", "+String(year)
        widget_summary.text = getSummary(key:"flutter_assets/assets/"+String(year)+"/"+String(month_index)+"/"+String(day))
        //widget_image.image = getImageFromFile(key:"flutter_assets/assets/images/winter_1.jpg")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TodayViewController.imageTapped(gesture:)))
        
        // add it to the image view;
        widget_image.addGestureRecognizer(tapGesture)
        // make sure imageView can be interacted with by user
        widget_image.isUserInteractionEnabled = true
        
        
       
        let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            print("Igor Image Tapped")
            //Here you can initiate your new ViewController
            
            openHostApp()
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            //expanded
            self.preferredContentSize = CGSize(width: maxSize.width, height: 160)
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func getSummary(key:String)->String{
        
        let s = readDataFromFile(file: key)
        
        let s_summary = getSummaryTextFromHtml(html:s)
        
        return s_summary
        
        
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
    
    func getImageFromFile(key:String)->UIImage!{
        let filepath = Bundle.main.path(forResource: key, ofType: nil)
        
        return UIImage(contentsOfFile: filepath!)
        
    }
    
    @IBAction func openHostApp()
    {
        if let url = URL(string: "localHost://")
        {
            self.extensionContext?.open(url, completionHandler: {success in print("called url complete handler: \(success)")})
        }
    }
}
