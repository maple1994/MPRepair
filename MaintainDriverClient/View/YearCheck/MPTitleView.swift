//
//  MPTitleView.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/8/7.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit

protocol MPTitleViewDelegate: class {
    func titleView(didSelect index: Int)
}

/// 显示年检已过，年检未过，维护反馈的titleView
class MPTitleView: UIView {
    
    var selectedIndex: Int?
    weak var delegate: MPTitleViewDelegate?
    func setupSelectedIndex(_ index: Int) {
        if selectedIndex != nil {
            if selectedIndex! == index {
                return
            }
        }
        setupSelected(labelArr[index])
        selectedIndex = index
    }
    
    func setupOffsetX(_ offsetX: CGFloat) {
        if isTouch {
            return
        }
        let firstLabel = labelArr.first!
        let lastLabel = labelArr.last!
        var x = offsetX / CGFloat(labelArr.count)
        if x < firstLabel.frame.origin.x {
            x = firstLabel.frame.origin.x
        }
        if x > lastLabel.frame.maxX - lastLabel.frame.width {
            x = lastLabel.frame.maxX - lastLabel.frame.width
        }
        indicatorLine.frame.origin.x = x
    }
    
    var isTouch: Bool = false
    fileprivate var titleArr: [String]
    fileprivate var labelArr: [UILabel] = [UILabel]()
    fileprivate var margin: CGFloat = 0
    
    init(titleArr: [String]) {
        self.titleArr = titleArr
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.white
        for title in titleArr {
            let label = UILabel(font: UIFont.mpSmallFont, text: title, textColor: UIColor.mpDarkGray)
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(MPTitleView.titileClick(tap:)))
            label.addGestureRecognizer(tap)
            labelArr.append(label)
            addSubview(label)
        }
        topLine = MPUtils.createLine()
        bottomLine = MPUtils.createLine()
        indicatorLine = MPUtils.createLine(UIColor.navBlue)
        addSubview(topLine)
        addSubview(bottomLine)
        addSubview(indicatorLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if labelArr.count == 0 {
            return
        }
        topLine.frame = CGRect(x: 0, y: 0, width: frame.width, height: 1)
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        var labelSizeArr = [CGSize]()
        var totalW: CGFloat = 0
        for label in labelArr {
            let size = label.text!.size(label.font, width: frame.width)
            labelSizeArr.append(size)
            totalW += size.width
        }
        // 计算间隔margin
//        let margin: CGFloat = (frame.width - 2 * spaceX - totalW) / CGFloat(labelArr.count - 1)
        margin = (frame.width - totalW) / CGFloat(labelArr.count + 1)
        
        var preX: CGFloat = margin
        for (index, label) in labelArr.enumerated() {
            let labelSize = labelSizeArr[index]
            label.frame = CGRect(x: preX, y: 0, width: labelSize.width, height: frame.height)
            preX = label.frame.maxX + margin
            if index == 0 {
                label.textColor = UIColor.navBlue
                selectedLabel = label
            }
        }
        let firstLabel = labelArr[0]
        indicatorLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - 2, width: firstLabel.frame.width, height: 2)
    }
    
    fileprivate var topLine: UIView!
    fileprivate var bottomLine: UIView!
    fileprivate var indicatorLine: UIView!
    fileprivate var selectedLabel: UILabel?
    
    @objc fileprivate func titileClick(tap: UIGestureRecognizer) {
        guard let label = tap.view as? UILabel else {
            return
        }
        if let sel = selectedLabel {
            if sel == label {
                return
            }
        }
        setupSelected(label)
    }
    
    fileprivate func setupSelected(_ label: UILabel) {
        UIView.animate(withDuration: 0.25, animations: {
            self.indicatorLine.frame.origin.x = label.frame.origin.x
        })
        selectedLabel?.textColor = UIColor.mpDarkGray
        label.textColor = UIColor.navBlue
        selectedLabel = label
        
        delegate?.titleView(didSelect: labelArr.index(of: label)!)
    }

}
