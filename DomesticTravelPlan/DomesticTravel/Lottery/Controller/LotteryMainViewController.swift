//
//  LotteryMainViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/10.
//

import UIKit

class LotteryMainViewController: DomesticBaseViewController {

    @IBOutlet var views: LotteryMainViews!

    private let viewModel = LotteryMainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        if GlobalUtil.attractionsSequence.count == 0 {
            requestAttractionsDataToObject()
        }
        if GlobalUtil.delicacySequence.count == 0 {
            requestDelicacyDataToObject()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func setupCollection() {
        views.mCollectionView.dataSource = self
        views.mCollectionView.delegate = self
        views.mCollectionView.register(LotteryMainFilterCell.nib, forCellWithReuseIdentifier: "LotteryMainFilterCell")
        views.mCollectionView.register(LotteryMainResultCell.nib, forCellWithReuseIdentifier: "LotteryMainResultCell")
    }
    
    private func requestDelicacyDataToObject() {
        viewModel.requestDelicacyData().subscribe(onNext: { _ in }).disposed(by: bag)
    }
    
    private func requestAttractionsDataToObject() {
        viewModel.requestAttractionsData().subscribe(onNext: { _ in }).disposed(by: bag)
    }

    /// 隱藏鍵盤
    @objc private func didClickView() {
        if let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? LotteryMainFilterCell {
            cell.searchTextField.resignFirstResponder()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LotteryMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.collectionSection.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = viewModel.collectionSection[section]
        switch sections {
        case .filter, .result:
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .filter:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LotteryMainFilterCell", for: indexPath) as! LotteryMainFilterCell
            cell.delegate = self
            return cell
        case .result:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LotteryMainResultCell", for: indexPath) as! LotteryMainResultCell
            cell.config(hotel: viewModel.hotelData, attractions: viewModel.attractionsData, delicacy: viewModel.delicacyData)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = viewModel.collectionSection[indexPath.section]
        guard sections == .result else { return }
        
        if let data = viewModel.hotelData {
            let vc = UIStoryboard.loadHotelSecondViewController(model: data)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let data = viewModel.attractionsData {
            let vc = UIStoryboard.loadAttractionsResultViewController(model: data)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let data = viewModel.delicacyData {
            let vc = UIStoryboard.loadDelicacySecondViewController(model: data)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .filter:
            return CGSize(width: screenWidth, height: GlobalUtil.calculateWidthScaleWithSize(width: 400))
        case .result:
            return CGSize(width: screenWidth, height: GlobalUtil.calculateWidthScaleWithSize(width: 350))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sections = viewModel.collectionSection[section]
        switch sections {
        case .filter:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .result:
            return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didClickView()
    }
}

// MARK: - UICollectionViewDelegate
extension LotteryMainViewController: LotteryMainFilterCellProtocol {
    func search(hotel: HotelInfo?, attractions: AttractionsInfo?, delicacy: DelicacyInfo?) {
        viewModel.hotelData = hotel
        viewModel.attractionsData = attractions
        viewModel.delicacyData = delicacy
        views.mCollectionView.reloadSections(IndexSet(integer: 1))
    }
}
