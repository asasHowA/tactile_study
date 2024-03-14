//
//  FileSelectFromFileApp.swift
//  tactile_study
//
//  Created by doi-macbook on 2024/02/26.
//

import Foundation
import UIKit
import UniformTypeIdentifiers


var urlB:URL = URL(string: "a")!

class FileSelectFromFileApp:UIDocumentPickerDelegate{
    
    func showFilePicker() {

        let picker = UIDocumentPickerViewController(
            forOpeningContentTypes: [
                UTType.jpeg,
                UTType.png,
                UTType.pdf
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
