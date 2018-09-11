//
//  MPStartYearCheckViewController2.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/7.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 开始年检界面2
class MPStartYearCheckViewController2: UIViewController {

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
        fatalError("")
    }
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
    }
    
    fileprivate func setupUI() {
        yearCheckTitileView = MPYearCheckTitleView()
        yearCheckTitileView.selectedIndex = 2
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
        tableView.tableFooterView = MPFooterConfirmView(title: "确认到达", target: self, action: #selector(MPStartYearCheckViewController2.confirm))
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
        mapView?.userTrackingMode = MAUserTrackingMode.follow
        mapView?.delegate = self
        tableView.tableHeaderView = tbHeaderView
        /*
         CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func setupNav() {
        navigationItem.title = "开始年检"
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
    
    @objc fileprivate func confirm() {
        let hud = MPTipsView.showLoadingView("上传中...")
        MPNetword.requestJson(target: .startYearCheck(id: orderModel.id), success: { (_) in
            MPNetwordTool.getOrderInfo(id: self.orderModel.id, succ: { (model) in
                self.orderModel = model
            }, fail: nil)
            hud?.hide(animated: true)
            let vc = MPStartYearCheckViewController(model: self.orderModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }) { (_) in
            hud?.hide(animated: true)
            MPTipsView.showMsg("上传失败，请重新再试")
        }
    }
    
    // MARK: - View
    fileprivate var mapView: MAMapView?
    fileprivate var tableView: UITableView!
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
    fileprivate var customUserLocationView: MAAnnotationView!
}

extension MPStartYearCheckViewController2: MAMapViewDelegate {
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
extension MPStartYearCheckViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPQuCheCCell
        if cell == nil {
            cell = MPQuCheCCell(style: .default, reuseIdentifier: CellID)
        }
        cell?.timeTitleLabel.text = "年检时间"
        cell?.addressTitleLabel.text = "年检地点"
        cell?.carNameLabel.text = orderModel.car_brand
        cell?.timeLabel.text = orderModel.survey_time
        cell?.addressLabel.text = orderModel.surveystation?.name
        cell?.delegate = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (cell1) in
            let cell = cell1 as? MPQuCheCCell
            cell?.carNameLabel.text = self.orderModel.car_brand
            cell?.timeLabel.text = self.orderModel.survey_time
            cell?.addressLabel.text = self.orderModel.surveystation?.name
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPStartYearCheckViewController2: MPQuCheCCellDelegate {
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
        var name = ""
        if let name1 = orderModel.surveystation?.name {
            name = name1
        }
        let destion = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
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
            config.setRoutePlanPOIType(AMapNaviRoutePlanPOIType.end, location: AMapNaviPoint.location(withLatitude: CGFloat(des.latitude), longitude: CGFloat(des.longitude)), name: name, poiId: nil)  //传入终点
            self.compositeManager.presentRoutePlanViewController(withOptions: config)
        }
    }
}

extension MPStartYearCheckViewController2: AMapNaviCompositeManagerDelegate {
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
