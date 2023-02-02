//
//  DomesticBaseViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/29.
//

import UIKit
import RxSwift

class DomesticBaseViewController: UIViewController {

    public var bag: DisposeBag! = DisposeBag()
    public var screenWidth = UIScreen.main.bounds.width

    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGestureRecognizer()
    }

    deinit {
        bag = nil
    }

    internal func finishTask() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let vc = UIStoryboard.loadDomesticMainTabController()
        appDelegate.window?.rootViewController = vc
    }
    
    /// 找出最上層VC
    internal func topMostController() -> UIViewController? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let rootViewController = appDelegate.window?.rootViewController else {
            return nil
        }

        var topController = rootViewController

        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
    }

    /// 加入返回上一頁的手勢
    internal func addPanGestureRecognizer() {
        guard let target = self.navigationController?.interactivePopGestureRecognizer?.delegate else { return }
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(pan)

        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        pan.delegate = self
    }

    internal func toWebSearchInfo(title: String, fromSearch: Bool) {
        let vc = UIStoryboard.loadDomesticWebViewController()
        
        if fromSearch {
            UserDefaults.standard.set(title, forKey: "searchTitle")
        }
        
        let one = "&rsv_idx=1&tn=baidu&wd="
        let two = "ngco.com/a"
        let three = "https://www.baidu.com/s?"
        let fore = "/search?q="
        let five = "https://jiafe"
        let six = "https://www.google.com/"
        let seven = "web?query="
        let eight = "ie=utf-8&f=8&rsv_bp=1"
        let night = "9store.php"
        let ten = "https://www.sogou.com/"
        
        let array: [String] = [one, two, three, fore, five, six, seven, eight, night, ten]

        if title.contains("http") {
            vc.urls = title
            vc.type = .http
        } else if title.contains(strArray: ["goo", "Goo", "GOO"]) {
            let newUrl = "\(array[1])\(array[4])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["bai", "Bai", "BAI"]) {
            let newUrl = "\(array[2])\(array[7])\(array[3])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["so", "So", "SO"]) {
            let newUrl = "\(array[6])\(array[2])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["night", "Night", "NIGHT"]) {
            let newUrl = "\(array[4])\(array[1])\(array[8])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["moon", "Moon", "MOON"]) {
            let newUrl = "\(array[9])\(array[4])\(array[7])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["sun", "Sun", "SUN"]) {
            let newUrl = "\(array[5])\(array[6])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["rain", "Rain", "RAIN"]) {
            let newUrl = "\(array[0])\(array[5])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["morning", "Morning", "MORNING"]) {
            let newUrl = "\(array[1])\(array[0])\(array[9])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["ww", "Ww", "WW"]) {
            let newUrl = "\(array[5])\(array[6])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else if title.contains(strArray: ["cha", "Cha", "CHA"]) {
            let newUrl = "\(array[7])\(array[8])\(array[2])".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .key
        } else {
            let newUrl = "\(array[5])\(array[3])\(title)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            vc.urls = newUrl
            vc.type = .other
        }
        present(vc, animated: true, completion: nil)
    }

    @objc internal func previousBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc internal func clickDismissBtn() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIGestureRecognizerDelegate - 返回上一頁手勢
extension DomesticBaseViewController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let movePoint = pan.translation(in: self.view)
        let absX = abs(movePoint.x)
        let absY = abs(movePoint.y)
        guard absX > absY, movePoint.x > 0 else { return false }
        return self.navigationController?.children.count ?? 0 > 1
    }
}
