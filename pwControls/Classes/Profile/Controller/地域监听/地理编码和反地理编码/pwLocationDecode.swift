//
//  pwLocationDecode.swift
//  pwControls
//
//  Created by MartinLee on 17/5/9.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import UIKit
import CoreLocation

class pwLocationDecode: pwBaseViewController {
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var latitudeText: UITextField!
    @IBOutlet weak var longitudeText: UITextField!
    
    lazy var geoCoder : CLGeocoder = {
        return CLGeocoder()
    }()
    
    //    地理编码 地址->经纬度
    @IBAction func geoCode() {
        let addressStr = addressTextView.text
        geoCoder.geocodeAddressString(addressStr!) { (pls:[CLPlacemark]?, error:Error?) in
            if error == nil{
                print("地理编码成功")
                guard let plsResult = pls else {return}
                //            CLPlacemark:地标对象
                //            location:地标对象对应的位置对象
                //            name:地址详情
                let firstPL = plsResult.first
                self.addressTextView.text = firstPL?.name
                self.latitudeText.text = "\((firstPL?.location?.coordinate.latitude)!)"
                self.longitudeText.text = "\((firstPL?.location?.coordinate.longitude)!)"
            }else{
                print(error ?? "error")
            }
        }
    }
    
    //    反地理编码 经纬度->地址
    @IBAction func reverseGeoCode() {
        let latitude = CLLocationDegrees(latitudeText.text!)
        let longitude = CLLocationDegrees(longitudeText.text!)
        let location = CLLocation(latitude: latitude!, longitude: longitude!)
        geoCoder.reverseGeocodeLocation(location) { (pls:[CLPlacemark]?, error:Error?) in
            if error == nil{
                print("反地理编码成功")
                guard let plsResult = pls else {return}
                //            CLPlacemark:地标对象
                //            location:地标对象对应的位置对象
                //            name:地址详情
                let firstPL = plsResult.first
                self.addressTextView.text = firstPL?.name
                self.latitudeText.text = "\((firstPL?.location?.coordinate.latitude)!)"
                self.longitudeText.text = "\((firstPL?.location?.coordinate.longitude)!)"
            } else{
                print(error ?? "error")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func setUpUI() {
        super.setUpUI()
        self.tableView.removeFromSuperview()
    }
    
}
