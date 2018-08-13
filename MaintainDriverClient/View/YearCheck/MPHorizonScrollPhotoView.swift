//
//  MPHorizonScrollPhotoView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

/// 水平滚动的图片View
class MPHorizonScrollPhotoView: UIView {
    fileprivate let CellID = "MPHorizonScrollPhotoItemCell"
    fileprivate var pictureCount: Int
    fileprivate var isShowTitle: Bool
    init(count: Int, isShowTitle: Bool) {
        pictureCount = count
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
        let vSpace: CGFloat = 10
        let hSpcace: CGFloat = 15
        let itemW: CGFloat = (MPUtils.screenW - 3 * hSpcace) * 0.5
        mp_noTitlePicH = itemW * 0.63
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
        return pictureCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath) as? MPHorizonScrollPhotoItemCell
        cell?.titleLabel.isHidden = !isShowTitle
        return cell!
    }
}

/// MPHorizonScrollPhotoView的cell
class MPHorizonScrollPhotoItemCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        contentView.backgroundColor = UIColor.colorWithHexString("#ff0000", alpha: 0.3)
        removeButton = MPImageButtonView(image: #imageLiteral(resourceName: "delete"), pos: .rightTop)
        removeButton.addTarget(self, action: #selector(MPHorizonScrollPhotoItemCell.remove), for: .touchUpInside)
        photoView = UIButton()
        photoView.setImage(#imageLiteral(resourceName: "add_pic"), for: .normal)
        photoView.adjustsImageWhenHighlighted = false
        photoView.addTarget(self, action: #selector(MPHorizonScrollPhotoItemCell.pickPicture), for: .touchUpInside)
        titleLabel = UILabel(font: UIFont.mpXSmallFont, text: "有效期内交的强险保单副本", textColor: UIColor.mpDarkGray)
        contentView.addSubview(photoView)
        contentView.addSubview(removeButton)
        contentView.addSubview(titleLabel)
        let hSpcace: CGFloat = 15
        let itemW: CGFloat = (MPUtils.screenW - 3 * hSpcace) * 0.5
        let itemH: CGFloat = mp_hasTitlePicH - 35
        photoView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(itemW)
            make.height.equalTo(itemH)
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
        photoView.setImage(#imageLiteral(resourceName: "add_pic"), for: .normal)
        removeButton.isHidden = true
    }
    
    @objc func pickPicture() {
        let vc = TZImagePickerController(maxImagesCount: 1, columnNumber: 3, delegate: self)!
        vc.showSelectBtn = false
        vc.allowPreview = false
        vc.preferredLanguage = "zh-Hans"
        vc.naviBgColor = UIColor.navBlue
        vc.allowTakeVideo = false
        vc.allowPickingVideo = false
        let nav = ((UIApplication.shared.keyWindow?.rootViewController as? SlideMenuController)?.mainViewController as? UINavigationController)?.topViewController
        nav?.present(vc, animated: true, completion: nil)
    }
    
    var removeButton: MPImageButtonView!
    var photoView: UIButton!
    var titleLabel: UILabel!
}

extension MPHorizonScrollPhotoItemCell: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        guard let image = photos.first else {
            return
        }
        photoView.setImage(image, for: .normal)
        removeButton.isHidden = false
    }
}

class MPUploadImageModel {
    var titleLabel: String?
    var image: UIImage?
}

