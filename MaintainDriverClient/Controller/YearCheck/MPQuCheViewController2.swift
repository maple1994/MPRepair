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
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView?.setZoomLevel(12, animated: true)
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
        let tbHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: MPUtils.screenW, height: 265))
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
        
        locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            guard let coord = location?.coordinate else {
                return
            }
            self.startCoordinate = coord
            // 23.1575700000,113.3513600000
            self.destinationCoordinate = CLLocationCoordinate2DMake(23.1575700000, 113.3513600000)
            self.addAnnotations()
        }
        locationManager.locationTimeout = 6
        locationManager.reGeocodeTimeout = 3
    }
    
    /// 添加起点，目的地
    fileprivate func addAnnotations() {
        guard let st = startCoordinate,
            let des = destinationCoordinate else {
                return
        }
        let anno = MAPointAnnotation()
        anno.coordinate = st
        anno.title = "起点"
        
        mapView?.addAnnotation(anno)
        
        let annod = MAPointAnnotation()
        annod.coordinate = des
        annod.title = "终点"
        
        mapView?.addAnnotation(annod)
    }
    
    fileprivate func setupNav() {
        navigationItem.title = "上门取车"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消订单", style: .plain, target: self, action: #selector(MPQuCheViewController2.cancelOrder))
        let dic: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)
        ]
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(dic, for: .normal)
    }
    
    @objc fileprivate func cancelOrder() {
        print("取消订单")
    }
    
    @objc fileprivate func confirm() {
        let vc = MPQuCheViewController1()
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
    
    /// 替换当前用户的图标
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let annoationview = views.first as! MAAnnotationView
        
        if(annoationview.annotation .isKind(of: MAUserLocation.self)) {
            let rprt = MAUserLocationRepresentation.init()
            rprt.image = UIImage.init(named: "position")
            
            mapView.update(rprt)
            
            annoationview.calloutOffset = CGPoint.init(x: 0, y: 0)
            annoationview.canShowCallout = false
            self.customUserLocationView = annoationview
        }
    }
    
    /// 旋转当前用户图标
    func mapView(_ mapView:MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation:Bool ) {
        if(!updatingLocation && self.customUserLocationView != nil) {
            UIView.animate(withDuration: 0.1, animations: {
                let degree = userLocation.heading.trueHeading
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
        cell?.delegate = self
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (_) in
            
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPQuCheViewController2: MPQuCheCCellDelegate {
    /// 联系
    func quCheCellDidSelectContact() {
        
    }
    
    /// 导航
    func quCheCellDidSelectNavigation() {
        guard let des = destinationCoordinate,
        let st = startCoordinate else {
                return
        }
        // https://lbs.amap.com/api/amap-mobile/guide/ios/navi
//        let str = "iosamap://navi?sourceApplication=applicationName&poiname=fangheng&poiid=BGVIS&lat=\(des.latitude)&lon=\(des.longitude)&dev=1&style=2"
        let source = "当前位置".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let destion = "华南农业大学".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
        let str = "iosamap://path?sourceApplication=applicationName&sid=BGVIS1&slat=\(st.latitude)&slon=\(st.longitude)&sname=\(source)&did=BGVIS2&dlat=\(des.latitude)&dlon=\(des.longitude)&dname=\(destion)&dev=0&t=0"
        guard let url = URL.init(string: str) else {
            return
        }
        UIApplication.shared.openURL(url)
    }
}

