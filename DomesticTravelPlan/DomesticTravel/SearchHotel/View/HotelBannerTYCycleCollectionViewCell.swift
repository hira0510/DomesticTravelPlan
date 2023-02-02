//
//  HotelBannerTYCycleCollectionViewCell.swift
//
//
//  Created by    on 
//  Copyright . All rights reserved.
//

import UIKit
import TYCyclePagerView

class HotelBannerTYCycleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mUIView: UIView!

    private var mController: HotelViewController?

    private var pagerView: TYCyclePagerView!

    private var mBannersImg: [String] = []
    private var mBannersData: [HotelInfo] = []

    static var nib: UINib {
        return UINib(nibName: "HotelBannerTYCycleCollectionViewCell", bundle: Bundle(for: self))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.pagerView = TYCyclePagerView()
        self.pagerView.isInfiniteLoop = true
        self.pagerView.autoScrollInterval = 3.0
        self.pagerView.dataSource = self
        self.pagerView.delegate = self
        self.pagerView.register(HotelTYCycleCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellId")
        self.pagerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.mUIView.frame.height)
        mUIView.addSubview(self.pagerView)
    }

    public func config(vc: HotelViewController, banners: [HotelInfo]) {
        mController = vc
        mBannersImg.removeAll()
        mBannersData.removeAll()
        
        for banner in banners.shuffled() {
            if mBannersImg.count < 5 && banner.image1 != "" {
                mBannersImg.append(banner.image1)
                mBannersData.append(banner)
            }
        }
        loadData()
    }

    private func loadData() {
        self.pagerView.reloadData()
        self.pagerView.layout.layoutType = .linear
        self.pagerView.setNeedUpdateLayout()
    }
}

// MARK: - TYCyclePagerViewDelegate
extension HotelBannerTYCycleCollectionViewCell: TYCyclePagerViewDelegate, TYCyclePagerViewDataSource {
    func numberOfItems(in pageView: TYCyclePagerView) -> Int {
        return mBannersImg.count
    }

    func pagerView(_ pagerView: TYCyclePagerView, cellForItemAt index: Int) -> UICollectionViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cellId", for: index) as! HotelTYCycleCollectionViewCell
        cell.addImage(url: mBannersImg[index])
        return cell
    }

    func layout(for pageView: TYCyclePagerView) -> TYCyclePagerViewLayout {
        let layout = TYCyclePagerViewLayout()
        layout.itemSize = CGSize(width: pagerView.frame.width * 0.8, height: pagerView.frame.height * 0.89)
        layout.itemSpacing = 8
        layout.itemHorizontalCenter = true

        return layout
    }

    func pagerView(_ pageView: TYCyclePagerView, didSelectedItemCell cell: UICollectionViewCell, at index: Int) {
        guard let parentVc = mController else { return }
        let model: HotelInfo = mBannersData[index]
        let vc = UIStoryboard.loadHotelSecondViewController(model: model)
        parentVc.navigationController?.pushViewController(vc, animated: true)
    }
}
