//
//  ViewController.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HotelViewController: DomesticBaseViewController {

    @IBOutlet var views: HotelViews!

    private let viewModel = HotelViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        requestHotelDataToObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.views.mCollectionView.reloadSections(IndexSet(integer: 0))
    }

    private func requestHotelDataToObject() {
        viewModel.requestHotelData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self, result else { return }
            self.views.mCollectionView.reloadData()
        }).disposed(by: bag)
    }

    private func setupCollection() {
        views.mCollectionView.dataSource = self
        views.mCollectionView.delegate = self
        views.mCollectionView.register(DomesticSearchCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticSearchCollectionViewCell")
        views.mCollectionView.register(HotelBannerTYCycleCollectionViewCell.nib, forCellWithReuseIdentifier: "HotelBannerTYCycleCollectionViewCell")
        views.mCollectionView.register(HotelCollectionViewCell.nib, forCellWithReuseIdentifier: "HotelCollectionViewCell")
    }

    /// 隱藏鍵盤
    @objc private func didClickView() {
        if let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DomesticSearchCollectionViewCell {
            cell.searchTextField.resignFirstResponder()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HotelViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.collectionSection.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = viewModel.collectionSection[section]
        switch section {
        case .search, .banner: return 1
        case .video:
            let model = viewModel.whichModel()
            return model.count > 0 ? model.count : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .search:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticSearchCollectionViewCell", for: indexPath) as! DomesticSearchCollectionViewCell
            cell.configCell(type: viewModel.types, area: viewModel.areas)
            cell.delegate = self
            return cell
        case .banner:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelBannerTYCycleCollectionViewCell", for: indexPath) as! HotelBannerTYCycleCollectionViewCell
            let model = viewModel.whichModel()
            cell.config(vc: self, banners: model)
            return cell
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotelCollectionViewCell", for: indexPath) as! HotelCollectionViewCell
            guard viewModel.hotelSequence.value.count > 0 else { return cell }
            let model: HotelInfo = viewModel.whichModel()[indexPath.item]
            cell.configCell(data: model)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = viewModel.collectionSection[indexPath.section]

        if let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DomesticSearchCollectionViewCell {
            cell.searchTextField.resignFirstResponder()
        }

        switch sections {
        case .search, .banner: break
        case .video:
            let model = viewModel.whichModel()[indexPath.item]
            let vc = UIStoryboard.loadHotelSecondViewController(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .search:
            let height: CGFloat = viewModel.types == .all || viewModel.types == .search ? 145: 186
            return CGSize(width: screenWidth, height: height)
        case .banner:
            let model = viewModel.whichModel()
            let banner = model.filter { $0.image1 != "" }
            return banner.count > 0 ? CGSize(width: screenWidth, height: 180) : CGSize(width: screenWidth, height: 1)
        case .video:
            return CGSize(width: screenWidth, height: GlobalUtil.calculateWidthScaleWithSize(width: 100))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let section = viewModel.collectionSection[section]
        switch section {
        case .search:
            return UIEdgeInsets(top: 10, left: 0, bottom: 5, right: 0)
        case .banner:
            return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        case .video:
            return UIEdgeInsets(top: 0, left: 5, bottom: 1, right: 5)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didClickView()
    }
}

// MARK: - DomesticSearchCollectionViewCellProtocol
extension HotelViewController: DomesticSearchCollectionViewCellProtocol {

    func clickTypeCell(indexPath: IndexPath) {
        viewModel.areas = "全部"
        viewModel.areaData = []
        viewModel.types = DataType(rawValue: indexPath.item)!
        views.mCollectionView.reloadData()
    }

    func clickAreaCell(text: String) {
        viewModel.areas = text
        viewModel.search(title: text, toSearchMode: false)
        views.mCollectionView.reloadData()
    }

    func search(title: String) {
        viewModel.search(title: title)
        if viewModel.searchData.isEmpty && title != "" {
            toWebSearchInfo(title: title, fromSearch: true)
        }
        views.mCollectionView.reloadData()
    }
}
