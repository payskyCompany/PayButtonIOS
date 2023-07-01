//
//  SelectCardListVC.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import UIKit

protocol SelectCardListViewProtocol: AnyObject {
    func didTapToggleButton(forCell selectedCell: CardListTblCell)
    func didTapCvvTextField(forCell selectedCell: CardListTblCell)
    func openWebView(withUrlPath path: String)
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String)
    func navigateToPaymentRejectedView(withMessage text: String)
    func onPayBtnTapped()
    func updateSavedCardList(withAllCardResponse: GetCustomerCardsResponse)
    func navigateToAddNewCardView()
    func navigateToAddNewCard(withAllCardResponse: GetCustomerCardsResponse)
    func startLoading()
    func endLoading()
}

class SelectCardListVC: UIViewController {
    
    @IBOutlet weak var merchantLbl: UILabel!
    @IBOutlet weak var merchantNameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountValueLbl: UILabel!
    
    @IBOutlet weak var cardListTbl: UITableView!
    @IBOutlet weak var cardListTblHeight: NSLayoutConstraint!

    var presenter: SelectCardListPresenter!
    
    weak var delegate: PayButtonDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUIView()
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.cardListTblHeight?.constant = self.cardListTbl.contentSize.height
    }
    
    private func setupUIView() {
        merchantLbl.text = "merchant".localizedString().uppercased()
        merchantNameLbl.text = MerchantDataManager.shared.merchant.merchantId
        amountLbl.text = "amount".localizedString().uppercased()
        amountValueLbl.text = "\(MerchantDataManager.shared.merchant.currencyCode)".localizedString()
        + " " + "\(MerchantDataManager.shared.merchant.amount)"
        
        cardListTbl.register(UINib(nibName: "CardListTblCell", bundle: nil),
                             forCellReuseIdentifier: "CardListTblCell")
        cardListTbl.dataSource = self
        cardListTbl.delegate = self
        cardListTbl.estimatedRowHeight = 100
        cardListTbl.rowHeight = UITableView.automaticDimension
    }
}

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
        return presenter.getCustomerCards().cardsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardListTblCell", for: indexPath) as! CardListTblCell
        cell.configure(presenter.getCustomerCards().cardsList?[indexPath.row])
        return cell
    }
}

extension SelectCardListVC: SelectCardListViewProtocol {
    func didTapToggleButton(forCell selectedCell: CardListTblCell) {
        print("didTapToggleButton")
    }
    
    func didTapDeleteIconButton(forCell selectedCell: CardListTblCell) {
        print("didTapDeleteIconButton")
    }
    
    func didTapCvvTextField(forCell selectedCell: CardListTblCell) {
        print("didTapCvvTextField")
    }
    
    func openWebView(withUrlPath path: String) {
        print("openWebView")
    }
    
    func navigateToPaymentApprovedView(withTrxnReference reference: String, andMessage message: String) {
        print("navigateToPaymentApprovedView")
    }
    
    func navigateToPaymentRejectedView(withMessage text: String) {
        print("navigateToPaymentRejectedView")
    }
    
    func onPayBtnTapped() {
        print("onPayBtnTapped")
    }
    
    func updateSavedCardList(withAllCardResponse: GetCustomerCardsResponse) {
        print("updateSavedCardList")
    }
    
    func navigateToAddNewCardView() {
        print("navigateToAddNewCard")
    }
    
    func navigateToAddNewCard(withAllCardResponse: GetCustomerCardsResponse) {
        print("navigateToAddNewCard")
    }
    
    func startLoading() {
        print("startLoading")
    }
    
    func endLoading() {
        print("endLoading")
    }
}
