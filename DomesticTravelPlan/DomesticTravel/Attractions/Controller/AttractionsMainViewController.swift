//
//  AttractionsMainViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/27.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

class AttractionsMainViewController: DomesticBaseViewController {

    @IBOutlet var views: AttractionsMainViews!

    private let viewModel = AttractionsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewAndRegisterXib()
        if GlobalUtil.attractionsSequence.count == 0 {
            requestAttractionsDataToObject()
        } else {
            setAttractionsData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.views.mCollectionView.reloadSections(IndexSet(integer: 0))
    }

    private func setupCollectionViewAndRegisterXib() {
        views.mCollectionView.dataSource = self
        views.mCollectionView.delegate = self
        views.mCollectionView.register(AttractionsMainContainCell.nib, forCellWithReuseIdentifier: "AttractionsMainContainCell")
        views.mCollectionView.register(DomesticSearchCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticSearchCollectionViewCell")
    }

    private func requestAttractionsDataToObject() {
        viewModel.requestAttractionsData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            guard result else { return }
            self.setAttractionsData()
        }, onError: { error in
            print(error)
        }).disposed(by: bag)
    }
    
    private func setAttractionsData() {
        viewModel.setAttractionsData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            guard result else { return }
            self.views.mCollectionView.reloadData()
        }).disposed(by: bag)
    }

    /// 隱藏鍵盤
    @objc private func didClickView() {
        if let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DomesticSearchCollectionViewCell {
            cell.searchTextField.resignFirstResponder()
        }
    }
}

// MARK: - UITableViewDelegate
extension AttractionsMainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.collectionSection.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .search:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticSearchCollectionViewCell", for: indexPath) as! DomesticSearchCollectionViewCell
            cell.delegate = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttractionsMainContainCell", for: indexPath) as! AttractionsMainContainCell
            guard viewModel.search(index: indexPath.section - 1).count > 0 else { return cell }
            let data = viewModel.search(index: indexPath.section - 1)
            let title = viewModel.collectionSection[indexPath.section].rawValue
            cell.config(data: data, title: title, vc: self)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .search:
            return CGSize(width: screenWidth, height: 78)
        default:
            let data = viewModel.search(index: indexPath.section - 1)
            return data.count == 0 ? CGSize(width: collectionView.frame.width, height: 0) : CGSize(width: collectionView.frame.width, height: GlobalUtil.calculateWidthScaleWithSize(width: 450))
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sections = viewModel.collectionSection[section]
        switch sections {
        case .search:
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        default:
            return UIEdgeInsets(top: 5, left: 0, bottom: 10, right: 0)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didClickView()
    }
}

// MARK: - AttractionsMainContainCellProtocol
extension AttractionsMainViewController: AttractionsMainContainCellProtocol {
    func didClickCell(data: AttractionsInfo) {
        let vc = UIStoryboard.loadAttractionsResultViewController(model: data)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - DomesticSearchCollectionViewCellProtocol
extension AttractionsMainViewController: DomesticSearchCollectionViewCellProtocol {

    func clickTypeCell(indexPath: IndexPath) { }

    func clickAreaCell(text: String) { }

    func search(title: String) {
        viewModel.searchTitle = title
        if viewModel.search(index: 0).isEmpty && viewModel.search(index: 1).isEmpty && viewModel.search(index: 2).isEmpty && viewModel.search(index: 3).isEmpty && viewModel.search(index: 4).isEmpty && title != "" {
            toWebSearchInfo(title: title, fromSearch: true)
            viewModel.searchTitle = ""
        }
        views.mCollectionView.reloadData()
    }
}
