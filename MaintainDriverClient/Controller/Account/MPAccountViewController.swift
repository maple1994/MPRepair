//
//  MPAccountViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/5.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 我的账户
class MPAccountViewController: UIViewController {

    fileprivate let CellID = "MPMingXiTableViewCell"
    fileprivate var mingXiModelArr: [MPMingXiModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    fileprivate func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "提现明细", style: .plain, target: self, action: #selector(MPAccountViewController.tiXianDetail))
        view.backgroundColor = UIColor.viewBgColor
        navigationItem.title = "我的账户"
        tableView = UITableView()
        tableView.register(MPMingXiTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        tableView.backgroundColor = UIColor.viewBgColor
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let tbHeaderView = UIView()
        tbHeaderView.backgroundColor = UIColor.white
        
        let moneyTitleLabel = UILabel(font: UIFont.mpBigFont, text: "我的余额：", textColor: UIColor.fontBlack)
        moneyLabel = UILabel(font: UIFont.mpBigFont, text: "--", textColor: UIColor.priceRed)
        tiXianBtn = UIButton()
        tiXianBtn.setTitle("提现", for: .normal)
        tiXianBtn.titleLabel?.font = UIFont.mpNormalFont
        tiXianBtn.setTitleColor(UIColor.white, for: .normal)
        tiXianBtn.backgroundColor = UIColor.navBlue
        tiXianBtn.setupCorner(5)
        tiXianBtn.addTarget(self, action: #selector(MPAccountViewController.tiXian), for: .touchUpInside)
        tbHeaderView.addSubview(moneyTitleLabel)
        tbHeaderView.addSubview(moneyLabel)
        tbHeaderView.addSubview(tiXianBtn)
        moneyTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(moneyTitleLabel.snp.trailing)
            make.centerY.equalToSuperview()
        }
        tiXianBtn.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(35)
        }
        view.addSubview(tbHeaderView)
        tbHeaderView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tbHeaderView.snp.bottom)
        }
    }
    
    fileprivate func loadData() {
        MPNetwordTool.getAccountInfo(method: 1, succ: { (arr) in
            self.mingXiModelArr = arr
            self.tableView.reloadData()
        }, fail: nil)
        MPNetword.requestJson(target: .getBalance, success: { json in
            if let data = json["data"] as? [String: Any] {
                if let ban = data["balance"] {
                    let money = toDouble(ban)
                    self.moneyLabel.text = String(format: "￥%.2f", money)
                    MPUserModel.shared.balance = money
                }else {
                    self.moneyLabel.text = "--"
                    MPUserModel.shared.balance = nil
                }
            }else {
                self.moneyLabel.text = "--"
                MPUserModel.shared.balance = nil
            }
        })
    }
    
    @objc fileprivate func tiXian() {
        let vc = MPTiXianViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func tiXianDetail() {
        let vc = MPTiXianDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    fileprivate var tiXianBtn: UIButton!
    fileprivate var moneyLabel: UILabel!
    fileprivate lazy var mingXiView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.viewBgColor
        let label = UILabel(font: UIFont.systemFont(ofSize: 16), text: "收入明细", textColor: UIColor.mpDarkGray)
        view.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(5)
        })
        return view
    }()
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPAccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mingXiModelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPMingXiTableViewCell
        if cell == nil {
            cell = MPMingXiTableViewCell(style: .default, reuseIdentifier: CellID)
        }
        let count = mingXiModelArr?.count ?? 0
        cell?.isLineHidden = (indexPath.row == count - 1)
        cell?.detailModel = mingXiModelArr?[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return mingXiView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: CellID) { (cell) in
            let cell1 = (cell as? MPMingXiTableViewCell)
            cell1?.detailModel = self.mingXiModelArr?[indexPath.row]
        }
    }
}






