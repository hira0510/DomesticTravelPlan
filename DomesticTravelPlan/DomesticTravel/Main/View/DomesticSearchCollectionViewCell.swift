//
//  DomesticSearchCollectionViewCell.swift
//  SearchHotel
//
//  Copyright © 2020 1. All rights reserved.
//

import UIKit

protocol DomesticSearchCollectionViewCellProtocol: AnyObject {
    func clickTypeCell(indexPath: IndexPath)
    func clickAreaCell(text: String)
    func search(title: String)
}

class DomesticSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var historyCollectionView: UICollectionView!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    @IBOutlet weak var typeCollectionView: UICollectionView!

    private let titles: [String] = ["全部", "北部", "中部", "南部", "东部", "其他"]
    private var areaTitles: [String] = ["台北", "新北", "基隆"]
    private var selectType: DataType = .all
    private var selectArea: String = ""
    internal weak var delegate: DomesticSearchCollectionViewCellProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
        searchButton.layer.cornerRadius = 8
    }

    static var nib: UINib {
        return UINib(nibName: "DomesticSearchCollectionViewCell", bundle: nil)
    }

    func configCell(type: DataType, area: String) {
        selectType = type
        selectArea = area
        setSelectData()
        
        historyLabel.text = UserDefaults.standard.stringArray(forKey: "SearchHistory") == nil ? "历史搜索： 尚无" : "历史搜索："
        self.historyCollectionView.reloadData()
        self.typeCollectionView.reloadData()
        self.areaCollectionView.reloadData()
    }

    private func setupCollection() {
        historyCollectionView.dataSource = self
        historyCollectionView.delegate = self
        historyCollectionView.register(DomesticSearchLittleCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticSearchLittleCollectionViewCell")

        typeCollectionView.dataSource = self
        typeCollectionView.delegate = self
        typeCollectionView.register(DomesticSearchCircleCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticSearchCircleCollectionViewCell")

        areaCollectionView.dataSource = self
        areaCollectionView.delegate = self
        areaCollectionView.register(DomesticSearchLittleCollectionViewCell.nib, forCellWithReuseIdentifier: "DomesticSearchLittleCollectionViewCell")

        searchTextField.delegate = self
        searchTextField.enablesReturnKeyAutomatically = true

        searchButton.addTarget(self, action: #selector(didClickSearchBtn), for: .touchUpInside)
    }

    private func setSelectData() {
        switch selectType {
        case .N:
            areaTitles = ["全部", "台北", "新北", "基隆"]
        case .W:
            areaTitles = ["全部", "桃園", "新竹", "苗栗", "彰化", "台中", "南投"]
        case .E:
            areaTitles = ["全部", "台東", "花蓮", "宜蘭"]
        case .S:
            areaTitles = ["全部", "雲林", "嘉義", "台南", "高雄", "屏東"]
        case .other:
            areaTitles = ["全部", "金門", "澎湖", "連江"]
        default: break
        }
    }

    private func saveSearchText(text: String) {
        historyLabel.text = "历史搜索："
        guard var history = UserDefaults.standard.stringArray(forKey: "SearchHistory") else {
            UserDefaults.standard.setValue([text], forKey: "SearchHistory")
            return
        }
        if history.contains(text) {
            for (i, value) in history.enumerated() {
                if value == text {
                    history.remove(at: i)
                    break
                }
            }
        }
        history.insert(text, at: 0)
        UserDefaults.standard.setValue(history, forKey: "SearchHistory")
        self.historyCollectionView.reloadData()
//        self.historyCollectionView.scrollToItem(at: IndexPath.init(), at: .left, animated: false)
    }

    @objc private func didClickSearchBtn() {
        guard let text = searchTextField.text, text != "" else { return }
        FireBaseManager.shard.reportFirebase(domain: "SearchEvent", msg: "点击搜寻", text: text)
        saveSearchText(text: text)
        delegate?.search(title: text)
    }
}

// MARK: - UICollectionViewDelegate
extension DomesticSearchCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == historyCollectionView {
            guard let history = UserDefaults.standard.stringArray(forKey: "SearchHistory") else { return 0 }
            return history.count
        } else if collectionView == typeCollectionView {
            return titles.count
        } else {
            return areaTitles.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == historyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticSearchLittleCollectionViewCell", for: indexPath) as! DomesticSearchLittleCollectionViewCell
            guard let history = UserDefaults.standard.stringArray(forKey: "SearchHistory") else { return cell }
            cell.configCell(title: history[indexPath.item], select: true)
            return cell
        } else if collectionView == typeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticSearchCircleCollectionViewCell", for: indexPath) as! DomesticSearchCircleCollectionViewCell
            cell.configCell(text: titles[indexPath.item], select: selectType.rawValue == indexPath.item)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DomesticSearchLittleCollectionViewCell", for: indexPath) as! DomesticSearchLittleCollectionViewCell
            cell.configCell(title: areaTitles[indexPath.item], select: selectArea == areaTitles[indexPath.item])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == historyCollectionView {
            guard let history = UserDefaults.standard.stringArray(forKey: "SearchHistory"), history.count > indexPath.item else { return }
            let text = history[indexPath.item]
            FireBaseManager.shard.reportFirebase(domain: "SearchEvent", msg: "点击历史", text: text)
            saveSearchText(text: text)
            delegate?.search(title: text)
        } else if collectionView == typeCollectionView {
            delegate?.clickTypeCell(indexPath: indexPath)
        } else {
            delegate?.clickAreaCell(text: areaTitles[indexPath.item])
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == historyCollectionView {
            guard let history = UserDefaults.standard.stringArray(forKey: "SearchHistory"), history.count > indexPath.item else { return .zero }
            let textWidth = history[indexPath.item].textSize(font: UIFont.systemFont(ofSize: 17), maxSize: CGSize(width: 150, height: 25)).width
            return CGSize(width: textWidth + 20, height: 25)
        } else if collectionView == typeCollectionView {
            return CGSize(width: 56, height: 56)
        } else {
            return CGSize(width: 60, height: 25)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == historyCollectionView {
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 15)
        } else {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
        }
    }
}

// MARK: - UITextFieldDelegate
extension DomesticSearchCollectionViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        guard let text = searchTextField.text, text != "" else { return true }
        FireBaseManager.shard.reportFirebase(domain: "SearchEvent", msg: "点击搜寻", text: text)
        saveSearchText(text: text)
        delegate?.search(title: text)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.search(title: "")
        return true
    }
}

extension String {
    
    /// 計算文字Label長度
    ///
    /// - Parameters:
    ///   - font: 字體樣式
    ///   - maxSize: 最大size
    /// - Returns: 回傳CGSize
    func textSize(font: UIFont, maxSize: CGSize) -> CGSize {
        return self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
}
