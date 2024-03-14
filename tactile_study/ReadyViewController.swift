//
//  ReadyViewController.swift
//  tactile_study
//
//  Created by doi-macbook on 2023/02/12.
//

import UIKit
import SwiftUI

var filestrData:String = ""
var Detail = [[String]]()
var checkedItems = [String]()
var uncheckedIndexes = [Int]()
var QuestionMode:Int = 0
var RecognizeRange:Float = 0.0

class ReadyViewController: UIViewController {
    
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView! // 新しいスタックビューを追加
    @IBOutlet weak var recognizeRangeSlider: UISlider!
    
    var timer = Timer();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if csvType == 1 {
            do{
                print("FileApp")
                let fileData = try Data(contentsOf: urlC)
                print(String(data: fileData,encoding: .utf8)!)
                filestrData = String(data: fileData,encoding: .utf8)!
            }catch{
                print("error_csv")
            }
        } else {
            print("registApp")
            do{
                let fileData = try Data(contentsOf: URL(fileURLWithPath: url2.appending("/"+filename[fileArrayNumber])))
                print(String(data: fileData,encoding: .utf8)!)
                filestrData = String(data: fileData,encoding: .utf8)!
            }catch{
                print("error_csv")
            }
        }
        /// 読み込んだファイルを１行ずつ格納
        /// この時/r/n1が入ってしまう
        let csvLines = filestrData.components(separatedBy: .newlines)
        ///元々配列に入っているインデックス0を削除
        ///detail reset
        Detail.removeAll()
        for csvData in csvLines {
            if csvData.isEmpty {
                continue
            }
            else{
                var csvDetail = csvData.components(separatedBy: ",")
                csvDetail = csvDetail.map{$0.replacingOccurrences(of: "\\", with: "")}
                csvDetail = csvDetail.map{$0.replacingOccurrences(of: "\"", with: "")}
                Detail.append(csvDetail)
                print(Detail)
            }
        }
        file_exp()
        createCheckboxes()
        
        recognizeRangeSlider.value = 10.39
        // 最大値を設定
        recognizeRangeSlider.maximumValue = 40
        // 最小値を設定
        recognizeRangeSlider.minimumValue = 10.39
        recognizeRangeSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
    }
    
    func file_exp(){
        fileLabel.text = Detail[0][1]
        expLabel.text = Detail[1][1]
    }
    @IBAction func testUISwitch(sender: UISwitch) {
        if sender.isOn {
            sender.accessibilityLabel = "問題モード"
            QuestionMode = 1
        } else {
            QuestionMode = 0
        }
    }

//checkボックス表示
    func createCheckboxes() {
        let detailItem = Array(Detail[4][4...])
        
        for item in detailItem {
            let button = UIButton(type: .system)
            button.setTitle("\(item) ☐", for: .normal)
            button.addTarget(self, action: #selector(checkboxTapped(sender:)), for: .touchUpInside)

            let stackViewRow = UIStackView()
            stackViewRow.axis = .horizontal
            stackViewRow.alignment = .center
            stackViewRow.spacing = 8

            stackViewRow.addArrangedSubview(button)
            stackView.addArrangedSubview(stackViewRow)
        }
    }
    
    @objc func checkboxTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = stackView.arrangedSubviews.firstIndex(of: sender.superview!)
        if sender.isSelected {
            print("Checked: \(index ?? -1)")
            checkedItems.append("\(index ?? -1)")
        } else {
            print("Unchecked: \(index ?? -1)")
            if let index = checkedItems.firstIndex(of: "\(index ?? -1)") {
                checkedItems.remove(at: index)
            }
        }
    }
    // チェックされている項目を取得するメソッド
    // チェックされている項目を取得するメソッド
      func getCheckedItems() -> [String] {
          return checkedItems
      }
//      @IBAction func StudyStart(_ sender: Any) {
//          StudyRow = getCheckedItems()
//          print(StudyRow)
//      }
    @IBAction func StudyStart(_ sender: Any) {
        uncheckedIndexes = getUncheckedItems()
        print(uncheckedIndexes)
    }
    // チェックされていない項目を取得するメソッド
    func getUncheckedItems() -> [Int] {
        // すべての項目のインデックスを保持する配列
        var allIndexes = [Int]()
        // チェックされている項目のインデックスを取得
        var checkedIndexes = getCheckedItems().compactMap { Int($0) }
        let numberToAdd = 4
        checkedIndexes = checkedIndexes.map { $0 + numberToAdd }
        print("check",checkedIndexes)
        // 全体の項目数を取得
        let itemCount = Detail[4][4...].count
        print("Detail[4...]",Detail[4...])
        print(itemCount)
        // すべての項目のインデックスを生成
        for index in 4..<itemCount + 4 {
            allIndexes.append(index)
        }
        // チェックされている項目のインデックスを取り除く
        uncheckedIndexes = allIndexes.filter { !checkedIndexes.contains($0) }
        return uncheckedIndexes
        print(uncheckedIndexes)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        // Sliderの値が変更されたら変数に格納
        RecognizeRange = round(sender.value * 100) / 100 // 少数第2位までに制限
        print(RecognizeRange)
        recognizeRangeSlider.accessibilityValue = "\(RecognizeRange)"
        }
}
