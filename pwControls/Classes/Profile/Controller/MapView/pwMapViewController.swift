//
//  pwMapViewController.swift
//  pwControls
//
//  Created by MartinLee on 17/5/10.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

import UIKit
import MapKit

class pwMapViewController: pwBaseViewController {
    @IBOutlet weak var mapView: MKMapView!

    lazy var geoCoder: CLGeocoder = {
        return CLGeocoder()
    }()
    lazy var location : CLLocationManager = {
       let loc = CLLocationManager()
        loc.requestAlwaysAuthorization()
        return loc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func setUpUI() {
        super.setUpUI()
        self.tableView.removeFromSuperview()
        
//        设置地图的样式
//        case standard 标准
//        case satellite 卫星
//        case hybrid 标准加卫星
//        @available(iOS 9.0, *)
//        case satelliteFlyover 3D立体卫星
//        @available(iOS 9.0, *)
//        case hybridFlyover 3D立体混合
        mapView.mapType = MKMapType.standard
        
////        设置地图的控制项目
//        mapView.isScrollEnabled = false
//        mapView.isRotateEnabled = false
//        mapView.isZoomEnabled = false
        
        _ = location
//        设置地图的显示项
        mapView.showsBuildings = true //建筑物
        mapView.showsCompass = true //指南针
        mapView.showsScale = true //比例尺
        mapView.showsTraffic = true //交通
        mapView.showsPointsOfInterest = true //poi兴趣点
        mapView.showsUserLocation = true //用户当前位置
        
//        用户的追踪模式
//        显示一个蓝点，在地图上标示用户的位置信息，但是不会自动放大地图，并且当用户位置移动时，地图会跟着移动
//        不灵光
//        mapView.userTrackingMode = .followWithHeading
//        mapView.delegate = self
        
//        let item = MKUserTrackingBarButtonItem(mapView: mapView)
//        self.navigationItem.leftBarButtonItem = item
    }

    //    理论基础：在地图上操作大头针，实际上操作的是大头针数据模型
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        获取当前点击的位置的经纬度信息
        let point = touches.first?.location(in: mapView)
        let coordinate = mapView.convert(point!, toCoordinateFrom: mapView)
        

        
//        添加大头针
        let annotation = self.addAnnotation(coordinate: coordinate, title: "MartinLee", subTitle: "___")
        
        //        反地理编码的代码
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (pls : [CLPlacemark]?, error : Error?) in
            if error == nil {
                let pl = pls?.first
                annotation.title = pl?.locality
                annotation.subtitle = pl?.subLocality
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        获取所有的大头针数据模型
        let annotations = mapView.annotations
        
//        移除
        mapView.removeAnnotations(annotations)
        
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D,title:String,subTitle:String) -> pwAnnotation{
        //        创建一个大头针
        let annotation: pwAnnotation = pwAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        //        增加一个大头针
        mapView.addAnnotation(annotation)
        return annotation
    }
    
}

extension pwMapViewController : MKMapViewDelegate{
//    当地图跟心用户位置信息时，调用的方法
//    蓝点：大头针“视图”
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //MKUserLocation 大头针数据模型
        userLocation.title = "MartinLee"
        userLocation.subtitle = "---"
        
////        移动地图的中心，显示在当前用户所在的位置
//        mapView.setCenter((userLocation.location?.coordinate)!, animated: true)
//        
////        设置地图显示区域
//        let center = (userLocation.location?.coordinate)!
//        let span = MKCoordinateSpanMake(0.02199521, 0.01609325584)
//        let regin : MKCoordinateRegion = MKCoordinateRegionMake(center, span)
//        mapView.setRegion(regin, animated: true)
    }
    
    //区域改变的时候调用
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region.span)
    }
    
    /// 如果当我们添加一个大头针数据模型到地图上，那么地图酒会自动调用一个代理方法，来查找对应的大头针地图
    ///
    /// - Parameters:
    ///   - mapView: 地图
    ///   - annotation: 大头针数据模型
    /// - Returns: 大头针视图
//    注意事项：如果这个方法没有实现，活着返回nil，就会使用系统默认的大头针来显示
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
////        系统大头针试图对应的类 MKPinAnnotationView
////        大头针视图和cell一样，都有一个循环利用机制
////        1 从缓存池取出大头针视图
//        let iden = "item"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: iden) as? MKPinAnnotationView
//        if annotationView == nil {
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: iden)
//        }
//        
////        显示弹框
//        annotationView?.canShowCallout = true
//        
//        annotationView?.pinTintColor = UIColor.yellow
//        
//        annotationView?.animatesDrop = true
//        print("test")
//        return annotationView
        
//        自定义大头针
//        如果想要自定义大头针，要不使用MKAnnotationView，或者自定义子类
        
        let iden = "item"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: iden) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: iden)
        }
        //非常重要的步骤
        annotationView?.annotation = annotation
        
        //设置大头针的图片
//        annotationView?.image = 
//        设置大头针的中心偏移量
//        annotationView?.centerOffset = CGPoint(x: 10, y: 10)
////        设置弹框
//        annotationView?.canShowCallout = true
////        弹框的偏移量
//        annotationView?.calloutOffset = CGPoint(x: -10, y: -10)
//        annotationView?.leftCalloutAccessoryView //设置弹框的左视图
//        设置下部弹框
//        annotationView?.detailCalloutAccessoryView
//        设置大头针可以拖动
        annotationView?.isDraggable = true
        return annotationView
    }
}


