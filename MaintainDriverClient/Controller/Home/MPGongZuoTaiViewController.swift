//
//  MPGongZuoTaiViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Starscream
import SwiftHash

protocol MPGongZuoTaiViewControllerDelegate: class {
    /// 点击了出车
    func gongZuoTaiDidSelectChuChe()
}

/// 工作台
class MPGongZuoTaiViewController: UIViewController {

    fileprivate let CellID = "MPCheckBoxOrderTableViewCell"
    fileprivate var modelArr: [MPOrderModel] = [MPOrderModel]()
    weak var delegate: MPGongZuoTaiViewControllerDelegate?
    fileprivate var selectedModel: MPOrderModel?
    fileprivate var tipsView: MBProgressHUD?
    fileprivate lazy var location: CLLocationManager = {
        let loc = CLLocationManager()
        loc.delegate = self
        return loc
    }()
    
    /// 下车
    func xiaCheAction() {
        stealButton.isHidden = true
        chuCheButton.isHidden = false
        MPOrderSocketManager.shared.disconnet()
        MPListenSocketManager.shared.disconnet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        if MPUserModel.shared.isLogin {
            loadData()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(MPGongZuoTaiViewController.loginSucc), name: MP_LOGIN_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPGongZuoTaiViewController.disconnect(noti:)), name: Notification.Name.init(WebsocketDidDisconnectNotification), object: nil)
    }
    
    @objc fileprivate func disconnect(noti: Notification) {
        if let dic = noti.userInfo?[WebsocketDisconnectionErrorKeyName] {
            print(dic)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        MPListenSocketManager.shared.disconnet()
        MPOrderSocketManager.shared.disconnet()
    }
    
    @objc fileprivate func loginSucc() {
        loadData()
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = UIColor.white
       tableView = UITableView()
        tableView.register(MPOrderTableViewCell.classForCoder(), forCellReuseIdentifier: CellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.viewBgColor
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        stealButton = UIButton()
        stealButton.setTitle("抢单", for: .normal)
        stealButton.setTitleColor(UIColor.navBlue, for: .normal)
        stealButton.setupCorner(5)
        stealButton.setupBorder(borderColor: UIColor.navBlue)
        stealButton.addTarget(self, action: #selector(MPGongZuoTaiViewController.stealAction), for: .touchUpInside)
        stealButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        stealButton.backgroundColor = UIColor.white

        chuCheButton = UIButton()
        chuCheButton.setTitle("出车", for: .normal)
        chuCheButton.setTitleColor(UIColor.white, for: .normal)
        chuCheButton.setupCorner(5)
        chuCheButton.backgroundColor = UIColor.navBlue
        chuCheButton.addTarget(self, action: #selector(MPGongZuoTaiViewController.chuCheAction), for: .touchUpInside)
        chuCheButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        view.addSubview(stealButton)
        view.addSubview(chuCheButton)
        stealButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(160)
            make.bottom.equalToSuperview().offset(-30)
            make.height.equalTo(40)
        }
        chuCheButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(stealButton)
            make.bottom.equalTo(stealButton)
            make.height.equalTo(40)
        }
        stealButton.isHidden = true
        chuCheButton.isHidden = false
    }
    
    @objc fileprivate func loadData() {
        // 从网络拉取上传图片的picName
        MPNetwordTool.getPicName()
        MPNetwordTool.getDriverRuler()
    }
    
    // MARK: - Action
    @objc fileprivate func stealAction() {
        guard let order = modelArr.first else {
            return
        }
        let view = MPNewOrderTipsView.show(title: "抢单成功!", subTitle: "请尽快处理!", delegate: self)
        view.showTimeCount()
        MPNetword.requestJson(target: .grab(id: order.id), success: { (json) in
            view.endTimeCount()
            MPUtils.playGetOrderSuccSound()
            self.selectedModel = order
            NotificationCenter.default.post(name: MP_refresh_ORDER_LIST_SUCC_NOTIFICATION, object: nil)
        }) { (_) in
            self.selectedModel = nil
            view.endTimeCount()
            view.set(title: "抢单失败!", subTitle: "请重新再试!")
        }
    }
    
    @objc fileprivate func chuCheAction() {
        let vc = MPLeagueViewController()
        navigationController?.pushViewController(vc, animated: true)
//        switch MPUserModel.shared.is_driverinfo {
//        case .unsubmit, .checkFailed:
//            let tipsView = MPAuthorityTipView()
//            tipsView.frame = UIScreen.main.bounds
//            tipsView.setupFail(tips: "很抱歉，您需要培训后才能使用软件", cancelTitle: "暂不需要", confirmTitle: "去培训")
//            tipsView.confirmBlock = { [weak self] in
//                let vc = MPLeagueViewController()
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
//            UIApplication.shared.keyWindow?.addSubview(tipsView)
//            return
//        case .checking:
//            // 正在审核
//            showTipsView("资料正在审核中，请耐心等候", block: nil)
//        case .checkSucc:
//            // 检查有没通过考试，没有就去考试
//            if !isPassQuestion() {
//                return
//            }
//            // 检查有没买保险，没有就去买保险
//            if !isPassInsurance() {
//                return
//            }
//            didChuChe()
//        }
    }
    
    fileprivate func didChuChe() {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined, .restricted:
            location.requestWhenInUseAuthorization()
        case .denied:
            MPTipsView.showMsg("请去设置开启定位")
        default:
            // 审核成功
            connctServer()
        }
    }
    
    fileprivate func isPassQuestion() -> Bool {
        switch MPUserModel.shared.is_question {
        // 未考试先去考试
        case .unsubmit, .failed:
            let vc = MPExaminationViewController()
            navigationController?.pushViewController(vc, animated: true)
            return false
        case .pass:
            return true
        }
    }
    
    fileprivate func isPassInsurance() -> Bool {
        switch MPUserModel.shared.is_insurance {
        case .unpay, .expired:
            let vc = MPInsuranceViewController()
            navigationController?.pushViewController(vc, animated: true)
        case .handling:
            showTipsView("您好！保险隔天生效，保险生效后才能进行抢单", block: nil)
        case .payed:
            return true
        case .willExpire:
            let tipsView = MPAuthorityTipView()
            tipsView.frame = UIScreen.main.bounds
            tipsView.setupFail(tips: "您好，您购买的保险快到期了，为了不影响你的代价，请及时购买", cancelTitle: "出车", confirmTitle: "购买")
            tipsView.confirmBlock = { [weak self] in
                let vc = MPInsuranceViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            tipsView.cancelBlock = { [weak self] in
                self?.didChuChe()
            }
            UIApplication.shared.keyWindow?.addSubview(tipsView)
        }
        return false
    }
    
    fileprivate func showTipsView(_ tips: String, block: (() -> Void)?) {
        let tipsView = MPAuthorityTipView()
        tipsView.frame = UIScreen.main.bounds
        tipsView.confirmBlock = block
        tipsView.setup(title: "提示", subTitle: tips)
        UIApplication.shared.keyWindow?.addSubview(tipsView)
    }
    
    /// 建立长连接
    fileprivate func connctServer() {
        tipsView = MPTipsView.showLoadingView("获取订单列中...")
        let locationManager = AMapLocationManager()
        locationManager.requestLocation(withReGeocode: true) { (location, regeocode, error) in
            guard let coord = location?.coordinate else {
                self.tipsView?.label.text = "获取定位失败，请重新再试"
                self.tipsView?.hide(animated: true, afterDelay: 1)
                return
            }
            MPOrderSocketManager.shared.connect(socketDelegate: self, longitude: coord.longitude, latitude: coord.latitude)
        }
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    /// 抢单
    fileprivate var stealButton: UIButton!
    /// 出车
    fileprivate var chuCheButton: UIButton!
}

extension MPGongZuoTaiViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            connctServer()
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MPGongZuoTaiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: CellID) as? MPOrderTableViewCell
        if cell == nil {
            cell = MPOrderTableViewCell(style: .default, reuseIdentifier: CellID)
        }
        cell?.orderModel = modelArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = tableView.fd_heightForCell(withIdentifier: CellID) { (cell1) in
            let cell = cell1 as? MPOrderTableViewCell
            cell?.orderModel = self.modelArr[indexPath.row]
        }
        return h
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

extension MPGongZuoTaiViewController: MPNewOrderTipsViewDelegate {
    func tipsViewDidConfirm() {
        guard let model = selectedModel else {
            return
        }
        let vc = MPOrderConfirmViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - MPOrderSocketDelegate 获取抢单列表的Socket
extension MPGongZuoTaiViewController: MPOrderSocketDelegate {
    func websocketDidConnect() {
        MPPrint("抢单列表的Socket-连接成功")
        tipsView?.hide(animated: true)
        delegate?.gongZuoTaiDidSelectChuChe()
        stealButton.isHidden = false
        chuCheButton.isHidden = true
    }
    
    func websocketDidDisconnect(error: Error?) {
        if let wsError = error as? WSError {
            // CloseCode.normal(1000)为正常断开
            if wsError.code != Int(CloseCode.normal.rawValue) {
                tipsView?.label.text = "获取失败，请重新再试"
                tipsView?.hide(animated: true, afterDelay: 1)
                MPPrint("抢单列表的Socket-连接失败-\(error?.localizedDescription)")
            }else {
                MPPrint("抢单列表的Socket-断开连接")
            }
        }
    }
    
    func websocketDidReceiveMessage(text: String) {
        MPPrint("抢单列表的Socket-text-\(text)")
        guard let json = text.toJson() else {
            return
        }
        guard let data = json["data"] as? [[String: Any]] else {
            return
        }
        var arr = [MPOrderModel]()
        for dic in data {
            if let model = MPOrderModel.toModel(dic) {
                arr.append(model)
            }
        }
        modelArr = arr
        if arr.count != 0 {
            MPUtils.playNewOrderSound()
        }
        tableView.reloadData()
    }
    
    func websocketDidReceiveData(data: Data) {
        MPPrint("抢单列表的Socket-二进制文件-\(data.count)")
    }
}

