//
//  MenuController.swift
//  MyWetherBar
//
//  Created by knmk0002 on 16/8/2.
//  Copyright © 2016年 knmk0002. All rights reserved.
//

import Cocoa

let lengh:CGFloat = 15
let time_gap:NSTimeInterval = 600 // 十分钟更新一次
class MenuController: NSObject {
    var time:String?
    @IBOutlet weak var Menu: NSMenu!
    @IBAction func UpDateClick(sender: NSMenuItem) {
        self.UpdateWetherinfo()
    }
    let Mymenuitem:NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    // 网络请求类
    let ReqWether:NetLink = NetLink()
    
    override func awakeFromNib() {
        let icon =  NSImage.init(named: "99")
        // 状态栏图标显示，false为真彩，ture为黑白
        icon?.template = false
        Mymenuitem.image = icon
        Mymenuitem.title = ""
        Mymenuitem.menu = Menu;
        Mymenuitem.length = NSVariableStatusItemLength + lengh*2
        UpdateWetherinfo()
        // 计时器
        NSTimer.scheduledTimerWithTimeInterval(time_gap, target: self, selector: #selector(MenuController.TimeAction), userInfo: nil, repeats: true)
    }
    func TimeAction() -> Void {
        UpdateWetherinfo()
    }
    func UpdateWetherinfo() -> () {
        let model = WetherModel()
        model.language = "zh-Hans"
        model.unit = "c"
        model.location = "ip"// 自动根据ip识别地理位置
        ReqWether.GETWetherInfo(model) { (data, response, err) in
         // 
            do{
                let re_data:NSDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                let arr:[[String:AnyObject]] = re_data["results"] as! [[String:AnyObject]]
                let dic:[String:AnyObject] = arr[0]
//                print(dic)
                let resmodel = Resultmodel()
                resmodel.setValuesForKeysWithDictionary(dic)
                self.updateUI(resmodel)
            }catch {
                
            }

        }
    }
    func updateUI(model:Resultmodel) -> Void {
        Mymenuitem.image = NSImage.init(named: model.now!["code"] as! String)
        Mymenuitem.title = self.GetDate().stringByAppendingString((model.location!["name"] as? String)!).stringByAppendingString(" ").stringByAppendingString((model.now!["text"] as? String)!).stringByAppendingString(" ").stringByAppendingString((model.now!["temperature"] as? String)!).stringByAppendingString(" ℃")
        let boundingRect = Mymenuitem.title!.boundingRectWithSize(CGSizeMake(CGFloat(MAXFLOAT), 100), options: .UsesFontLeading, attributes: [NSFontAttributeName:NSFont.init(name: "PingFang SC", size: 17)!], context: nil)
        Mymenuitem.length = NSVariableStatusItemLength + boundingRect.width
    }
    
    func GetDate() -> String {
        let formater = NSDateFormatter()
        formater.dateFormat = "MM-dd "
        return formater.stringFromDate(NSDate.init())
    }
    // 退出
    @IBAction func QUIT(sender: NSMenuItem) {
        NSApplication.sharedApplication().terminate(self)
    }
}

class Resultmodel: NSObject {
    var location:[String:AnyObject]?
    var now:[String:AnyObject]?
    var last_update:String?
}
