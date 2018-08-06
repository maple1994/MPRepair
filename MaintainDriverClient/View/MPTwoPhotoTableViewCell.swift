//
//  MPTwoPhotoTableViewCell.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

/// 有两张图片的Cell
class MPTwoPhotoTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        imageView1 = UIImageView()
        imageView1.backgroundColor = UIColor.colorWithHexString("#00ff00", alpha: 0.3)
        imageView2 = UIImageView()
        imageView2.backgroundColor = UIColor.colorWithHexString("#0000ff", alpha: 0.3)
        contentView.addSubview(imageView1)
        contentView.addSubview(imageView2)
        imageView1.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.top.equalToSuperview()
            make.height.equalTo(120)
        }
        imageView2.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.leading.equalTo(imageView1.snp.trailing).offset(15)
            make.top.equalToSuperview()
            make.width.height.equalTo(imageView1)
        }
    }
    
    fileprivate var imageView1: UIImageView!
    fileprivate var imageView2: UIImageView!

}
