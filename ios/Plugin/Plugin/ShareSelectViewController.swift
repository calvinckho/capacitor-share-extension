//
//  ShareSelectViewController.swift
//  testShareExtension
//
//  Created by Jonathan on 7/13/19.
//

import Foundation
import UIKit
protocol ShareSelectViewControllerDelegate {
    func sendingViewController(sentItem: Conversation)
}
class ShareSelectViewController: UITableViewController{
    var conversationList: [Conversation] = []
    var delegate: ShareSelectViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.conversationList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TeamCell")
        }
        
        cell!.textLabel!.text = self.conversationList[indexPath.item].name
        
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(conversationList[indexPath.row])
        delegate?.sendingViewController(sentItem: conversationList[indexPath.row])
    }
    /*let list = ["1","2","3"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    */
    /*
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.DeckCell)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        title = "Select Deck"
        view.addSubview(tableView)
    }
    // ...
    private extension ShareSelectViewController {
        struct Identifiers {
            static let DeckCell = "deckCell"
        }
    }*/
}
