//
//  DelicacyMainViewController.swift
//  Delicacy
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import RxSwift

class DelicacyMainViewController: DomesticBaseViewController {
    
    @IBOutlet var views: DelicacyMainViews!
    
    private let viewModel = DelicacyMainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
        
        if GlobalUtil.delicacySequence.count == 0 {
            requestDelicacyDataToObject()
        } else {
            setDelicacyData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.views.mCollectionView.reloadSections(IndexSet(integer: 1))
    }
    
    private func requestDelicacyDataToObject() {
        viewModel.requestDelicacyData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            guard result else { return }
            self.setDelicacyData()
        }).disposed(by: bag)
    }
    
    private func setDelicacyData() {
        viewModel.setDelicacyData().subscribe(onNext: { [weak self] (result) in
            guard let `self` = self else { return }
            guard result else { return }
            self.views.mCollectionView.reloadData()
        }).disposed(by: bag)
    }
    
    private func setupCollection() {
        views.mCollectionView.dataSource = self
        views.mCollectionView.delegate = self
        views.mCollectionView.register(DelicacyTopCollectionViewCell.nib, forCellWithReuseIdentifier: "DelicacyTopCollectionViewCell")
        views.mCollectionView.register(DelicacyMainCollectionViewCell.nib, forCellWithReuseIdentifier: "DelicacyMainCollectionViewCell")
        views.mCollectionView.register(DomesticSearchCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticSearchCollectionViewCell")
    }
    
    /// 隱藏鍵盤
    @objc private func didClickView() {
        if let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DomesticSearchCollectionViewCell {
            cell.searchTextField.resignFirstResponder()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension DelicacyMainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.collectionSection.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = viewModel.collectionSection[section]
        switch sections {
        case .select, .search:
            return 1
        case .data:
            let model = viewModel.whichModel()
            return model.count > 0 ? model.count : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .select:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DelicacyTopCollectionViewCell", for: indexPath) as! DelicacyTopCollectionViewCell
            cell.delegate = self
            return cell
        case .search:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticSearchCollectionViewCell", for: indexPath) as! DomesticSearchCollectionViewCell
            cell.delegate = self
            return cell
        case .data:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DelicacyMainCollectionViewCell", for: indexPath) as! DelicacyMainCollectionViewCell
            let model: DelicacyInfo = viewModel.whichModel()[indexPath.item]
            cell.config(model: model)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .data:
            let model = viewModel.whichModel()[indexPath.item]
            let vc = UIStoryboard.loadDelicacySecondViewController(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sections = viewModel.collectionSection[indexPath.section]
        switch sections {
        case .select:
            return CGSize(width: screenWidth, height: 40)
        case .search:
            return CGSize(width: screenWidth, height: 78)
        case .data:
            return CGSize(width: screenWidth, height: 80)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sections = viewModel.collectionSection[section]
        switch sections {
        case .select, .search:
            return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        case .data:
            return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didClickView()
    }
}

// MARK: - DelicacyTopCollectionViewCellProtocol
extension DelicacyMainViewController: DelicacyTopCollectionViewCellProtocol {
    
    func clickType(index: IndexPath) {
        viewModel.types = DataType(rawValue: index.item)!
        if viewModel.searchTitle != "" {
            viewModel.search(title: viewModel.searchTitle)
        }
        views.mCollectionView.reloadData()
    }
}

// MARK: - DomesticSearchCollectionViewCellProtocol
extension DelicacyMainViewController: DomesticSearchCollectionViewCellProtocol {

    func clickTypeCell(indexPath: IndexPath) { }
    
    func clickAreaCell(text: String) { }

    func search(title: String) {
        if title == "", let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DelicacyTopCollectionViewCell {
            cell.isSelect = 0
            cell.sCollectionView.reloadData()
        }
        
        viewModel.searchTitle = title
        viewModel.search(title: title)
        
        if viewModel.searchData.isEmpty && title != "" {
            toWebSearchInfo(title: title, fromSearch: true)
            viewModel.searchTitle = ""
            viewModel.search(title: "")
            if let cell = self.views.mCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DelicacyTopCollectionViewCell {
                cell.isSelect = 0
                cell.sCollectionView.reloadData()
            }
        }
        views.mCollectionView.reloadData()
    }
}
