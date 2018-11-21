//
//  MPAddPhotoView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/11/20.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import JXPhotoBrowser

protocol MPAddPhotoViewDelegate: class {
    func addPhotoViewNeedReload()
}

class MPAddPhotoView: UIView {
    weak var delegate: MPAddPhotoViewDelegate?
    var photoModelArr: [MPPhotoModel] = [MPPhotoModel]()
    /// 记录对哪个Cell操作
    fileprivate var selectedIndex: Int = 0
    fileprivate let CellID = "MPHorizonScrollPhotoItemCell2"
    
    init() {
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
        let itemH: CGFloat = mp_noTitlePicH
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

extension MPAddPhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = photoModelArr.count
        if count < 6 {
            count += 1
        }
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as? MPHorizonScrollPhotoItemCell
        if indexPath.row < photoModelArr.count {
            cell?.model = photoModelArr[indexPath.row]
            cell?.removeButton.isHidden = false
        }else {
            let model = MPPhotoModel()
            model.image = UIImage(named: "add_pic2")
            cell?.model = model
            cell?.removeButton.isHidden = true
        }
        cell?.index = indexPath.row
        cell?.titleLabel.isHidden = true
        cell?.delegate = self
        return cell!
    }
}

// MARK: - MPHorizonScrollPhotoItemCellDelegate
extension MPAddPhotoView: MPHorizonScrollPhotoItemCellDelegate {
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
        photoModelArr.remove(at: index)
        collectionView.reloadData()
        delegate?.addPhotoViewNeedReload()
    }
    
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
}

// MARK: - UIImagePickerControllerDelegate
extension MPAddPhotoView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if selectedIndex < photoModelArr.count {
                photoModelArr[selectedIndex].image = image
            }else {
                let model = MPPhotoModel()
                model.image = image
                photoModelArr.append(model)
            }
            collectionView.reloadData()
            delegate?.addPhotoViewNeedReload()
        }
    }
}
