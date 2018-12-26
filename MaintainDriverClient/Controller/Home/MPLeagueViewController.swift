//
//  MPLeagueViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/26.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 代驾司机加盟
class MPLeagueViewController: UIViewController {

    fileprivate let titleArr: [String] = [
        "基本信息提交", "代驾司机信息审核", "面谈",
        "培训", "加盟仪式", "新手期"
    ]
    fileprivate let contentArr: [String] = [
        "根据注册内容指引如实并完整提交信息（姓名、证件、证件图片等）",
        "身份证、驾驶证、综合评审以及准入评测审核（具体以注册城市为准）",
        "线下一对一沟通，了解您的基本信息",
        "理论培训和服务实操演练",
        "司机身份信息校验，通过后线上签约并领取司机物料",
        "开通账号后，新司机需通过新手其相关考核（具体以注册城市为准）"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "代驾司机加盟"
        tableView = UITableView()
        tableView.register(MPLeagueTableViewCell.classForCoder(), forCellReuseIdentifier: "MPLeagueTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.tableHeaderView = createTbHeaderView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.tableFooterView = createTbFooterView()
    }
    
    fileprivate func createTbHeaderView() -> UIView {
        let v = UIView()
        let label = UILabel(font: UIFont.mpNormalFont, text: "加盟形式", textColor: UIColor.colorWithHexString("#010101"))
        v.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(18)
            make.centerY.equalToSuperview()
        }
        v.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 50)
        return v
    }
    
    fileprivate func createTbFooterView() -> UIView {
        let v = UIView()
        let confrimButton = UIButton()
        confrimButton.setTitle("我要加盟", for: .normal)
        confrimButton.backgroundColor = UIColor.navBlue
        confrimButton.setTitleColor(UIColor.white, for: .normal)
        confrimButton.addTarget(self, action: #selector(MPLeagueViewController.confirm), for: .touchUpInside)
        confrimButton.setupCorner(5)
        
        v.addSubview(confrimButton)
        confrimButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        v.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 90)
        return v
    }
    
    @objc fileprivate func confirm() {
        
    }
    
    fileprivate var tableView: UITableView!
}

extension MPLeagueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MPLeagueTableViewCell") as? MPLeagueTableViewCell
        if cell == nil {
            cell = MPLeagueTableViewCell(style: .default, reuseIdentifier: "MPLeagueTableViewCell")
        }
        cell?.setupCell(num: indexPath.row + 1, title: titleArr[indexPath.row], content: contentArr[indexPath.row], isHiddenLine: indexPath.row == 5)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.fd_heightForCell(withIdentifier: "MPLeagueTableViewCell") { (cell1) in
            let cell = cell1 as? MPLeagueTableViewCell
            cell?.setupCell(num: indexPath.row + 1, title: self.titleArr[indexPath.row], content: self.contentArr[indexPath.row], isHiddenLine: indexPath.row == 5)
        }
    }
}
