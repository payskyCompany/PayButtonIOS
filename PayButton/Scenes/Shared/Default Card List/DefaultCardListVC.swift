//
//  DefaultCardListVC.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

class DefaultCardListVC: UIViewController {
    
    @IBOutlet weak var defaultCardListTbl: UITableView!
    @IBOutlet weak var defaultCardListTblHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUIView()
        
    }//--- end of viewDidLoad
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.defaultCardListTblHeight?.constant = self.defaultCardListTbl.contentSize.height
    }
    
    
}//--- end of class

extension DefaultCardListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCardListCell", for: indexPath) as! DefaultCardListCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DefaultCardListHeader") as! DefaultCardListHeader
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension DefaultCardListVC {
    private func setupUIView() {
        defaultCardListTbl.register(UINib(nibName: "DefaultCardListCell", bundle: nil),
                             forCellReuseIdentifier: "DefaultCardListCell")
        
        
        defaultCardListTbl.register(UINib(nibName: "DefaultCardListHeader", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: "DefaultCardListHeader")
        defaultCardListTbl.dataSource = self
        defaultCardListTbl.delegate = self
        defaultCardListTbl.estimatedRowHeight = 80
        defaultCardListTbl.rowHeight = UITableView.automaticDimension
    }
}
