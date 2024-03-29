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

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let months=["Тохсунньу", "Олунньу", "Кулун тутар", "Муус устар", "Ыам ыйа", "Бэс ыйа", "От ыйа", "Атырдьах ыйа", "Балаҕан ыйа","Алтынньы","Сэтинньи","Ахсынньы"];
    
    let weekdays=["Баскыһыанньа","Бэнидиэнньик","Оптуорунньук","Сэрэдэ","Чэппиэр","Бээтинсэ","Субуота"];
    
    @IBOutlet weak var widget_title: UILabel!
    
    @IBOutlet weak var widget_sutitle: UILabel!
    
    @IBOutlet weak var widget_summary: UILabel!
    
    @IBOutlet weak var widget_image: UIImageView!
    
    @IBOutlet weak var widget_sun: UIImageView!
    
    @IBOutlet weak var widget_moon: UIImageView!
    @IBOutlet weak var sun_rise: UILabel!
    @IBOutlet weak var sun_set: UILabel!
    @IBOutlet weak var sun_comment: UILabel!
    @IBOutlet weak var moon_rise: UILabel!
    @IBOutlet weak var moon_set: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        
        let date = Date()
        let calendar = Calendar.current
        
        let month_index = calendar.component(.month, from: date)
        let weekday_index = calendar.component(.weekday, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        
        let path = "flutter_assets/assets/"+String(year)+"/"+String(month_index)+"/"+String(day)
        
        widget_title.text = months[month_index-1]+" "+String(day)
        widget_sutitle.text = weekdays[weekday_index-1]+", "+String(year)
        widget_summary.text = getSummary(key: path)
        
        let tintableImageSun : UIImage = getImageFromFile(key:"flutter_assets/assets/icon/sun.png")
        widget_sun.image = tintableImageSun.withRenderingMode(.alwaysTemplate)
        widget_sun.tintColor = UIColor.black
        
        setSunAndMoon (key: path)
        
        
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
    
    func setSunAndMoon(key: String){
        
        sun_rise.text = ""
        sun_set.text = ""
        sun_comment.text = ""
        
        moon_rise.text = ""
        moon_set.text = ""
        
        do{
            let s = readDataFromFile(file: key)
            
            let doc: Document = try parse(s)
            
            let sun: Element? = try doc.getElementsByTag("sun").first()
            
            sun_rise.text = try sun?.getElementsByTag("ris").first()?.text() ?? ""
            sun_set.text = try sun?.getElementsByTag("set").first()?.text() ?? ""
            sun_comment.text = try sun?.getElementsByTag("com").first()?.text() ?? ""
            
            let moon: Element? = try doc.getElementsByTag("moon").first()
            
            moon_rise.text = try moon?.getElementsByTag("ris").first()?.text() ?? ""
            moon_set.text = try moon?.getElementsByTag("set").first()?.text() ?? ""
            
            let moon_icon: String = try moon?.getElementsByTag("ico").first()?.text() ?? ""
            
            let tintableImageMoon : UIImage = getImageFromFile(key:"flutter_assets/assets/icon/"+moon_icon+".png")
            widget_moon.image = tintableImageMoon.withRenderingMode(.alwaysTemplate)
            widget_moon.tintColor = UIColor.black
            
        } catch {
            
        }
    }
    
    func getSummaryTextFromHtml(html: String)->String{
        do{
            let doc: Document = try parse(html)
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
