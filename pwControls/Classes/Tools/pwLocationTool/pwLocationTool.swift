//
//  pwLocationTool.swift
//  pwControls
//
//  Created by MartinLee on 17/5/10.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import Foundation
import CoreLocation

typealias LocationResultBlock = (CLLocation,String) -> ()

class pwLocationTool: NSObject {
    
    static let shareInstance = pwLocationTool()
//    接口类别：对象方法，类方法
//    接口名称
//    参数
//    返回值
    lazy var locationManager : CLLocationManager = {
       let location = CLLocationManager()
        location.delegate = self
        //请求授权
        if #available(iOS 8.0, *){
//            请求前后台定位授权
            
//            请求前台定位授权
        
//            1 获取info.plist文件内容
            guard let infoDic = Bundle.main.infoDictionary else {return location}
//            2 获取前台定位授权的key值
            let whenInUse = infoDic["NSLocationWhenInUseUsageDescription"]
//            3 获取前后台定位授权的key值
            let always = infoDic["NSLocationAlwaysUsageDescription"]
//            4 判断：如果两个都有，请求全县比较高的那一个
//                如果只有某一额，那就请求对应的授权
//                如果两个都没有，给其他开发者提醒
            
            if always != nil {
                location.requestAlwaysAuthorization()
            }else if whenInUse != nil {
                location.requestWhenInUseAuthorization()
                
//                判断后台模式有没有够炫location updates
//                判断当前版本是不是iOS9.0
                let backModes = infoDic["UIBackgroundModes"]
                if backModes != nil {
                    let resultBackModel = backModes as! [String]
                    if resultBackModel.contains("location") {
                        if #available(iOS 9.0, *){
                            location.allowsBackgroundLocationUpdates = true
                        }
                    }
                }
            }else{
                print("错误提示！！！")
            }
            
        }
        return location
    }()
    
    var resultBlock : LocationResultBlock?
    func getCurrentLocation(resultBlock : @escaping LocationResultBlock) -> (){
//        1 记录block
        self.resultBlock = resultBlock
//        2 在何时的地方执行
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }else{
            if self.resultBlock != nil {
                self.resultBlock!(CLLocation(),"没有开启定位服务")
            }
        }
    }
}

extension pwLocationTool : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //判断有没有到达10s
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //可以拿到位置信息
        guard let locs = locations.last else {
            if resultBlock != nil {
                resultBlock!(CLLocation(),"没有获取到位置信息")
            }
            return
        }
        resultBlock!(locs,"")
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let block = resultBlock else {return}
        switch status {
        case .denied:
            block(CLLocation(),"当前被拒绝")
        case .restricted:
            block(CLLocation(),"当前受限制")
        case .notDetermined:
            block(CLLocation(),"用户没确定")
        default:
            print("")
        }
    }
}
