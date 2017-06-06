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
    let Session:URLSession = URLSession.shared
    // 获取天气信息 GET
    func GETWetherInfo(_ model:WetherModel!,CallBack: @escaping (_ data:Data?, _ response:URLResponse?, _ err:Error?) -> Void) -> () {
        //
        let queryItem1 = URLQueryItem(name: "key", value: api_src)
        let queryItem2 = URLQueryItem(name: "location", value: model.location)
        let queryItem3 = URLQueryItem(name: "language", value: model.language)
        let queryItem4 = URLQueryItem(name: "unit", value: model.unit)
        var urlComponents = URLComponents(string: baseurl)!
        urlComponents.queryItems = [queryItem1,queryItem2,queryItem3,queryItem4]
        let regURL = urlComponents.url!
        let request = NSMutableURLRequest(url: regURL)
        request.httpMethod = "GET"
        let task = Session.dataTask(with: regURL) { (data, response, error) in
                CallBack(data,response,error)
            }
        task.resume()
    }
}
