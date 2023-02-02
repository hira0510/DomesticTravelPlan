//
//  RoundCornersLabel.swift
//  JJKK
//
//  Created by  on 2018/7/2.
//  Copyright © 2018年 . All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class RoundCornersLabel: UILabel {
    private var firstInit: Bool = false

    /**
     左上角圓角
     */
    @IBInspectable var LeftTop: Bool = false

    /**
     左下角圓角
     */
    @IBInspectable var LeftBotton: Bool = false

    /**
     右上角圓角
     */
    @IBInspectable var RightTop: Bool = false

    /**
     右下角圓角
     */
    @IBInspectable var RightBottom: Bool = false

    /**
     圓角比例，預設為0.5，代表正圓形
     */
    @IBInspectable var RoundCornersRatio: CGFloat = 0.5

    /**
     邊框寬度
     要大於0才會有邊框效果
     */
    @IBInspectable var BorderWidth: CGFloat = 0

    /**
     邊框顏色
     */
    @IBInspectable var BorderColor: UIColor = UIColor.clear

    /**
     圓角的遮罩Layer
     */
    private var roundCornersMask: CAShapeLayer? = nil

    /**
     邊框Layer
     */
    private var borderLayer: CAShapeLayer? = nil

    /**
     對上距離
     */
    @IBInspectable var topInset: CGFloat = 0.0

    /**
     對下距離
     */
    @IBInspectable var bottomInset: CGFloat = 0.0

    /**
     對左距離
     */
    @IBInspectable var leftInset: CGFloat = 0.0

    /**
     對右距離
     */
    @IBInspectable var rightInset: CGFloat = 0.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()

        let cornerRadii = self.bounds.height * RoundCornersRatio

        var RoundingCorners: UInt = 0

        if LeftTop {
            RoundingCorners = RoundingCorners | UIRectCorner.topLeft.rawValue
        }

        if LeftBotton {
            RoundingCorners = RoundingCorners | UIRectCorner.bottomLeft.rawValue
        }

        if RightTop {
            RoundingCorners = RoundingCorners | UIRectCorner.topRight.rawValue
        }

        if RightBottom {
            RoundingCorners = RoundingCorners | UIRectCorner.bottomRight.rawValue
        }

        //第一次初始化
        if firstInit == false {
            roundCornersMask = CAShapeLayer()

            if let roundCornersMask = roundCornersMask {
                roundCornersMask.path = UIBezierPath(roundedRect: self.bounds,
                                                     byRoundingCorners: UIRectCorner.init(rawValue: RoundingCorners),
                                                     cornerRadii: CGSize(width: cornerRadii, height: cornerRadii)).cgPath

                if BorderWidth > 0 {
                    borderLayer = CAShapeLayer()

                    if let borderLayer = borderLayer {
                        borderLayer.path = roundCornersMask.path
                        borderLayer.fillColor = UIColor.clear.cgColor
                        borderLayer.strokeColor = BorderColor.cgColor
                        borderLayer.lineWidth = BorderWidth

                        self.layer.addSublayer(borderLayer)
                    }
                }
            }

            self.layer.mask = roundCornersMask

            firstInit = true
        }

        //第二次之後調用的話，只改變圓角遮罩與邊框遮罩的Path還有PressMask的Bounds
        //需要這樣做是因為Autolayout會多次調整大小並調用layoutSubviews
        if let roundCornersMask = roundCornersMask {
            roundCornersMask.path = UIBezierPath(roundedRect: self.bounds,
                                                 byRoundingCorners: UIRectCorner.init(rawValue: RoundingCorners),
                                                 cornerRadii: CGSize(width: cornerRadii, height: cornerRadii)).cgPath

            if let borderLayer = borderLayer {
                borderLayer.path = roundCornersMask.path
            }
        }
    }

}
