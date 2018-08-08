//
//  MPImageButtonView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 专门为那些图片小，但是触摸区域要大的图片按钮设计的View
class MPImageButtonView: UIControl {
    var image: UIImage?
    /// 指定图片尺寸
    convenience init(image: UIImage?, pos: MPImageButtonPositionType, imageW: CGFloat, imageH: CGFloat) {
        self.init(image: image, pos: pos)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(imageW)
            make.height.equalTo(imageH)
        }
    }
    
    /// 使用图片原始尺寸
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
