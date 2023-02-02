//
//  DomesticLandingViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/29.
//

import UIKit

class DomesticLandingViewController: DomesticBaseViewController {

    @IBOutlet var views: DomesticLandingViews!
    private let viewModel = DomesticLandingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: views.announcementView.bounds)
        label.text = "📢 此软件不代表本团队任何立场 📢"
        label.textColor = UIColor(0x0F4FB7)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont(name: "PingFangTC-Medium", size: 15)
        
        views.announcementView.contentView = label
        views.announcementView.isShimmering = true
        views.announcementView.shimmerSpeed = 400
        views.announcementView.shimmerPauseDuration = 0.4
        
        if let alert = viewModel.versionUpdate(), let vc = topMostController() {
            views.announcementView.isShimmering = false

            DispatchQueue.main.async() {
                vc.present(alert, animated: true, completion: nil)
            }
        } else {
            views.announcementView.isShimmering = true
            
            let mAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            mAnimation.byValue = -(2 * Double.pi)
            mAnimation.duration = 3
            mAnimation.repeatCount = 999
            mAnimation.isRemovedOnCompletion = false
            mAnimation.autoreverses = false
            mAnimation.fillMode = .both
            views.mImageView.layer.add(mAnimation, forKey: "rotation_z")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let `self` = self else { return }
                self.views.mImageView.layer.removeAllAnimations()
                self.finishTask()
            }
        }
    }
}
