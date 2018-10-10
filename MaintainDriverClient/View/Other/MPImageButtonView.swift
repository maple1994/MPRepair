//
//  MPImageButtonView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/8.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Kingfisher

/// 专门为那些图片小，但是触摸区域要大的图片按钮设计的View
class MPImageButtonView: UIControl, KingfisherCompatible {
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    /*
     case scaleAspectFit // contents scaled to fit with fixed aspect. remainder is transparent
     
     case scaleAspectFill // contents scaled to fill with fixed aspect. some portion of content may be clipped.
     */
    var mode: UIViewContentMode = .scaleAspectFill {
        didSet {
            imageView.contentMode = mode
        }
    }
    
    /// 指定图片尺寸
    convenience init(image: UIImage?, pos: MPImageButtonPositionType, imageW: CGFloat, imageH: CGFloat) {
        self.init(image: image, pos: pos)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(imageW)
            make.height.equalTo(imageH)
        }
        imageView.clipsToBounds = true
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
        case .leftTop:
            imageView.snp.makeConstraints { (make) in
                make.top.leading.equalToSuperview()
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
    /// 左上
    case leftTop
}
