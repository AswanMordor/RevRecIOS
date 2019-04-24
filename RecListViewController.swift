//
//  RecListViewController.swift
//  RevRecIOS
//
//  Created by Azzy M on 4/23/19.
//  Copyright © 2019 Azzy M. All rights reserved.
//

import UIKit

class RecListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recordingsLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recTableView: UITableView!
    
    struct cellData {
        var recURL:URL
        var fileName:String
    }
    
    var cellDataArray: [cellData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecFiles()
        recTableView.delegate = self
        recTableView.dataSource = self
        recTableView.register(RecTableViewCell.self, forCellReuseIdentifier: "recCell")
        recTableView.separatorColor = UIColor.white
        recTableView.allowsSelection = false
        // Do any additional setup after loading the view.
    }
    
    func getRecFiles(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for file in fileURLs{
                let index = file.absoluteString.lastIndex(of: "/") ?? file.absoluteString.endIndex
                let tname = file.absoluteString.suffix(from: index)
                let start = tname.index(tname.startIndex, offsetBy: 1)
                let name  = tname.suffix(from: start)
                let data: cellData = cellData(recURL: file, fileName: String(name))
                cellDataArray.append(data)
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecTableViewCell = tableView.dequeueReusableCell(withIdentifier: "recCell", for: indexPath) as! RecTableViewCell
        cell.fileLabel.text = cellDataArray[indexPath.row].fileName
        cell.cellDataURL = cellDataArray[indexPath.row].recURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
