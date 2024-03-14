//
//  FileSelectViewController.swift
//  tactile_study
//
//  Created by doi-macbook on 2023/02/12.
//


import UIKit
let groupID = "group.readwrite-tac"
let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID)
let url2 = url!.path + "/sampledir"
var filename:[String] = []
var fileArrayNumber:Int = 0

class FileSelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //csvファイルのみ表示
        do{
            filename = try FileManager.default.contentsOfDirectory(atPath: url2)
//            filename = allfilename.filter({ $0.contains("csv")})
            print(filename)
        }catch{
            print("ファイル取得失敗")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filename.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableview.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        cell.textLabel!.text = filename[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCP1", sender: nil)
        //設定しなくても画面遷移する。navigationControllerの影響？
        fileArrayNumber = Int(indexPath.row)
        csvType = 0
//        print(fileArrayNumber)
    }
}
