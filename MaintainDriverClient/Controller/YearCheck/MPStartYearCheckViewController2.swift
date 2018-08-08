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
    fileprivate var mapView: MAMapView?
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
        navigationItem.title = "开始年检"
    }
    
    @objc fileprivate func confirm() {
        let vc = MPStartYearCheckViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate var tableView: UITableView!
    fileprivate var yearCheckTitileView: MPYearCheckTitleView!
}

extension MPStartYearCheckViewController2: MAMapViewDelegate {
    
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
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID, configuration: { (_) in
            
        })
    }
}
