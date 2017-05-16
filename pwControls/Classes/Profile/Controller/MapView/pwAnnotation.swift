//
//  pwAnnotation.swift
//  pwControls
//
//  Created by MartinLee on 17/5/11.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import UIKit
import MapKit

class pwAnnotation: NSObject,MKAnnotation{

    //确定大头针砸在哪个位置
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    
//    弹框标题
    var title: String?
    
//    弹框子标题
    var subtitle: String?
    
}
