//
//  QiitaItemsTableViewController.swift
//  BackgroundFetcher
//
//  Created by 佐藤 康次 on 2016/06/18.
//  Copyright © 2016年 佐藤 康次. All rights reserved.
//

import UIKit

class QiitaItemsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var data : [QiitaItem] = []
    let qiitaItemManager = QiitaItemManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.reloadFromLocal()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(self.didBecomeActive),
            name:UIApplicationDidBecomeActiveNotification,
            object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBAction
    @IBAction func reloadButtonAction(sender: AnyObject) {
        self.reloadFromServer()
    }
    
    @IBAction func deleteButtonAction(sender: AnyObject) {
        self.qiitaItemManager.deleteItems()
        self.data = []
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.data[indexPath.row].title
        
        return cell
    }

    // MARK: - Methods
    func reloadFromLocal(){
        self.qiitaItemManager.reloadDataFromLocalWithHandler { items in
            self.data = items
            self.tableView.reloadData()
        }
    }
    
    func reloadFromServer(){
        self.qiitaItemManager.reloadDataFromServer({ (items) in
            self.data = items
            self.tableView.reloadData()
            }) { (error) in
                print(error)
        }
    }
    
    func didBecomeActive(){
        self.reloadFromLocal()
    }
}
