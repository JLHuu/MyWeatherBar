//
//  NetLink.swift
//  MyWetherBar
//
//  Created by knmk0002 on 16/8/3.
//  Copyright © 2016年 knmk0002. All rights reserved.
//

import Cocoa
let api_src = "alav8wplbvpkfmq4"
let api_id = "UBEB9D6270"
let baseurl = "https://api.thinkpage.cn/v3/weather/now.json"
// 天气model
class WetherModel: NSObject {
    var location:String?
    var language:String?
    var unit:String?
    
}
/// 网络连接
class NetLink: NSObject {
    let Session:NSURLSession = NSURLSession.sharedSession()
    
    // 获取天气信息 GET
    func GETWetherInfo(model:WetherModel!,CallBack: (data:NSData?, response:NSURLResponse?, err:NSError?) -> Void) -> () {
        //
        let queryItem1 = NSURLQueryItem(name: "key", value: api_src)
        let queryItem2 = NSURLQueryItem(name: "location", value: model.location)
        let queryItem3 = NSURLQueryItem(name: "language", value: model.language)
        let queryItem4 = NSURLQueryItem(name: "unit", value: model.unit)
        let urlComponents = NSURLComponents(string: baseurl)!
        urlComponents.queryItems = [queryItem1,queryItem2,queryItem3,queryItem4]
        let regURL = urlComponents.URL!
        let request = NSMutableURLRequest(URL: regURL)
        request.HTTPMethod = "GET"
        let task = Session.dataTaskWithRequest(request) { (data, response, error) in
            CallBack(data: data,response: response,err: error)
        }
        task.resume()
    }
}