//
//  MPHorizonScrollPhotoView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import JXPhotoBrowser

/// 水平滚动的图片View
class MPHorizonScrollPhotoView: UIView {
    fileprivate let CellID = "MPHorizonScrollPhotoItemCell"
    fileprivate var photoModelArr: [MPPhotoModel]
    fileprivate var isShowTitle: Bool
    /// 记录对哪个Cell操作
    fileprivate var selectedIndex: Int = 0
    
    init(modelArr: [MPPhotoModel], isShowTitle: Bool) {
        photoModelArr = modelArr
        self.isShowTitle = isShowTitle
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        let flow = UICollectionViewFlowLayout()
        let vSpace: CGFloat = mp_vSpace
        let hSpcace: CGFloat = mp_hSpace
        let itemW: CGFloat = mp_picW
        let itemH: CGFloat = isShowTitle ? mp_hasTitlePicH : mp_noTitlePicH
        flow.itemSize = CGSize(width: itemW, height: itemH)
        flow.minimumInteritemSpacing = vSpace
        flow.minimumLineSpacing = hSpcace
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.register(MPHorizonScrollPhotoItemCell.classForCoder(), forCellWithReuseIdentifier: CellID)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.white
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(hSpcace)
            make.trailing.equalToSuperview().offset(-hSpcace)
        }
    }
    
    fileprivate var collectionView: UICollectionView!
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MPHorizonScrollPhotoView: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModelArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as? MPHorizonScrollPhotoItemCell
        cell?.model = photoModelArr[indexPath.row]
        if let _ = cell?.model?.image {
            cell?.removeButton.isHidden = false
        }else {
            cell?.photoView.image = UIImage(named: "add_pic")
            cell?.removeButton.isHidden = true
        }
        cell?.titleLabel.isHidden = !isShowTitle
        cell?.index = indexPath.row
        cell?.delegate = self
        return cell!
    }
}

// MARK: - MPHorizonScrollPhotoItemCellDelegate
extension MPHorizonScrollPhotoView: MPHorizonScrollPhotoItemCellDelegate {
    /// 显示图片浏览器
    func showPhotoBrowser(index: Int) {
        var showIndex = index
        var photoArr = [MPPhotoModel]()
        var count: Int = 0
        for (index1, model) in photoModelArr.enumerated() {
            if index1 == index {
                showIndex = count
            }
            if model.image != nil {
                photoArr.append(model)
                count += 1;
            }
        }
        let dataSource = JXLocalDataSource(numberOfItems: {
            // 共有多少项
            return photoArr.count
        }, localImage: { index -> UIImage? in
            // 每一项的图片对象
            return photoArr[index].image
        })
        // 视图代理，实现了数字型页码指示器
        let delegate = JXNumberPageControlDelegate()
        // 打开浏览器
        JXPhotoBrowser(dataSource: dataSource, delegate: delegate).show(pageIndex: showIndex)
    }
    
    /// 点击了图片
    func itemCellDidClickAddButton(_ cell: MPHorizonScrollPhotoItemCell, index: Int) {
        selectedIndex = index
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.modalPresentationStyle = .fullScreen
        picker.cameraCaptureMode = .photo
        picker.delegate = self
        let nav = ((UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController)?.mainViewController as? UINavigationController)?.topViewController
        nav?.present(picker, animated: true, completion: nil)
    }
    
    /// 去除了图片
    func itemCellDidClickRemoveButton(_ cell: MPHorizonScrollPhotoItemCell, index: Int) {
        if selectedIndex < photoModelArr.count {
            photoModelArr[index].image = nil
        }
        collectionView.reloadData()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MPHorizonScrollPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if selectedIndex < photoModelArr.count {
                photoModelArr[selectedIndex].image = image
            }
            collectionView.reloadData()
        }
    }
}

protocol MPHorizonScrollPhotoItemCellDelegate: class {
    /// 点击了图片
    func itemCellDidClickAddButton(_ cell: MPHorizonScrollPhotoItemCell, index: Int)
    /// 去除了图片
    func itemCellDidClickRemoveButton(_ cell: MPHorizonScrollPhotoItemCell, index: Int)
    /// 显示图片浏览器
    func showPhotoBrowser(index: Int)
}

/// MPHorizonScrollPhotoView的cell
class MPHorizonScrollPhotoItemCell: UICollectionViewCell {
    weak var delegate: MPHorizonScrollPhotoItemCellDelegate?
    var index: Int = 0
    
    var model: MPPhotoModel? {
        didSet {
            if let img = model?.image {
                photoView.image = img
            }else {
                photoView.image = UIImage(named: "add_pic")
            }
            titleLabel.text = model?.title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        removeButton = MPImageButtonView(image: #imageLiteral(resourceName: "delete"), pos: .rightTop)
        removeButton.addTarget(self, action: #selector(MPHorizonScrollPhotoItemCell.remove), for: .touchUpInside)
        photoView = MPImageButtonView(image: UIImage(named: "add_pic"), pos: .center, imageW: mp_picW, imageH: mp_noTitlePicH)
        photoView.addTarget(self, action: #selector(MPHorizonScrollPhotoItemCell.pickPicture), for: .touchUpInside)
        photoView.mode = .scaleAspectFill
        titleLabel = UILabel(font: UIFont.mpXSmallFont, text: "证件信息", textColor: UIColor.mpDarkGray)
        contentView.addSubview(photoView)
        contentView.addSubview(removeButton)
        contentView.addSubview(titleLabel)
        photoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(mp_picW)
            make.height.equalTo(mp_noTitlePicH)
        }
        removeButton.isHidden = true
        removeButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.width.height.equalTo(35)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(photoView.snp.bottom).offset(5).priority(.high)
            make.leading.equalToSuperview().offset(10)
        }
    }
    
    @objc func remove() {
        delegate?.itemCellDidClickRemoveButton(self, index: index)
        removeButton.isHidden = true
//        // 交由代理处理
//        if delegate != nil {
//            return
//        }
//        model?.image = nil
//        photoView.image = UIImage(named: "add_pic")
    }
    
    @objc func pickPicture() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        if removeButton.isHidden == false {
            delegate?.showPhotoBrowser(index: index)
            return
        }
        // 交由代理处理点击事件
        delegate?.itemCellDidClickAddButton(self, index: index)
    }
    
    var removeButton: MPImageButtonView!
    var photoView: MPImageButtonView!
    var titleLabel: UILabel!
}

extension MPHorizonScrollPhotoItemCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            model?.image = image
            photoView.image = image
            removeButton.isHidden = false
        }
    }
}

class MPUploadImageModel {
    var titleLabel: String?
    var image: UIImage?
}

