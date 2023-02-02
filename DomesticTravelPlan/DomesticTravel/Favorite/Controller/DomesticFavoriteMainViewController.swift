//
//  DomesticFavoriteMainViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/9.
//

import UIKit

class DomesticFavoriteMainViewController: DomesticBaseViewController {

    @IBOutlet weak var bgView: UIView!

    public var pageMenu: CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMenu()
    }

    // MARK: - 私有

    private func setupMenu() {

        var controllerArray: [UIViewController] = []

        let vc1 = UIStoryboard.loadDomesticFavoriteViewController(type: .hotel)
        vc1.title = "住宿"
        controllerArray.append(vc1)

        let vc2 = UIStoryboard.loadDomesticFavoriteViewController(type: .attractions)
        vc2.title = "景点"
        controllerArray.append(vc2)

        let vc3 = UIStoryboard.loadDomesticFavoriteViewController(type: .delicacy)
        vc3.title = "餐厅"
        controllerArray.append(vc3)

        let parameters: [CAPSPageMenuOption] = [
                .scrollMenuBackgroundColor(UIColor.clear),
                .viewBackgroundColor(UIColor.clear),
                .bottomMenuHairlineColor(UIColor.clear),
                .selectionIndicatorColor(UIColor(0x7382CF)),
                .selectionIndicatorHeight(3),
                .menuMargin(0.0),
                .menuHeight(42.0),
                .menuItemWidth(self.screenWidth / 3),
                .menuItemFont(UIFont(name: "PingFangTC-Medium", size: 19)!),
                .selectedMenuItemLabelColor(UIColor(0x7382CF)),
                .unselectedMenuItemLabelColor(UIColor(0xAF84D1)),
                .useMenuLikeSegmentedControl(false),
                .centerMenuItems(true),
                .menuItemSeparatorWidth(0.0),
                .menuItemSeparatorPercentageHeight(0.0),
                .isHiddenMenuItemSeparator(true)
        ]
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 0, width: self.bgView.frame.width, height: self.bgView.frame.height), pageMenuOptions: parameters)

        pageMenu?.delegate = self
        self.addChild(pageMenu!)
        self.bgView.addSubview(pageMenu!.view)
        pageMenu?.didMove(toParent: self)
    }
}

// MARK: - CAPSPageMenuDelegate
extension DomesticFavoriteMainViewController: CAPSPageMenuDelegate {
    func didSelectIndex(index: Int) {

    }
}
