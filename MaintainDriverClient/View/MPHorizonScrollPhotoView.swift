//
//  MPHorizonScrollPhotoView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 水平滚动的图片View
class MPHorizonScrollPhotoView: UIView {
    fileprivate let CellID = "MPHorizonScrollPhotoItemCell"
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
        let vSpace: CGFloat = 10
        let hSpcace: CGFloat = 15
        let itemW: CGFloat = (MPUtils.screenW - 3 * hSpcace) * 0.5
        let itemH: CGFloat = 150
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: itemW, height: itemH)
        flow.minimumInteritemSpacing = vSpace
        flow.minimumLineSpacing = hSpcace
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(MPHorizonScrollPhotoItemCell.classForCoder(), forCellWithReuseIdentifier: CellID)
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
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID, for: indexPath)
        return cell
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
        removeButton = MPImageButtonView(image: #imageLiteral(resourceName: "delete"), pos: .rightTop)
        removeButton.addTarget(self, action: #selector(MPHorizonScrollPhotoItemCell.remove), for: .touchUpInside)
        photoView = UIImageView()
        photoView.backgroundColor = UIColor.colorWithHexString("#ff0000", alpha: 0.3)
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 13), text: "有效期内交的强险保单副本", textColor: UIColor.darkGray)
        contentView.addSubview(photoView)
        contentView.addSubview(removeButton)
        contentView.addSubview(titleLabel)
        let hSpcace: CGFloat = 15
        let itemW: CGFloat = (MPUtils.screenW - 3 * hSpcace) * 0.5
        let itemH: CGFloat = 150 - 35
        photoView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(itemW)
            make.height.equalTo(itemH)
        }
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
        
    }
    
    fileprivate var removeButton: MPImageButtonView!
    fileprivate var photoView: UIImageView!
    fileprivate var titleLabel: UILabel!
}

/// 专门为那些图片小，但是触摸区域要大的图片按钮设计的View
class MPImageButtonView: UIControl {
    var image: UIImage?
    init(image: UIImage?, pos: MPImageButtonPositionType) {
        super.init(frame: CGRect.zero)
        imageView = UIImageView()
        imageView.image = image
        self.image = image
        addSubview(imageView)
        switch pos {
        case .center:
            imageView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
            }
        case .rightTop:
            imageView.snp.makeConstraints { (make) in
                make.top.trailing.equalToSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate var imageView: UIImageView!
}

enum MPImageButtonPositionType {
    /// 居中
    case center
    /// 右上
    case rightTop
}