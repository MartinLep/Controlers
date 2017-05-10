//
//  pwCompassViewController.swift
//  pwControls
//
//  Created by MartinLee on 17/5/9.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import UIKit
import CoreLocation

class pwCompassViewController: pwBaseViewController {
    @IBOutlet weak var compassView: UIImageView!

    lazy var locationManager : CLLocationManager = {
       let location = CLLocationManager()
        location.delegate = self
        return location
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setUpUI() {
        super.setUpUI()
        self.tableView.removeFromSuperview()
        
        //创建位置管理者
        
        //使用位置管理者，获取当前设备的朝向
//        “磁力传感器”
        if CLLocationManager.headingAvailable(){
            locationManager.startUpdatingHeading()
        }else{
            print("当前磁力设备出现问题")
        }
    }

}

extension pwCompassViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print(newHeading)
        
//        拿到当前设备朝向
        let angle = newHeading.magneticHeading
        
//        把角度转成弧度
        let hudu = CGFloat(angle / 180 * M_PI)
        
//        反向旋转图片
        //compassView.transform = CGAffineTransform(rotationAngle: hudu)
        UIView.animate(withDuration: 0.5) { 
            self.compassView.transform = CGAffineTransform(rotationAngle: hudu)
        }
    }
}
