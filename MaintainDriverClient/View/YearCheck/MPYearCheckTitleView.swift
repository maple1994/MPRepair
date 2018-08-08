//
//  MPYearCheckTitleView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/6.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPYearCheckTitleViewDelegate: class {
    func yearCheckTitleView(didSelect index: Int)
}

/// 年检TitleView
/// 查看信息，上门取车，开始年检，检完换车
class MPYearCheckTitleView: UIView {
    weak var delegate: MPYearCheckTitleViewDelegate?
    var selectedIndex: Int = 0 {
        didSet {
            itemClick(itemArr[selectedIndex])
        }
    }
    /// 两边间距
    fileprivate let spaceX: CGFloat = 20
    fileprivate let itemW: CGFloat = 65
    fileprivate let itemH: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        item1 = MPYearCheckItemView(icon: #imageLiteral(resourceName: "check_msg_unselcted"), selectedIcon: #imageLiteral(resourceName: "check_msg_selected"), title: "查看信息")
        item2 = MPYearCheckItemView(icon: #imageLiteral(resourceName: "get_car_unselected"), selectedIcon: #imageLiteral(resourceName: "get_car_selected"), title: "上门取车")
        item3 = MPYearCheckItemView(icon: #imageLiteral(resourceName: "year_check_unselected"), selectedIcon: #imageLiteral(resourceName: "year_check_selected"), title: "开始年检")
        item4 = MPYearCheckItemView(icon: #imageLiteral(resourceName: "chechout_finsh_unselected"), selectedIcon: #imageLiteral(resourceName: "chechout_finsh_selected"), title: "检完还车")
        itemArr.append(item1)
        itemArr.append(item2)
        itemArr.append(item3)
        itemArr.append(item4)
        let line1 = MPUtils.createLine()
        let line2 = MPUtils.createLine()
        let line3 = MPUtils.createLine()
        lineArr.append(line1)
        lineArr.append(line2)
        lineArr.append(line3)
        for view in itemArr {
            addSubview(view)
//            view.addTarget(self, action: #selector(MPYearCheckTitleView.itemClick(_:)), for: .touchUpInside)
        }
        for line in lineArr {
            addSubview(line)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // item之间的距离
        let margin: CGFloat = (frame.width - 2 * spaceX - 4 * itemW) / 3
        let itemY: CGFloat = (frame.height - itemH) * 0.5
        var preX: CGFloat = spaceX
        for view in itemArr {
            view.frame = CGRect(x: preX, y: itemY, width: itemW, height: itemH)
            preX = view.frame.maxX + margin
        }
        let lineY: CGFloat = itemY + 13
        for (index, line) in lineArr.enumerated() {
            let leftItem = itemArr[index]
            let rightItem = itemArr[index + 1]
            let x = leftItem.frame.maxX - 8
            let w = rightItem.frame.minX + 8 - x
            line.frame = CGRect(x: x, y: lineY, width: w, height: 1)
        }
    }
    
    @objc fileprivate func itemClick(_ item: MPYearCheckItemView) {
        if let selectedItem = preSelectedItem {
            if selectedItem == item {
                return
            }
        }
        preSelectedItem?.isSelected = false
        item.isSelected = true
        preSelectedItem = item
        selectedIndex = itemArr.index(of: item)!
        delegate?.yearCheckTitleView(didSelect: selectedIndex)
    }
    
    fileprivate var itemArr: [MPYearCheckItemView] = [MPYearCheckItemView]()
    fileprivate var lineArr: [UIView] = [UIView]()
    fileprivate var preSelectedItem: MPYearCheckItemView?
    fileprivate var item1: MPYearCheckItemView!
    fileprivate var item2: MPYearCheckItemView!
    fileprivate var item3: MPYearCheckItemView!
    fileprivate var item4: MPYearCheckItemView!
}

/// MPYearCheckTitleView的子View
class MPYearCheckItemView: UIControl {
    
    fileprivate var normalIcon: UIImage?
    fileprivate var selectedIcon: UIImage?
    var font: UIFont? {
        didSet {
            titleLabel.font = font
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                iconImageView.image = selectedIcon
                titleLabel.textColor = UIColor.navBlue
            }else {
                iconImageView.image = normalIcon
                titleLabel.textColor = UIColor.mpLightGary
            }
        }
    }
    
    init(icon: UIImage?, selectedIcon: UIImage?, title: String?) {
        super.init(frame: CGRect.zero)
        setupUI()
        normalIcon = icon
        self.selectedIcon = selectedIcon
        titleLabel.text = title
        iconImageView.image = icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        iconImageView = UIImageView()
        titleLabel = UILabel(font: UIFont.systemFont(ofSize: 12), text: "查看信息", textColor: UIColor.mpLightGary)
        titleLabel.textAlignment = .center
        addSubview(iconImageView)
        addSubview(titleLabel)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    fileprivate var iconImageView: UIImageView!
    fileprivate var titleLabel: UILabel!
}
