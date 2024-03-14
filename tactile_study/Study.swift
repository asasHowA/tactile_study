//
//  Study.swift
//  tactile_study
//
//  Created by doi-macbook on 2023/02/12.
//

import UIKit
import AVFoundation
import Foundation

var XL:Double = 0.0
var YL:Double = 0.0
var theta_o: Double = 0.0
var rotateDetail = [[String]]()
var detailRow:Int = 0
var audioPlayer: AVAudioPlayer?


class Study: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.isNavigationBarHidden = true
     }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    var xEndedTaplist: [Double] = []
    var yEndedTaplist: [Double] = []
    var Count:[Int] = []
    var field:Int = 0
    var xratio:Double = 0.0
    var yratio:Double = 0.0
    var tapxy:String = ""
    var strTapPoint:String = ""
    var kyori:Double = 0.0
    var synthesizer: AVSpeechSynthesizer!
    var voice: AVSpeechSynthesisVoice!
    var randomIndexes: [Int] = []
    var totalColumns: Int = 0
    var totalRows: Int = 0
    var AnswerTime:Bool = false
    var rowIndex:Int = 0
    var columnIndex:Int = 0
    var QuestionNumber:Int = 0
    var CorrectNumber:Int = 0
    var TouchEnable:Bool = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = false
        self.view.isMultipleTouchEnabled = true;

        synthesizer = AVSpeechSynthesizer()
        voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
 
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
        if Detail[2][1].isEmpty || Detail[2][2].isEmpty || Detail[3][1].isEmpty || Detail[3][2].isEmpty == true {
            print("補正点が設定されていません")
            speak("補正点が設定されていません")
        }else{
            XL = Double(Detail[3][1])! - Double(Detail[2][1])!
            YL = Double(Detail[3][2])! - Double(Detail[2][2])!
            theta_o = atan2(XL, YL)
        }
        calc1_rotateDetail()
        for _ in 1...(rotateDetail.count){
            Count.append(0)
        }
        speak("学習を開始できます")
        
        if QuestionMode == 1{
            totalColumns = rotateDetail[0].count - 4
            totalRows = rotateDetail.count
            let doubletap = UITapGestureRecognizer(target: self, action: #selector(dispAlert(_:)))
            doubletap.numberOfTapsRequired = 2
            doubletap.numberOfTouchesRequired = 2
            view.addGestureRecognizer(doubletap)
            showQuestion()
        }
        print("後2",rotateDetail)
        TouchEnable = true
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func dispAlert(_ sender: UITapGestureRecognizer) {
        QuestionNumber = 0 //問題数による条件追加
        CorrectNumber = 0
        randomIndexes.removeAll()
        showQuestion()
    }
//指が離れたことを検知
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("離れた")
        print(TouchEnable)
        if TouchEnable == true{
            for touch in touches {
                let location = touch.location(in: self.view)
                xEndedTaplist.append(location.x)
                yEndedTaplist.append(location.y)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.xEndedTaplist.isEmpty == false{
                        self.xEndedTaplist.removeFirst()
                        self.yEndedTaplist.removeFirst()
                    }
                }
            }
    //ダブルタップを検知 QuestionModeで分岐

            var xp:Double = 0.0
            var yp:Double = 0.0
            if xEndedTaplist.count >= 2{
                for i in 0...xEndedTaplist.count-2{
                    let d = sqrt(pow((xEndedTaplist[i]-(xEndedTaplist.last)!),2)+pow((yEndedTaplist[i]-(yEndedTaplist.last)!),2))
                    //10.39からsliderで調整可能に変更
                    print(RecognizeRange)
                    if d <= Double(RecognizeRange){
                        print(xEndedTaplist)
                        TouchEnable = false
                        print("TouchEnable:false")
                        self.view.isUserInteractionEnabled = false
                        print("タッチ無効化")
                        xp = Double(xEndedTaplist[i])
                        yp = Double(yEndedTaplist[i])
                        print("xp:\(xp),yp:\(yp)")
                        if self.xEndedTaplist.isEmpty == false{
                            self.xEndedTaplist.removeAll()
                            self.yEndedTaplist.removeAll()
                        }
                        print(xEndedTaplist)
                        print("1")
                        doubletapActioin(xq: xp, yq: yp)
                        self.view.isUserInteractionEnabled = true
                        TouchEnable = true
                        print("4")
                        break
                    }
                }
            }
        print("5")
        }
