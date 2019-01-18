//
//  MPUploadIDCartViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/12/27.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

class MPUploadIDCartViewController: UIViewController {

    init(model: MPSignUpUploadModel) {
        uploadInfoModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    var uploadInfoModel: MPSignUpUploadModel
    fileprivate var margin: CGFloat {
        var value: CGFloat = 15
        if mp_screenW < 350 {
            value = 10
        }
        return value
    }
    
    /// 正在选择的Item
    fileprivate var editingItem: MPUploadImageView?
    fileprivate var uploadItemArr = [MPUploadImageView]()
    
    // MAKR: -
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "报名页面"
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 0.1))
        let footerView = createUploadView()
        footerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: calculateUploadViewHeight())
        tableView.tableFooterView = footerView
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    /// 计算上传区域的高度
    fileprivate func calculateUploadViewHeight() -> CGFloat {
        let imageW: CGFloat = (mp_screenW - margin * 3) * 0.5
        let imageH: CGFloat = imageW * 0.65 + 25
        var h: CGFloat = 20 + 10 + 10
        h += imageH * 3 + 30 + 160
        return h
    }
    
    /// 创建上传照片的区域View
    fileprivate func createUploadView() -> UIView {
        let uploadView = UIView()
        uploadView.backgroundColor = UIColor.white
        let titleLabel = UILabel(font: UIFont.mpSmallFont, text: "添加图片", textColor: UIColor.mpDarkGray)
        uploadView.addSubview(titleLabel)
        let upload1 = createUploadItem(image: UIImage(named: "idcard_front"), title: "身份证正面照")
        let upload2 = createUploadItem(image: UIImage(named: "idcard_contrary"), title: "身份证反面照")
        let upload3 = createUploadItem(image: UIImage(named: "driver_pic"), title: "司机正面照")
        let upload4 = createUploadItem(image: UIImage(named: "driver_card"), title: "人证合一照")
        let upload5 = createUploadItem(image: UIImage(named: "driver_licence"), title: "驾驶证正面照")
        let upload6 = createUploadItem(image: UIImage(named: "driver_licence_addtion"), title: "驾驶证副业照")
        uploadItemArr.append(upload1)
        uploadItemArr.append(upload2)
        uploadItemArr.append(upload3)
        uploadItemArr.append(upload4)
        uploadItemArr.append(upload5)
        uploadItemArr.append(upload6)
        let submitView = UIView()
        submitView.backgroundColor = UIColor.colorWithHexString("f5f5f5")
        let submitButton = UIButton()
        submitButton.backgroundColor = UIColor.navBlue
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(MPUploadIDCartViewController.submit), for: .touchUpInside)
        submitButton.setTitle("下一步", for: .normal)
        submitButton.titleLabel?.font = UIFont.mpBigFont
        submitButton.setupCorner(4)
        submitButton.isUserInteractionEnabled = false
        submitButton.backgroundColor = UIColor.lightGray
        self.submitButton = submitButton
        submitView.addSubview(submitButton)
        uploadView.addSubview(submitView)
        uploadView.addSubview(upload1)
        uploadView.addSubview(upload2)
        uploadView.addSubview(upload3)
        uploadView.addSubview(upload4)
        uploadView.addSubview(upload5)
        uploadView.addSubview(upload6)
        let imageW: CGFloat = (mp_screenW - margin * 3) * 0.5
        let imageH: CGFloat = imageW * 0.65 + 25
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(margin)
            make.top.equalToSuperview().offset(10)
        }
        upload1.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(imageH)
            make.width.equalTo(imageW)
        }
        upload2.snp.makeConstraints { (make) in
            make.leading.equalTo(upload1.snp.trailing).offset(margin)
            make.top.equalTo(upload1)
            make.height.width.equalTo(upload1)
        }
        upload3.snp.makeConstraints { (make) in
            make.top.equalTo(upload1.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.height.width.equalTo(upload1)
        }
        upload4.snp.makeConstraints { (make) in
            make.leading.equalTo(upload3.snp.trailing).offset(margin)
            make.top.equalTo(upload3)
            make.height.width.equalTo(upload1)
        }
        upload5.snp.makeConstraints { (make) in
            make.top.equalTo(upload3.snp.bottom).offset(10)
            make.leading.equalTo(titleLabel)
            make.height.width.equalTo(upload1)
        }
        upload6.snp.makeConstraints { (make) in
            make.leading.equalTo(upload3.snp.trailing).offset(margin)
            make.top.equalTo(upload5)
            make.height.width.equalTo(upload1)
        }
        submitView.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(160)
        }
        submitButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(160)
            make.height.equalTo(40)
        }
        return uploadView
    }
    
    fileprivate func createUploadItem(image: UIImage?, title: String) -> MPUploadImageView {
        let item = MPUploadImageView(placeHolder: image!, title: title)
        item.addTarget(self, action: #selector(MPUploadIDCartViewController.selectPic(item:)), for: .touchUpInside)
        return item
    }
    
    // MARK: - Action
    @objc fileprivate func selectPic(item: MPUploadImageView) {
        editingItem = item
        let vc = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: self)!
        vc.showSelectBtn = false
        vc.allowPreview = false
        vc.preferredLanguage = "zh-Hans"
        vc.naviBgColor = UIColor.navBlue
        vc.allowTakeVideo = false
        vc.allowPickingVideo = false
        present(vc, animated: true, completion: nil)
    }
    
    @objc fileprivate func submit() {
        for (index, model) in uploadItemArr.enumerated() {
            switch index {
            case 0:
                uploadInfoModel.pic_idcard_front = model.image
            case 1:
                uploadInfoModel.pic_idcard_back = model.image
            case 2:
                uploadInfoModel.pic_driver = model.image
            case 3:
                uploadInfoModel.pic_user = model.image
            case 4:
                uploadInfoModel.pic_drive_front = model.image
            case 5:
                uploadInfoModel.pic_drive_back = model.image
            default:
                break
            }
        }
        let vc = MPWorkInfoViewController(model: uploadInfoModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    fileprivate var submitButton: UIButton?
    fileprivate lazy var processView: MPProcessView = {
        let v = MPProcessView()
        v.setupSelectIndex(1)
        return v
    }()
}

extension MPUploadIDCartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return MPTitleSectionHeaderView(title: "信息提交流程", reuseIdentifier: nil)
        }else {
            let block = MPUtils.createLine(UIColor.colorWithHexString("f5f5f5"))
            return block
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return processView
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 85
        }else {
            return 0.01
        }
    }
}

extension MPUploadIDCartViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        editingItem?.image = photos.first
        var isValid = true
        for model in uploadItemArr {
            if model.image == nil {
                isValid = false
                break
            }
        }
        if isValid {
            submitButton?.isUserInteractionEnabled = true
            submitButton?.backgroundColor = UIColor.navBlue
        }else {
            submitButton?.isUserInteractionEnabled = false
            submitButton?.backgroundColor = UIColor.lightGray
        }
    }
}

