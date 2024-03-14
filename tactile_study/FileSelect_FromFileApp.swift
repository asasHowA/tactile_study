//
//  ViewController.swift
//  tactile_study
//
//  Created by doi-macbook on 2024/02/26.
//

import UIKit
import UniformTypeIdentifiers
import Foundation

var urlC:URL = URL(string: "a")!

class FileSelect_FromFileApp: UIViewController{
    
    func showFilePicker() {
        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [
                UTType.commaSeparatedText,
//                UTType.jpeg,
//                UTType.png,
//                UTType.pdf
            ],
            asCopy: true)
        picker.delegate = self
        self.navigationController?.present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showFilePicker()
    }
}

extension FileSelect_FromFileApp: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // ファイル選択後に呼ばれる
        // urls.first?.pathExtensionで選択した拡張子が取得できる

//        if let filePath = urls.first?.description {
//            print("ファイルパス:\(filePath)")
//        }
        guard let urlA = urls.first else { return }
        guard urlA.startAccessingSecurityScopedResource() else {
            // ここで選択したURLでファイルを処理する
            print(type(of: urls.first))
            urlC = urlA
            print("urlA:",urlA)
            print("url2:",url2)
            csvType = 1
//            showImage(imageView: image, url: urlA)
            performSegue(withIdentifier: "tocp1", sender: nil)
            return
        }
        // ファイルの処理が終わったら、セキュリティで保護されたリソースを解放(されてないっぽい)
        do { urlA.stopAccessingSecurityScopedResource() }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("ファイル取得キャンセル")
    }
    
    func showImage(imageView: UIImageView, url: URL) {
            do {
                let data = try Data(contentsOf: url)
                let image = UIImage(data: data)
                imageView.image = image
            } catch let err {
                print("Error: \(err.localizedDescription)")
            }
    }
}

