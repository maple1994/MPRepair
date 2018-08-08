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
    fileprivate var mapView: MAMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNav()
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
        mapView?.isShowsUserLocation = true
        mapView?.userTrackingMode = MAUserTrackingMode.follow
        mapView?.delegate = self
        tableView.tableHeaderView = tbHeaderView
        /*
         CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error
         */
        locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            
        }
        locationManager.locationTimeout = 6
        locationManager.reGeocodeTimeout = 3
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView?.setZoomLevel(12, animated: true)
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
    
    fileprivate var tableView: UITableView!
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
}

extension MPQuCheViewController2: MAMapViewDelegate {
    
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
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (_) in
            
        })
    }
}

