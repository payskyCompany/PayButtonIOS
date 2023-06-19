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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.setupUIView()
        cardListTbl.register(CardListTblCell.self, forCellReuseIdentifier: "CardListTblCell")
        cardListTbl.dataSource = self
        cardListTbl.delegate = self
        cardListTbl.rowHeight = 120
        
        self.cardListTbl.reloadData()

        
    }//--- end of viewDidLoad
    
    
    
}//--- end of class

extension SelectCardListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTblCell", for: indexPath) as! CardListTblCell
        return cell
    }
}

//extension SelectCardListVC {
//    private func setupUIView(){
//        cardListTbl.register(CardListTblCell.self, forCellReuseIdentifier: "CardListTblCell")
//        cardListTbl.dataSource = self
//        cardListTbl.delegate = self
//        cardListTbl.rowHeight = 120
//    }
//}
