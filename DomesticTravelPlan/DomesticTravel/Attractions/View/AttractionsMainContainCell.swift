//
//  AttractionsMainContainCell.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/7/30.
//

import UIKit

protocol AttractionsMainContainCellProtocol: AnyObject {
    func didClickCell(data: AttractionsInfo)
}

class AttractionsMainContainCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    private var mData: [AttractionsInfo] = []
    private weak var delegate: AttractionsMainContainCellProtocol?
    
    static var nib: UINib {
        return UINib(nibName: "AttractionsMainContainCell", bundle: Bundle(for: self))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        mCollectionView.register(AttractionsMainCell.nib, forCellWithReuseIdentifier: "AttractionsMainCell")
        mCollectionView.reloadData()
    }
    
    func config(data: [AttractionsInfo], title: String, vc: AttractionsMainViewController) {
        mData = data
        titleLabel.text = title
        delegate = vc
        mCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension AttractionsMainContainCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttractionsMainCell", for: indexPath) as! AttractionsMainCell
        guard mData.count > indexPath.item else { return cell }
        let model = mData[indexPath.item]
        cell.configCell(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard mData.count > indexPath.item else { return }
        delegate?.didClickCell(data: mData[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: GlobalUtil.calculateWidthScaleWithSize(width: 160), height: GlobalUtil.calculateWidthScaleWithSize(width: 190))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}
