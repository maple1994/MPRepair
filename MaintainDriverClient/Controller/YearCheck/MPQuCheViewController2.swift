//
//  MPQuCheViewController2.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 上门取车情况二
class MPQuCheViewController2: UIViewController {

    fileprivate let CellID = "MPQuCheCCell"
    fileprivate let locationManager = AMapLocationManager()
    fileprivate var startCoordinate: CLLocationCoordinate2D?
    fileprivate var destinationCoordinate: CLLocationCoordinate2D?
    fileprivate lazy var compositeManager : AMapNaviCompositeManager = {
        let mgr = AMapNaviCompositeManager.init()
        mgr.delegate = self
        return mgr
    }()
    
    fileprivate var orderModel: MPOrderModel
    
    init(model: MPOrderModel) {
        orderModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        mapView?.setZoomLevel(12, animated: true)
    }
    
    fileprivate func setupUI() {
        yearCheckTitileView = MPYearCheckTitleView()
        yearCheckTitileView.selectedIndex = 1
        view.addSubview(yearCheckTitileView)
        yearCheckTitileView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(105)
        }
        
        tableView = UITableView()
        tableView.backgroundColor = UIColor.viewBgColor
        tableView.register(MPQuCheCCell.classForCoder(), forCellReuseIdentifier: CellID)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = MPFooterConfirmView(title: "确认取车", target: self, action: #selector(MPQuCheViewController2.confirm))
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(yearCheckTitileView.snp.bottom)
        }
        let tbHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: mp_screenW, height: 265))
        mapView = MAMapView()
        tbHeaderView.addSubview(mapView!)
        mapView?.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mapView?.showsUserLocation = true
        mapView?.userTrackingMode = .follow
        mapView?.delegate = self
        tableView.tableHeaderView = tbHeaderView
        /*
         typedef void (^AMapLocatingCompletionBlock)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error);
         */
        locationManager.locationTimeout = 2
        locationManager.reGeocodeTimeout = 2
        locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            guard let coord = location?.coordinate else {
                return
            }
            self.startCoordinate = coord
        }
        self.destinationCoordinate = CLLocationCoordinate2DMake(orderModel.order_latitude, orderModel.order_longitude)
        self.addAnnotations()
        
    }
    
    /// 添加起点，目的地
    fileprivate func addAnnotations() {
        guard let des = destinationCoordinate else {
                return
        }
        let annod = MAPointAnnotation()
        annod.coordinate = des
        annod.title = "终点"
        
        mapView?.addAnnotation(annod)
    }
    
    fileprivate func setupNav() {
        navigationItem.title = "上门取车"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消订单", style: .plain, target: self, action: #selector(MPQuCheViewController2.cancelOrder))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.mpSmallFont
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
    }
    
    @objc fileprivate func cancelOrder() {
        MPNetword.requestJson(target: .cancelOrder(id: orderModel.id), success: { (_) in
            MPNetwordTool.getOrderInfo(id: self.orderModel.id, succ: { (model) in
                self.orderModel = model
            }, fail: nil)
            MPTipsView.showMsg("取消成功")
            self.navigationController?.popToRootViewController(animated: true)
        }) { (_) in
            MPTipsView.showMsg("取消失败")
        }
    }
    
    @objc fileprivate func confirm() {
        let vc = MPQuCheViewController1(model: orderModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - View
    fileprivate var customUserLocationView: MAAnnotationView!
    fileprivate var mapView: MAMapView?
    fileprivate var tableView: UITableView!
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
}

extension MPQuCheViewController2: MAMapViewDelegate {
    /// 设置所添加的 标注 样式
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAUserLocation.self) {
            let pointReuseIndetifier = "userLocationStyleReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.image = UIImage.init(named: "position")
            
            self.customUserLocationView = annotationView
            
            return annotationView!
        }
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)

            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                annotationView!.canShowCallout = true
                annotationView!.isDraggable = false
            }
            if annotation.title == "终点" {
                annotationView!.image = UIImage(named: "endPoint")
            }

            return annotationView!
        }
        return nil
    }
    
    /// 旋转当前用户图标
    func mapView(_ mapView:MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation:Bool ) {
        if(!updatingLocation && self.customUserLocationView != nil) {
            UIView.animate(withDuration: 0.1, animations: {
                let degree = userLocation.heading.trueHeading - Double(mapView.rotationDegree)
                let radian = (degree * Double.pi) / 180.0
                self.customUserLocationView.transform = CGAffineTransform.init(rotationAngle: CGFloat(radian))
            })
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPQuCheViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPQuCheCCell
        if cell == nil {
            cell = MPQuCheCCell(style: .default, reuseIdentifier: CellID)
        }
        cell?.timeTitleLabel.text = "取车时间"
        cell?.addressTitleLabel.text = "取车地点"
        cell?.carNameLabel.text = orderModel.car_brand
        cell?.timeLabel.text = orderModel.get_time
        cell?.addressLabel.text = orderModel.order_address
        cell?.delegate = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (cell1) in
            let cell = cell1 as? MPQuCheCCell
            cell?.carNameLabel.text = self.orderModel.car_brand
            cell?.timeLabel.text = self.orderModel.get_time
            cell?.addressLabel.text = self.orderModel.order_address
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPQuCheViewController2: MPQuCheCCellDelegate {
    /// 联系
    func quCheCellDidSelectContact() {
        guard let url = URL(string: "tel:\(orderModel.phone)") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }else {
            UIApplication.shared.openURL(url)
        }
    }
    
    /// 导航
    func quCheCellDidSelectNavigation() {
        guard let des = destinationCoordinate,
        let st = startCoordinate else {
                return
        }
        // https://lbs.amap.com/api/amap-mobile/guide/ios/navi
        let source = "当前位置".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let destion = "\(orderModel.order_address)".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let str = "iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=\(st.latitude)&slon=\(st.longitude)&sname=\(source)&did=BGVIS2&dlat=\(des.latitude)&dlon=\(des.longitude)&dname=\(destion)&dev=0&t=0"
        guard let url = URL.init(string: str) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }else {
                UIApplication.shared.openURL(url)
            }
        }else {
            let config = AMapNaviCompositeUserConfig.init()
            config.setRoutePlanPOIType(AMapNaviRoutePlanPOIType.end, location: AMapNaviPoint.location(withLatitude: CGFloat(des.latitude), longitude: CGFloat(des.longitude)), name: "\(orderModel.order_address)", poiId: nil)  //传入终点
            self.compositeManager.presentRoutePlanViewController(withOptions: config)
        }
    }
}

extension MPQuCheViewController2: AMapNaviCompositeManagerDelegate {
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, error: Error) {
        let error = error as NSError
        NSLog("error:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func compositeManager(onCalculateRouteSuccess compositeManager: AMapNaviCompositeManager) {
        NSLog("onCalculateRouteSuccess,%ld", compositeManager.naviRouteID)
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, onCalculateRouteFailure error: Error) {
        let error = error as NSError
        NSLog("onCalculateRouteFailure error:{%d - %@}", error.code, error.localizedDescription)
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, didStartNavi naviMode: AMapNaviMode) {
        NSLog("didStartNavi")
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, didArrivedDestination naviMode: AMapNaviMode) {
        NSLog("didArrivedDestination")
    }
    
    func compositeManager(_ compositeManager: AMapNaviCompositeManager, update naviLocation: AMapNaviLocation?) {
        //        NSLog("updateNaviLocation,%@",naviLocation)
    }
}

