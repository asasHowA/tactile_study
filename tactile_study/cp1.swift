//
//  cp1.swift
//  tactile_study
//
//  Created by doi-macbook on 2023/02/12.
//

import UIKit
import AVFoundation
import Foundation

var xStudyCp1:Double = 0.0
var yStudyCp1:Double = 0.0
var xStudyCp2:Double = 0.0
var yStudyCp2:Double = 0.0

class cp1: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       navigationController?.isNavigationBarHidden = true
     }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    var xEndedTaplist: [Double] = []
    var yEndedTaplist: [Double] = []
    var tapxy:String = ""
    var synthesizer: AVSpeechSynthesizer!
    var voice: AVSpeechSynthesisVoice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isMultipleTouchEnabled = true;
        
        synthesizer = AVSpeechSynthesizer()
        voice = AVSpeechSynthesisVoice.init(language: "ja-JP")
        speak("補正点１を登録してください")
        let doubletap = UITapGestureRecognizer(target: self, action: #selector(nextview(_:)))
        doubletap.numberOfTapsRequired = 2
        doubletap.numberOfTouchesRequired = 2
        view.addGestureRecognizer(doubletap)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
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
        
        if xEndedTaplist.count >= 2{
            for i in 0...xEndedTaplist.count-2{
                let d = sqrt(pow((xEndedTaplist[i]-(xEndedTaplist.last)!),2)+pow((yEndedTaplist[i]-(yEndedTaplist.last)!),2))
                //print(d)
                if d <= 10.39{
                    print("double tap:",d)
                    xStudyCp1 = xEndedTaplist[i]
                    yStudyCp1 = yEndedTaplist[i]
                    tapxy = "エックス" + String(xStudyCp1) + "ワイ" + String(yStudyCp1)
                    print(xEndedTaplist,yEndedTaplist)
                    xEndedTaplist.removeAll()
                    yEndedTaplist.removeAll()
                    print(xStudyCp1)
                    print(yStudyCp1)
                    print("===")
                    speak(tapxy)
                    break
                }
//                break
            }
        }
    }
    
    func speak(_ text: String) {
        if(synthesizer.isSpeaking){
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance.init(string: text)
        utterance.rate = 0.6
        utterance.voice = voice
        synthesizer.speak(utterance)
    }
    
    @objc func nextview(_ sender:UITapGestureRecognizer){
        dispAlert()
    }
    
    func dispAlert() {
        let alert: UIAlertController = UIAlertController(title: "補正点１を次の座標で登録しますか？", message: "x"+String(xStudyCp1)+"y"+String(yStudyCp1), preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "登録", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in self.performSegue(withIdentifier: "tocp2", sender: self)
            print("登録")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })

        alert.addAction(cancelAction)
        alert.addAction(defaultAction)

        self.present(alert, animated: true, completion: nil)
    }
    

}


