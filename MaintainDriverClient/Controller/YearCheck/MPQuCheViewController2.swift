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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    fileprivate func setupUI() {
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
            make.edges.equalToSuperview()
        }
        let tbHeaderView = UIView()
        tbHeaderView.frame = CGRect(x: 0, y: 0, width: MPUtils.screenW, height: 300)
        tbHeaderView.backgroundColor = UIColor.colorWithHexString("#ff0000", alpha: 0.3)
        tableView.tableHeaderView = tbHeaderView
    }
    
    @objc fileprivate func confirm() {
        print("确认取车")
    }
    
    fileprivate var tableView: UITableView!
}

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

class MPQuCheCCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
     
        fatalError("")
    }
    
    fileprivate func setupUI() {
        let carTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "车型：", textColor: UIColor.lightGray)
        carNameLabel = UILabel(font: UIFont.systemFont(ofSize: 15), text: "奔驰x123124", textColor: UIColor.lightGray)
        let addressTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 16), text: "交接地点：", textColor: UIColor.black)
        addressLabel = UILabel(font: UIFont.systemFont(ofSize: 17), text: "兴南大道33号月雅苑门口兴南大道33号月雅苑门口", textColor: UIColor.black)
        addressLabel.numberOfLines = 0
        let timeTitleLabel = UILabel(font: UIFont.systemFont(ofSize: 17), text: "交接时间：", textColor: UIColor.black)
        timeLabel = UILabel(font: UIFont.systemFont(ofSize: 17), text: "2018-07-29 下午", textColor: UIColor.black)
        contactButton = MPYearCheckItemView(icon: #imageLiteral(resourceName: "phone"), selectedIcon: nil, title: "联系他")
        contactButton.font = UIFont.systemFont(ofSize: 13)
        contactButton.addTarget(self, action: #selector(MPQuCheCCell.contact), for: .touchUpInside)
        let line = MPUtils.createLine()
        contentView.addSubview(carTitleLabel)
        contentView.addSubview(carNameLabel)
        contentView.addSubview(addressTitleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(timeTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(contactButton)
        contentView.addSubview(line)
        
        carTitleLabel.snp.makeConstraints { (make) in
            make.leading.top.equalToSuperview().offset(15)
        }
        carNameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(carTitleLabel)
            make.leading.equalTo(carTitleLabel.snp.trailing)
        }
        addressTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(carTitleLabel)
            make.top.equalTo(carTitleLabel.snp.bottom).offset(15).priority(.high)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.top.equalTo(addressTitleLabel)
            make.leading.equalTo(addressTitleLabel.snp.trailing)
            make.trailing.equalTo(line.snp.leading).offset(-5)
        }
        timeTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(carTitleLabel)
            make.top.equalTo(addressLabel.snp.bottom).offset(15).priority(.high)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(timeTitleLabel)
            make.leading.equalTo(timeTitleLabel.snp.trailing)
            make.bottom.equalToSuperview().offset(-12)
        }
        contactButton.snp.makeConstraints { (make) in
            make.height.equalTo(55)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-15)
        }
        line.snp.makeConstraints { (make) in
            make.leading.equalTo(contactButton.snp.leading).offset(-13)
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(1)
            make.height.equalToSuperview().offset(-30)
        }
    }
    
    @objc fileprivate func contact() {
        print("联系他")
    }
    
    fileprivate var carNameLabel: UILabel!
    fileprivate var addressLabel: UILabel!
    fileprivate var timeLabel: UILabel!
    fileprivate var contactButton: MPYearCheckItemView!
}