//        break
    }
                
//音声触図データを回転補正してぎょrotateDetailに格納
    func calc1_rotateDetail() {
        let longcp12 = sqrt(pow(xStudyCp2 - xStudyCp1, 2) + pow(yStudyCp2 - yStudyCp1, 2))
        detailRow = Detail[4].count - 4
        for i in 5..<Detail.count {
            let x = Double(Detail[i][1])! - Double(Detail[2][1])!
            let y = Double(Detail[i][2])! - Double(Detail[2][2])!
            let xr_rotate: String = String(x / XL * longcp12 * sin(theta_o))
            let yr_rotate: String = String(y / YL * longcp12 * cos(theta_o))
            rotateDetail.append([String(i - 4), xr_rotate, yr_rotate, Detail[i][3]])
            print(rotateDetail)
            for j in 4...detailRow+3 {
                rotateDetail[i - 5].append(Detail[i][j])
            }
        }
        print("前",rotateDetail)
        removeColumnsFromRotateDetail(&rotateDetail, columnsToRemove: uncheckedIndexes)
//        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        print("後1",rotateDetail)
    }
    
    func removeColumnsFromRotateDetail(_ array: inout [[String]], columnsToRemove: [Int]) {
        // 列を削除
        for row in 0..<array.count {
            for columnIndex in columnsToRemove.reversed() {
                array[row].remove(at: columnIndex)
            }
        }
    }
    
    func doubletapActioin(xq:Double,yq:Double){
        if QuestionMode == 0{
            coordinate_comp(xp: Double(xq),yp: Double(yq))
        }else if QuestionMode == 1 && AnswerTime{
            AnswerTime = false
            let AnswerCoodination = QuestionCoordinateComp(xp: Double(xq), yp: Double(yq))
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
            speak(AnswerCoodination)
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
            QuestionNumber += 1
            if QuestionNumber == 5{
                speak("これで問題は終わりになります")
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
                speak("あなたは５問中\(CorrectNumber)問、正解しました！！")
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
                speak("もう一度行う場合は２本指でダブルタップしてください")
            }else if QuestionNumber <= 4{
                showNextQuesstion()
            }
//            break
            
        }
        print("3")
    }
    
    func showQuestion() {
        speak("問題は全部で５問です")
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
        // ランダムなインデックスを5つ選択する
        while randomIndexes.count < 5 {
            let randomRow = Int.random(in: 0..<totalRows)
            let randomColumn = Int.random(in: 4..<(4 + totalColumns))
            let index = randomRow * totalColumns + (randomColumn - 4)
            if !randomIndexes.contains(index) {
                randomIndexes.append(index)
            }
        }
//        print("===")
//        print(randomIndexes)
//        print("===")
        showNextQuesstion()
    }
    
    func showNextQuesstion() {
        var AnswerNumber = randomIndexes[QuestionNumber]
        rowIndex = AnswerNumber / totalColumns
        columnIndex = AnswerNumber % totalColumns + 4
        let Answer = rotateDetail[rowIndex][columnIndex]
        speak("\(Answer)はどこでしょう？")
//        RunLoop.current.run(until: Date(timeIntervalSinceNow: 2))
        TouchEnable = true
//        for index in randomIndexes {
//            let rowIndex = index / totalColumns
//            print("row",rowIndex)
//            let columnIndex = index % totalColumns + 4
//            print(totalColumns)
//            print("column",columnIndex)
//            let element = rotateDetail[rowIndex][columnIndex]
//            print("インデックス \(index) に対応する要素: \(element)")
//        }
    }
    
    func coordinate_comp(xp:Double, yp:Double){
        print("比較開始")
        var PointRegist:Int = 0
        for i in 0...(rotateDetail.count-1){
//            print(i)
            let range = (Double(rotateDetail[i][3]))!
            let xr = Double(rotateDetail[i][1])!
            let yr = Double(rotateDetail[i][2])!
            
            let theta_po = atan2(xp-xStudyCp1, yp-yStudyCp1)-atan2(xStudyCp2-xStudyCp1, yStudyCp2-yStudyCp1)+atan2(XL, YL)
            let Lp = sqrt(pow(xp-xStudyCp1, 2)+pow(yp-yStudyCp1, 2))
            
            let Xpr = Lp*sin(theta_po)
            let Ypr = Lp*cos(theta_po)
            print(i,sqrt(pow((xr-Xpr), 2) + pow((yr-Ypr), 2)))
            if 40 > sqrt(pow((xr-Xpr), 2) + pow((yr-Ypr), 2)){
                print("i",i)
//                print(("count",Count))
                strTapPoint = rotateDetail[i][4+Count[i]]
                PointRegist = 1
                speak(strTapPoint)
                TouchEnable = true
                //detailRow２列以上の場合
                //削除分も考慮しないとダメ
                if detailRow != 1{
                    //detailRowが1列だったら処理しない
                    if Count[i] == 0 {
                        Count = Count.map{$0 * 0}
                        Count[i] += 1
                    }else if Count[i] >= detailRow-uncheckedIndexes.count-1{
                        Count[i] = 0
                    }else{
                        Count[i] += 1
                    }
                }
                break
            }
        }
        if PointRegist == 0{
            playSound(withVolume: 0.3)
            TouchEnable = true
        }
    }
    func QuestionCoordinateComp(xp:Double, yp:Double) -> String {
        
        print(rowIndex,columnIndex)
        let range = (Double(rotateDetail[rowIndex][3]))!
        let xr = Double(rotateDetail[rowIndex][1])!
        let yr = Double(rotateDetail[rowIndex][2])!
            
        let theta_po = atan2(xp-xStudyCp1, yp-yStudyCp1)-atan2(xStudyCp2-xStudyCp1, yStudyCp2-yStudyCp1)+atan2(XL, YL)
        let Lp = sqrt(pow(xp-xStudyCp1, 2)+pow(yp-yStudyCp1, 2))
            
        let Xpr = Lp*sin(theta_po)
        let Ypr = Lp*cos(theta_po)
        if 25 > sqrt(pow((xr-Xpr), 2) + pow((yr-Ypr), 2)){
            strTapPoint = "正解"
            CorrectNumber += 1
        }else{
            strTapPoint = "残念！！"
        }
        
//            print(i,sqrt(pow((xr-Xpr), 2) + pow((yr-Ypr), 2)))
//            if 20 > sqrt(pow((xr-Xpr), 2) + pow((yr-Ypr), 2)){
//                strTapPoint = rotateDetail[i][4+Count[i]]
//                //detailRow２列以上の場合
//                if detailRow != 1{
//                    if Count[i] == 0 {
//                        Count = Count.map{$0 * 0}
//                        Count[i] += 1
//                    }else if Count[i] >= detailRow-1{
//                        Count[i] = 0
//                    }else{
//                        Count[i] += 1
//                    }
//                }
//                break
//                //detailRowが1列だったら処理しない
//            }
        print("2")
        return strTapPoint
    }
//音声読み上げ
    func speak(_ text: String) {
        if(synthesizer.isSpeaking){
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance.init(string: text)
        utterance.rate = 0.6
        utterance.voice = voice
        synthesizer.speak(utterance)
    }
    
    func playSound(withVolume volume: Float){
        guard let url = Bundle.main.url(forResource: "sound", withExtension: "wav") else {
            print("音声ファイルが見つかりません。")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.volume = volume // 音量の設定
            audioPlayer?.play()
        } catch {
            print("音声ファイルを再生できません。エラー: \(error.localizedDescription)")
        }
    }
}
