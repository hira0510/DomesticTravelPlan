//
//  LotteryMainFilterCell.swift
//  DomesticTravelPlan
//
//  Created by  on 2021/8/10.
//

import UIKit

enum LotteryMainFilterWhere {
    case favor
    case other
}

protocol LotteryMainFilterCellProtocol: AnyObject {
    func search(hotel: HotelInfo?, attractions: AttractionsInfo?, delicacy: DelicacyInfo?)
}

class LotteryMainFilterCell: UICollectionViewCell {

    @IBOutlet weak var sloganView: ShimmeringView!
    @IBOutlet weak var whereSegment: UISegmentedControl!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var locationSegment: UISegmentedControl!
    @IBOutlet weak var areaSegment: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var sentConfirmButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    internal weak var delegate: LotteryMainFilterCellProtocol?
    private let hotelSqlite = HotelSQLite()
    private let attractionsSqlite = AttractionsSQLite()
    private let delicacySqlite = DelicacySQLite()
    
    private var areaTitle: String = ""
    private var mType: DomesticFavoriteType = .hotel
    private var mWhere: LotteryMainFilterWhere = .other
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let label = UILabel(frame: sloganView.bounds)
        label.text = "你也有选择困难吗❓ 让我来帮你选择吧~"
        label.textColor = UIColor(0x4250FF)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont(name: "PingFangTC-Medium", size: 16)

        sloganView.contentView = label
        sloganView.isShimmering = true
        sloganView.shimmerSpeed = 200
        sloganView.shimmerPauseDuration = 0.5

        sentConfirmButton.layer.cornerRadius = 8
        clearButton.layer.cornerRadius = 8
        
        sentConfirmButton.addTarget(self, action: #selector(clickSentConfirmBtn), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clickClearBtn), for: .touchUpInside)
        
        whereSegment.addTarget(self, action: #selector(clickSegmentedControl(sender:)), for: .valueChanged)
        typeSegment.addTarget(self, action: #selector(clickSegmentedControl(sender:)), for: .valueChanged)
        locationSegment.addTarget(self, action: #selector(clickSegmentedControl(sender:)), for: .valueChanged)
        areaSegment.addTarget(self, action: #selector(clickSegmentedControl(sender:)), for: .valueChanged)
        
        searchTextField.delegate = self
        searchTextField.enablesReturnKeyAutomatically = true
        clickClearBtn()
    }

    static var nib: UINib {
        return UINib(nibName: "LotteryMainFilterCell", bundle: nil)
    }
    
    /// 重新整理選擇器
    private func setSegment(segment: UISegmentedControl, resetAll: Bool, titles: [String]) {
        if resetAll {
            segment.removeAllSegments()
            segment.insertSegment(withTitle: "全部", at: 0, animated: false)
            segment.selectedSegmentIndex = 0
        }
        
        if titles.count != 0 {
            segment.removeAllSegments()
            for (index, value) in titles.enumerated() {
                segment.insertSegment(withTitle: value, at: index, animated: false)
            }
        }
    }
    
    /// 地區
    /// - Parameter title: 北中南東部
    /// - Returns: 0:繁體+全部 1:簡體
    private func setSelectData(title: String) -> ([String], [String]) {
        switch title {
        case "北部":
            return (["全部", "台北", "新北", "基隆"], ["臺北", "台北", "新北", "基隆"])
        case "中部":
            return (["全部", "桃园", "新竹", "苗栗", "彰化", "台中", "南投"], ["桃園", "新竹", "苗栗", "彰化", "台中", "臺中", "南投"])
        case "南部":
            return (["全部", "云林", "嘉义", "台南", "高雄", "屏东"], ["雲林", "嘉義", "台南", "臺南", "高雄", "屏東"])
        case "东部":
            return (["全部", "台东", "花莲", "宜兰"], ["宜蘭", "花蓮", "臺東", "台東"])
        case "其他":
            return (["全部", "金门", "澎湖", "连江"], ["金門", "澎湖", "連江"])
        default: return (["全部"], [])
        }
    }
    
    /// 點擊送出
    @objc func clickSentConfirmBtn() {
        searchTextField.resignFirstResponder()
        // 地區選擇
        let selectLocal = locationSegment.titleForSegment(at: locationSegment.selectedSegmentIndex)?.big5 ?? ""
        // 地區選擇
        let localText = setSelectData(title: selectLocal).1
        // 地區篩選
        let areaText: String = areaTitle.big5
        // 搜尋字詞篩選
        let searchText: String = searchTextField.text?.big5 ?? ""
        
        switch mType {
        case .hotel:
            let data = mWhere == .favor ? hotelSqlite.readData(): GlobalUtil.hotelSequence
            let local = selectLocal == "全部" ? data: data.filter { $0.add.contains(strArray: localText) || $0.name.contains(strArray: localText) }
            let area = areaTitle == "" || areaTitle == "全部" ? local: local.filter { $0.add.contains(areaText) || $0.name.contains(areaText) }
            let search = searchText == "" ? area: area.filter { $0.add.contains(searchText) || $0.name.contains(searchText) }
            delegate?.search(hotel: search.count > 0 ? search.randomElement(): nil, attractions: nil, delicacy: nil)
        case .attractions:
            let data = mWhere == .favor ? attractionsSqlite.readData(): GlobalUtil.attractionsSequence
            let local = selectLocal == "全部" ? data: data.filter { $0.add.contains(strArray: localText) || $0.name.contains(strArray: localText) }
            let area = areaTitle == "" || areaTitle == "全部" ? local: local.filter { $0.add.contains(areaText) || $0.name.contains(areaText) }
            let search = searchText == "" ? area: area.filter { $0.add.contains(searchText) || $0.name.contains(searchText) }
            delegate?.search(hotel: nil, attractions: search.count > 0 ? search.randomElement(): nil, delicacy: nil)
        case .delicacy:
            let data = mWhere == .favor ? delicacySqlite.readData(): GlobalUtil.delicacySequence
            let local = selectLocal == "全部" ? data: data.filter { $0.add.contains(strArray: localText) || $0.name.contains(strArray: localText) }
            let area = areaTitle == "" || areaTitle == "全部" ? local: local.filter { $0.add.contains(areaText) || $0.name.contains(areaText) }
            let search = searchText == "" ? area: area.filter { $0.add.contains(searchText) || $0.name.contains(searchText) }
            delegate?.search(hotel: nil, attractions: nil, delicacy: search.count > 0 ? search.randomElement(): nil)
        }
    }
    
    /// 點擊清除重選
    @objc func clickClearBtn() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        whereSegment.selectedSegmentIndex = 0
        typeSegment.selectedSegmentIndex = 0
        locationSegment.selectedSegmentIndex = 0
        setSegment(segment: areaSegment, resetAll: true, titles: [])
    }
    
    /// 點擊選擇器
    @objc func clickSegmentedControl(sender: UISegmentedControl) {
        if sender == whereSegment {
            let arr: [LotteryMainFilterWhere] = [.other, .favor]
            mWhere = arr[sender.selectedSegmentIndex]
        } else if sender == typeSegment {
            let arr: [DomesticFavoriteType] = [.hotel, .attractions, .delicacy]
            mType = arr[sender.selectedSegmentIndex]
        } else if sender == locationSegment {
            let localText = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
            setSegment(segment: areaSegment, resetAll: false, titles: setSelectData(title: localText).0)
            areaSegment.selectedSegmentIndex = 0
            areaTitle = ""
        } else if sender == areaSegment {
            areaTitle = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
        }
    }
}

// MARK: - UITextFieldDelegate
extension LotteryMainFilterCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
