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
    
    var isTouch: Bool = false
    var selectedIndex: Int = 0
    /// 记录最后上一次偏移量
    var lastOffsetX: CGFloat = 0
    weak var delegate: MPTitleViewDelegate?
    func setupSelectedIndex(_ index: Int) {
        if selectedIndex == index {
            return
        }
        setupSelected(labelArr[index])
        selectedIndex = index
    }
    
    func setupOffsetX(_ offsetX: CGFloat) {
        if isTouch {
            return
        }
        let leftIndex = Int(offsetX / mp_screenW)
        if leftIndex >= labelArr.count {
            return
        }
        let leftLabel = labelArr[leftIndex]
        let rightIndex = leftIndex + 1
        var rightLabel = UILabel()
        if rightIndex < labelArr.count {
            rightLabel = labelArr[rightIndex]
            setupTitleColorGradient(offsetX: offsetX, rightLabel: rightLabel, leftLabel: leftLabel)
            setupUnderLine(offsetX: offsetX, rightLabel: rightLabel, leftLabel: leftLabel)
        }
        lastOffsetX = offsetX
    }

    // MARK: - Property
    fileprivate var titleArr: [String]
    fileprivate var labelArr: [UILabel] = [UILabel]()
    fileprivate var margin: CGFloat = 0
    fileprivate let normalColor = UIColor.mpDarkGray
    fileprivate let selectedColor = UIColor.navBlue
    /**
     开始颜色,取值范围0~1
     */
    fileprivate var startR: CGFloat = 0
    fileprivate var startG: CGFloat = 0
    fileprivate var startB: CGFloat = 0
    
    /**
     完成颜色,取值范围0~1
     */
    fileprivate var endR: CGFloat = 0
    fileprivate var endG: CGFloat = 0
    fileprivate var endB: CGFloat = 0
    
    // MARK: - Method
    init(titleArr: [String]) {
        self.titleArr = titleArr
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("")
    }
    
    fileprivate func setupUI() {
        setupStartColor()
        setupEndColor()
        backgroundColor = UIColor.white
        for (index, title) in titleArr.enumerated() {
            let label = UILabel(font: UIFont.mpSmallFont, text: title, textColor: UIColor.mpDarkGray)
            label.isUserInteractionEnabled = true
            label.tag = 100 + index
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
    
    fileprivate func setupUnderLine(offsetX: CGFloat, rightLabel: UILabel, leftLabel: UILabel) {
        // 获取两个标题中心点距离
        let centerDelta = rightLabel.frame.origin.x - leftLabel.frame.origin.x
        // 标题宽度差值
        let widthDelta = rightLabel.frame.width - leftLabel.frame.width
        // 获取移动距离
        let offsetDelta = offsetX - lastOffsetX
        // 计算当前下划线偏移量
        let underLineTransformX = offsetDelta * centerDelta / UIScreen.main.bounds.width
        let underLineWidth = offsetDelta * widthDelta / UIScreen.main.bounds.width
        indicatorLine.frame.size.width = indicatorLine.frame.size.width + underLineWidth
        indicatorLine.frame.origin.x = indicatorLine.frame.origin.x + underLineTransformX
    }
    
    fileprivate func setupTitleColorGradient(offsetX: CGFloat, rightLabel: UILabel?, leftLabel: UILabel) {
        // 获取右边缩放
        let rightScale: CGFloat = offsetX / mp_screenW - CGFloat(leftLabel.tag - 100)
        let leftScale: CGFloat = 1 - rightScale
        // RGB渐变
        let r = endR - startR
        let g = endG - startG
        let b = endB - startB
        
        let rightColor = UIColor(red: startR + r * rightScale, green: startG + g * rightScale, blue: startB + b * rightScale, alpha: 1)
        
        let leftColor = UIColor(red: startR + r * leftScale, green: startG + g * leftScale, blue: startB + b * leftScale, alpha: 1)
        
        leftLabel.textColor = leftColor
        rightLabel?.textColor = rightColor
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
        let index = labelArr.index(of: label)!
        selectedIndex = index
        delegate?.titleView(didSelect: index)
    }
    
    fileprivate func setupStartColor() {
        if let componets = normalColor.cgColor.components {
            if normalColor.cgColor.numberOfComponents > 3 {
                startR = componets[0]
                startG = componets[1]
                startB = componets[2]
            }else {
                startR = componets[0]
                startG = componets[0]
                startB = componets[0]
            }
        }
    }
    
    fileprivate func setupEndColor() {
        if let componets = selectedColor.cgColor.components {
            endR = componets[0]
            endG = componets[1]
            endB = componets[2]
        }
    }
    
    // MARK: - View
    fileprivate var topLine: UIView!
    fileprivate var bottomLine: UIView!
    fileprivate var indicatorLine: UIView!
    fileprivate var selectedLabel: UILabel?

}
