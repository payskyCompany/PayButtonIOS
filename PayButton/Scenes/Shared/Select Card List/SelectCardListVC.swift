//
//  SelectCardListVC.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

class SelectCardListVC: UIViewController {
    
    @IBOutlet weak var cardListTbl: UITableView!
    @IBOutlet weak var cardListTblHeight: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUIView()
        
    }//--- end of viewDidLoad
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cardListTblHeight?.constant = self.cardListTbl.contentSize.height
    }
    
    
}//--- end of class

extension SelectCardListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTblCell", for: indexPath) as! CardListTblCell
        return cell
    }
}

extension SelectCardListVC {
    private func setupUIView() {
        cardListTbl.register(UINib(nibName: "CardListTblCell", bundle: nil),
                             forCellReuseIdentifier: "CardListTblCell")
        cardListTbl.dataSource = self
        cardListTbl.delegate = self
        cardListTbl.estimatedRowHeight = 100
        cardListTbl.rowHeight = UITableView.automaticDimension
    }
}
