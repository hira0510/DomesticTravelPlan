//
//  AttractionsResultViewController.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/28.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import Kingfisher

class AttractionsResultViewController: DomesticBaseViewController {

    @IBOutlet var views: AttractionsResultViews!
    
    var attractionsData: AttractionsInfo?
    
    private var favoritesData: [AttractionsInfo] = {
        return UserDefaults.standard.object(forKey: "AttractionsFavoriteData") as? [AttractionsInfo] ?? []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollection()
    }

    private func setupCollection() {
        views.dismissButton.addTarget(self, action: #selector(previousBack), for: .touchUpInside)
        views.mCollectionView.dataSource = self
        views.mCollectionView.delegate = self
        views.mCollectionView.register(DomesticImageCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticImageCollectionViewCell")
        views.mCollectionView.register(DomesticLabelCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticLabelCollectionViewCell")
        views.mCollectionView.register(HotelBlankCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HotelBlankCollectionReusableView")
    }
}

// MARK: - UICollectionViewDelegate
extension AttractionsResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let model = attractionsData else { return 2 }
        if model.image2 != "" && model.image3 != "" {
            return 4
        } else if model.image2 != "" || model.image3 != "" {
            return 3
        } else {
            return 2
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == collectionView.numberOfSections - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticLabelCollectionViewCell", for: indexPath) as! DomesticLabelCollectionViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticImageCollectionViewCell", for: indexPath) as! DomesticImageCollectionViewCell
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let model = attractionsData else { return }
        let image: [String] = [model.image1, model.image2, model.image3]
        if indexPath.section == collectionView.numberOfSections - 1 {
            let cell = cell as! DomesticLabelCollectionViewCell
            cell.attractionsConfigCell(model: model)
            cell.delegate = self
        } else {
            let cell = cell as! DomesticImageCollectionViewCell
            cell.configCell(img: image[indexPath.section])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == collectionView.numberOfSections - 1 {
            return CGSize(width: screenWidth, height: 470)
        } else {
            return CGSize(width: screenWidth, height: 230)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == collectionView.numberOfSections - 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HotelBlankCollectionReusableView", for: indexPath)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 15)
    }
}

// MARK: - HotelAddressProtocol
extension AttractionsResultViewController: HotelAddressProtocol {
    
    func clickAddBtn(px: Double, py: Double) {
        let view = DomesticMapView(frame: UIScreen.main.bounds, px: px, py: py)
        self.tabBarController?.view.addSubview(view)
    }
    
    func clickWebBtn(url: String) {
        toWebSearchInfo(title: url, fromSearch: false)
    }
}
