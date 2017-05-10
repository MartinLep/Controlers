//
//  pwLocationMonitor.swift
//  pwControls
//
//  Created by MartinLee on 17/5/9.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import UIKit
import CoreLocation

class pwLocationMonitor: pwBaseViewController {
    
    lazy var locationManager : CLLocationManager = {
       let location = CLLocationManager()
        location.delegate = self
        //请求授权 配置key NSLocationAlwaysUsageDescription
        if #available(iOS 8.0, *){
            location.requestAlwaysAuthorization()
        }
        return location
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.tableView.removeFromSuperview()
//        判断当前是否可以监听某个区域
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            //        如果想要区域监听，在iOS8.0之后要请求用户的位置授权
            //        区域监听
            //        创建区域
            let center = CLLocationCoordinate2DMake(37.785834, -122.406417)
            var distance : CLLocationDistance = 1000
            if distance > locationManager.maximumRegionMonitoringDistance{
                distance = locationManager.maximumRegionMonitoringDistance//最大监听区域
            }
            let regin = CLCircularRegion(center: center, radius: distance, identifier: "MartinLee")
//            监听
            locationManager.startMonitoring(for: regin)
//            请求某个区域的状态
            locationManager.requestState(for: regin)
            
        }

    }

}

extension pwLocationMonitor : CLLocationManagerDelegate{
//    进入区域时调用
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("进入区域")
    }
//    离开区域时调用
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("离开区域")
    }
    
//    请求区域的状态
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
       if region.identifier == "MartinLee"{ //判断当前定位的标示
            print("定位的标示")
        }
        switch state {
        case .unknown:
            print("未知")
            break
        case .inside:
            print("在区域内")
            break
        case .outside:
            print("在区域外")
            break
        }
    }
}
