//
//  MPProfileViewController.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/19.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

/// 完善资料
class MPProfileViewController: UIViewController {

    fileprivate let editViewH: CGFloat = 60
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
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        NotificationCenter.default.addObserver(self, selector: #selector(MPProfileViewController.keyboardShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MPProfileViewController.keyboardHidden(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    // MARK: - UI
    fileprivate func setupUI() {
        navigationItem.title = "填写资料卡"
        view.backgroundColor = UIColor.white
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.showsVerticalScrollIndicator = false
        let headerView = createTBheaderView()
        headerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: 93)
        tableView.tableHeaderView = headerView
        let footerView = createUploadView()
        footerView.frame = CGRect(x: 0, y: 0, width: mp_screenW, height: calculateUploadViewHeight())
        tableView.tableFooterView = footerView
        view.addSubview(bgView)
        view.addSubview(editView)
        editView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(editViewH)
        }
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    fileprivate func createTBheaderView() -> UIView {
        let tbView = UIView()
        nameTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "姓名", textColor: UIColor.mpDarkGray)
        idCardTitleLabel = UILabel(font: UIFont.mpSmallFont, text: "身份证号", textColor: UIColor.mpDarkGray)
        nameLabel = UILabel(font: UIFont.mpSmallFont, text: "请输入姓名", textColor: UIColor.mpLightGary)
        idCardNumberLabel = UILabel(font: UIFont.mpSmallFont, text: "请输入身份证号", textColor: UIColor.mpLightGary)
        let line1 = MPUtils.createLine(UIColor.colorWithHexString("f2f2f2"))
        let line2 = MPUtils.createLine(UIColor.colorWithHexString("f2f2f2"))
        tbView.addSubview(nameTitleLabel)
        tbView.addSubview(idCardTitleLabel)
        tbView.addSubview(nameLabel)
        tbView.addSubview(idCardNumberLabel)
        tbView.addSubview(line1)
        tbView.addSubview(line2)
        
        nameTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(12)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameTitleLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
        line1.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTitleLabel)
            make.width.equalTo(mp_screenW - 30)
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(1)
        }
        idCardTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameTitleLabel)
            make.top.equalTo(line1.snp.bottom).offset(12)
        }
        idCardNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(idCardTitleLabel)
            make.trailing.equalToSuperview().offset(-15)
        }
        line2.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(idCardTitleLabel.snp.bottom).offset(12)
            make.height.equalTo(10)
        }
        let control1 = UIControl()
        control1.addTarget(self, action: #selector(MPProfileViewController.editName), for: .touchUpInside)
        let control2 = UIControl()
        control2.addTarget(self, action: #selector(MPProfileViewController.editIDCard), for: .touchUpInside)
        tbView.addSubview(control1)
        tbView.addSubview(control2)
        control1.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(line1.snp.top)
        }
        control2.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(line1.snp.bottom)
            make.bottom.equalTo(line2.snp.top)
        }
        return tbView
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
        let titleLabel = UILabel(font: UIFont.mpSmallFont, text: "上传图片", textColor: UIColor.mpDarkGray)
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
        submitButton.addTarget(self, action: #selector(MPProfileViewController.submit), for: .touchUpInside)
        submitButton.setTitle("提交", for: .normal)
        submitButton.titleLabel?.font = UIFont.mpBigFont
        submitButton.setupCorner(4)
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
        item.addTarget(self, action: #selector(MPProfileViewController.selectPic(item:)), for: .touchUpInside)
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
    
    @objc func keyboardShow(noti: Notification) {
        guard let info = noti.userInfo else {
            return
        }
        bgView.isHidden = false
        if let duration = info["UIKeyboardAnimationDurationUserInfoKey"] as? Double,
            let keyboardFrame = info["UIKeyboardFrameEndUserInfoKey"] as? CGRect {
            let h = keyboardFrame.height + editViewH
            UIView.animate(withDuration: duration) {
                self.editView.transform = CGAffineTransform.init(translationX: 0, y: -h)
            }
        }
    }
    
    @objc func keyboardHidden(noti: Notification) {
        if let duration = noti.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double {
            UIView.animate(withDuration: duration) {
                self.editView.transform = CGAffineTransform.identity
            }
        }
        bgView.isHidden = true
    }
    
    @objc fileprivate func editName() {
        editView.setKeyBoardType(.default)
        var text = nameLabel.text ?? ""
        if text == "请输入姓名" {
            text = ""
        }
        editView.showKeyBoard(text, title: "姓名") { [weak self] (name) in
            self?.nameLabel.text = name
        }
    }
    
    @objc fileprivate func editIDCard() {
        editView.setKeyBoardType(.numberPad)
        var text = idCardNumberLabel.text ?? ""
        if text == "请输入身份证号" {
            text = ""
        }
        editView.showKeyBoard(text, title: "身份证号码") { [weak self] (idCardNum) in
            var num = idCardNum ?? ""
            if num.isEmpty {
               num = "请输入身份证号"
            }
            self?.idCardNumberLabel.text = num
        }
    }
    
    @objc fileprivate func remove() {
        editView.hideKeyBoard()
        bgView.isHidden = true
    }
    
    @objc fileprivate func submit() {
        if nameLabel.text == "请输入姓名" {
            MPTipsView.showMsg("请输入姓名")
            return
        }
        if idCardNumberLabel.text == "请输入身份证号" {
            MPTipsView.showMsg("请输入身份证号")
            return
        }
        for item in uploadItemArr {
            if item.image == nil {
                MPTipsView.showMsg("请选择对应的照片")
                return
            }
        }
        let hud = MPTipsView.showLoadingView("正在上传")
        MPNetword.requestJson(target: .completeDriverInfo(name: nameLabel.text!, idCard: idCardNumberLabel.text!, pic_idcard_front: uploadItemArr[0].image!, pic_idcard_back: uploadItemArr[1].image!, pic_driver: uploadItemArr[2].image!, pic_user: uploadItemArr[3].image!, pic_drive_front: uploadItemArr[4].image!, pic_drive_back: uploadItemArr[5].image!), success: { (_) in
            hud?.hide(animated: true)
            self.navigationController?.popViewController(animated: true)
            MPUserModel.shared.is_driverinfo = true
        }) { (_) in
            MPTipsView.showMsg("上传失败，请稍后再试")
            hud?.hide(animated: true)
        }
    }
    
    // MARK: - View
    fileprivate var tableView: UITableView!
    fileprivate var nameTitleLabel: UILabel!
    fileprivate var nameLabel: UILabel!
    fileprivate var idCardTitleLabel: UILabel!
    fileprivate var idCardNumberLabel: UILabel!
    fileprivate lazy var bgView: UIControl = {
        let view = UIControl()
        view.isHidden = true
        view.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.3)
        view.addTarget(self, action: #selector(MPProfileViewController.remove), for: .touchDown)
        return view
    }()
    fileprivate lazy var editView: MPEditView = {
        let tv = MPEditView()
        return tv
    }()
}

extension MPProfileViewController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        editingItem?.image = photos.first
    }
}


/// 上传图片的View
class MPUploadImageView: UIControl {
    var image: UIImage? {
        didSet {
            hudView.isHidden = true
            imageView.image = image
        }
    }
    /// 标题
    fileprivate(set) var title: String
    /// 占位图片
    fileprivate var placeHolder: UIImage
    
    init(placeHolder: UIImage, title: String) {
        self.placeHolder = placeHolder
        self.title = title
        super.init(frame: CGRect.zero)
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = placeHolder
        titleLabel = UILabel(font: UIFont.mpXSmallFont, text: title, textColor: UIColor.mpDarkGray)
        hudView = UIView()
        hudView.isUserInteractionEnabled = false
        hudView.backgroundColor = UIColor.colorWithHexString("000000", alpha: 0.5)
        addSubview(imageView)
        addSubview(hudView)
        addSubview(titleLabel)
        imageView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
        hudView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(4)
            make.top.equalTo(imageView.snp.bottom).offset(4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate var hudView: UIView!
    fileprivate var imageView: UIImageView!
    fileprivate var titleLabel: UILabel!
}
