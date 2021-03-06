//
//  MenuController.swift
//  MyWetherBar
//
//  Created by knmk0002 on 16/8/2.
//  Copyright © 2016年 knmk0002. All rights reserved.
//

import Cocoa

let lengh:CGFloat = 15
let time_gap:TimeInterval = 300 // 300s更新一次
var lock = NSLock()
var resltmodel:Resultmodel?
class MenuController: NSObject {
    var time:String?
    @IBOutlet weak var Menu: NSMenu!
    @IBAction func UpDateClick(_ sender: NSMenuItem) {
        self.UpdateWetherinfo()
    }
    let Mymenuitem:NSStatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

    // 网络请求类
    let ReqWether:NetLink = NetLink()
    
    override func awakeFromNib() {
        resltmodel = Resultmodel()
        let icon =  NSImage.init(named: "99")
        // 状态栏图标显示，false为真彩，ture为黑白
        icon?.isTemplate = false
        Mymenuitem.image = icon
        Mymenuitem.title = ""
        Mymenuitem.menu = Menu;
        Mymenuitem.length = NSVariableStatusItemLength + lengh*2
        UpdateWetherinfo()
        // 计时器
        Timer.scheduledTimer(timeInterval: time_gap, target: self, selector: #selector(MenuController.TimeAction), userInfo: nil, repeats: true)
        // 1s更新时间
       let time2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MenuController.updateTime), userInfo: nil, repeats: true)
        let loop = RunLoop.current
        loop.add(time2, forMode: RunLoopMode.commonModes);

    }
    func TimeAction() -> Void {
        UpdateWetherinfo()
    }
    func updateTime() -> Void {
        updateUI(resltmodel!)
    }
    func UpdateWetherinfo() -> () {
        let model = WetherModel()
        model.language = "zh-Hans"
        model.unit = "c"
        model.location = "ip"// 自动根据ip识别地理位置
        ReqWether.GETWetherInfo(model) { (data, response, err) in
         //
            do{
                let re_data:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                let arr:[[String:AnyObject]] = re_data["results"] as! [[String:AnyObject]]
                let dic:[String:AnyObject] = arr[0]
                print(dic)
                let resmodel = Resultmodel()
                resmodel.setValuesForKeys(dic)
                resltmodel = resmodel
                self.updateUI(resmodel)
            }catch {
                
            }

        }
    }
    func updateUI(_ model:Resultmodel) -> Void {
        lock.lock();
        Mymenuitem.image = NSImage.init(named: (model.now?["code"] as? String)!)
        Mymenuitem.title = ((((((model.location!["name"] as? String)! + " ") + (model.now!["text"] as? String)!) + " ") + (model.now!["temperature"] as? String)!) + " ℃" + "  " + self.GetDate())
        let boundingRect = Mymenuitem.title!.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 100), options: .usesFontLeading, attributes: [NSFontAttributeName:NSFont.init(name: "PingFang SC", size: 17)!], context: nil)
        Mymenuitem.length = NSVariableStatusItemLength + boundingRect.width
        lock.unlock();
    }
    
    func GetDate() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd hh:mm:ss"
        return formater.string(from: Date.init())
    }
    // 退出
    @IBAction func QUIT(_ sender: NSMenuItem) {
        NSApplication.shared().terminate(self)
    }
}

class Resultmodel: NSObject {
    var location:[String:AnyObject]?
    var now:[String:AnyObject]?
    var last_update:String?
}
