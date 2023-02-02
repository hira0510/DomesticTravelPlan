//
//  DelicacyTopCollectionViewCell.swift
//  Delicacy
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

protocol DelicacyTopCollectionViewCellProtocol: AnyObject {
    func clickType(index: IndexPath)
}

class DelicacyTopCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var sCollectionView: UICollectionView!
    
    weak var delegate: DelicacyTopCollectionViewCellProtocol?
    let title = ["全部", "北部", "中部", "南部", "东部", "其他"]
    var isSelect: Int = 0
    
    static var nib: UINib {
        return UINib(nibName: "DelicacyTopCollectionViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    private func setupCollection() {
        sCollectionView.dataSource = self
        sCollectionView.delegate = self
        sCollectionView.register(DelicacyTopLittleCell.nib, forCellWithReuseIdentifier: "DelicacyTopLittleCell")
    }
}

// MARK: - UICollectionViewDelegate
extension DelicacyTopCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DelicacyTopLittleCell", for: indexPath) as! DelicacyTopLittleCell
        cell.config(title: title[indexPath.item], isSelect: isSelect == indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isSelect = indexPath.item
        delegate?.clickType(index: indexPath)
        sCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
