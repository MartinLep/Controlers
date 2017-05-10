//
//  pwLocationViewController.swift
//  pwControls
//
//  Created by MartinLee on 17/5/8.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import UIKit
import CoreLocation

class pwLocationViewController: pwBaseViewController {
    
    @available(iOS 9.0, *)
    lazy var manger : CLLocationManager = {
        //        获取用户位置信息
        //        1 创建位置管理者
        let manager = CLLocationManager()
        manager.delegate = self
        //        默认情况智能再前台获取用户位置信息，如果想要在后台也获取，那么必须勾选location updates
        if #available(iOS 8.0, *){
            manager.requestWhenInUseAuthorization()
            if #available(iOS 9.0, *){
                //        如果在iOS9.0之后，想要在后台获取用户位置
                //        如果当前的授权状态时前台定位授权，那么需要勾选后台模式 location updates，还要额外设置以下属性为true
                manager.allowsBackgroundLocationUpdates = true
            }
        }
        //设置过滤距离
        manager.distanceFilter = 100;
//        定位精确度，精确度越好越耗电，而且定位时间越长
//         kCLLocationAccuracyBestForNavigation ;最适合导航
//         kCLLocationAccuracyBest;最好的
//         kCLLocationAccuracyNearestTenMeters;附近10米
//         kCLLocationAccuracyHundredMeters;附近100米
//         kCLLocationAccuracyKilometer;附近1000米
//         kCLLocationAccuracyThreeKilometers;附近3000米
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        return manager
    }()
    
    
    fileprivate lazy var locationButton : UIButton = {
        let location = UIButton(frame: CGRect(x: 100, y: 100, width: 60, height: 60))
        location.addTarget(self, action: #selector(getLoaction), for: .touchUpInside)
        location.setTitle("获取位置信息", for: .normal)
        location.sizeToFit()
        location.setTitleColor(UIColor.black, for: .normal)
        location.setTitleColor(UIColor.gray, for: .highlighted)
        return location
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.tableView.removeFromSuperview()
        self.view.addSubview(locationButton)
    }
    
    @objc fileprivate func getLoaction(){
        
        
        //        2 实用位置管理者，开始获取用户位置信息
        //        小经验：如果以后实用位置管理者这个对象，实现某个服务，那么刻意以startXX 开始某个服务，以stopXX结束
        //        开始更新位置信息，意味着一旦调用了这个方法，就会不断的刷新用户位置，然后告诉外界
        if #available(iOS 9.0, *) {
//            定位：标准定位服务（gps/wifi/蓝牙／基站）
            manger.startUpdatingLocation()
//            显著位置变化的服务(基站定位)
//            manger.startMonitoringSignificantLocationChanges()
            //定位精度由低到高，必须实现定位失败的方法
            manger.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        
    }
}

extension pwLocationViewController : CLLocationManagerDelegate{
    
    
    ///  定位到之后调用的方法
    ///
    /// - Parameters:
    ///   - manager: 位置管理者
    ///   - locations: 位置对象数组
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(Thread.current)
//        获取用户当前所在的城市，切换到对应的城市
//        如果想要定位一次，那么在定位到之后停止定位
//        manager.stopUpdatingLocation()
//         let newLocation = locations.last
//        CLLocation
        /*
         coordinate:经纬度信息
         altitude:海拔信息
         horizontalAccuracy:如果整个数字都是负数，就代表位置数据无效
         verticalAccuracy:如果整个数字都是负数，代表海拔数据无效
         course:航向
         speed:速度
         distanceFromLocation:计算两个经纬度之间的直线距离
         */
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .authorizedAlways: break
        case .authorizedWhenInUse: break
        case .denied:
            if(CLLocationManager.locationServicesEnabled()){
                print("真正被拒绝")
                if #available(iOS 8.0, *){
//                 手动条转到这是界面
                    let url = NSURL(string: UIApplicationOpenSettingsURLString)
                    if UIApplication.shared.canOpenURL(url as! URL){
                        UIApplication.shared.openURL(url as! URL)
                    }
                }
            }else{
                
            }
            break
        case .restricted: break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("定位失败")
        if #available(iOS 9.0, *) {
            manger.requestLocation()
        } else {
            // Fallback on earlier versions
        }
    }
}
