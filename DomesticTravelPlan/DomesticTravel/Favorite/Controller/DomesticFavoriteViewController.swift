//
//  DomesticFavoriteViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/6/1.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

enum DomesticFavoriteType {
    case hotel
    case attractions
    case delicacy
}

class DomesticFavoriteViewController: DomesticBaseViewController {

    @IBOutlet var views: DomesticFavoriteViews!
    
    public var favorType: DomesticFavoriteType = .hotel
    private let viewModel = DomesticFavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let _ = self.views.mCollectionView else { return }
        setData()
    }

    private func setupCollection() {        
        views.mCollectionView.dataSource = self
        views.mCollectionView.delegate = self
        views.mCollectionView.register(DomesticFavoriteMainCell.nib, forCellWithReuseIdentifier: "DomesticFavoriteMainCell")
        setData()
    }
    
    private func setData() {
        switch favorType {
        case .hotel:
            let data = viewModel.hotelSqlite.readData()
            viewModel.hotelModels = data
            views.noDataLabel.isHidden = data.count > 0
        case .attractions:
            let data = viewModel.attractionsSqlite.readData()
            viewModel.attractionsModels = data
            views.noDataLabel.isHidden = data.count > 0
        case .delicacy:
            let data = viewModel.delicacySqlite.readData()
            viewModel.delicacyModels = data
            views.noDataLabel.isHidden = data.count > 0
        }
        views.mCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension DomesticFavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch favorType {
        case .hotel:
            return viewModel.hotelModels.count > 0 ? viewModel.hotelModels.count : 0
        case .attractions:
            return viewModel.attractionsModels.count > 0 ? viewModel.attractionsModels.count : 0
        case .delicacy:
            return viewModel.delicacyModels.count > 0 ? viewModel.delicacyModels.count : 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticFavoriteMainCell", for: indexPath) as! DomesticFavoriteMainCell
        switch favorType {
        case .hotel:
            guard viewModel.hotelModels.count > indexPath.item else { return cell }
            cell.config(hotel: viewModel.hotelModels[indexPath.item])
        case .attractions:
            guard viewModel.attractionsModels.count > indexPath.item else { return cell }
            cell.config(attractions: viewModel.attractionsModels[indexPath.item])
        case .delicacy:
            guard viewModel.delicacyModels.count > indexPath.item else { return cell }
            cell.config(delicacy: viewModel.delicacyModels[indexPath.item])
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch favorType {
        case .hotel:
            guard viewModel.hotelModels.count > indexPath.item else { return }
            let vc = UIStoryboard.loadHotelSecondViewController(model: viewModel.hotelModels[indexPath.item])
            self.navigationController?.pushViewController(vc, animated: true)
        case .attractions:
            guard viewModel.attractionsModels.count > indexPath.item else { return }
            let vc = UIStoryboard.loadAttractionsResultViewController(model: viewModel.attractionsModels[indexPath.item])
            self.navigationController?.pushViewController(vc, animated: true)
        case .delicacy:
            guard viewModel.delicacyModels.count > indexPath.item else { return }
            let vc = UIStoryboard.loadDelicacySecondViewController(model: viewModel.delicacyModels[indexPath.item])
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: 80)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
}
