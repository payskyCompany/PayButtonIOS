//
//  ManageCardsVC.swift
//  PayButton
//
//  Created by PaySky105 on 19/06/2023.
//  Copyright © 2023 PaySky. All rights reserved.
//

import MOLH
import UIKit

protocol ManageCardView: AnyObject {
    func didTapRadioButton(forCell selectedCell: ManageCardsTblCell)
    func didTapDeleteButton(forCell selectedCell: ManageCardsTblCell)
}

class ManageCardsVC: UIViewController {
    let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .mainColor
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .lightText
        spinner.layer.cornerRadius = 20
        spinner.layer.masksToBounds = true
        return spinner
    }()

    @IBOutlet var closeCurrentPageBtn: UIButton!
    @IBOutlet var headerLbl: UILabel!

    @IBOutlet var setDefaultCardLbl: UILabel!
    @IBOutlet var manageCardsListTbl: UITableView!
    @IBOutlet var defaultCardListTblHeight: NSLayoutConstraint!

    @IBOutlet var backBtn: UIButton!
    @IBOutlet var changeLangBtn: UIButton!
    @IBOutlet var termsAndConditionsBtn: UIButton!

    var presenter: ManageCardsPresenter!

    weak var delegate: PayButtonDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setupUIView()
        addSpinnerView()
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        defaultCardListTblHeight?.constant = manageCardsListTbl.contentSize.height
    }

    private func setupUIView() {
        closeCurrentPageBtn.setTitle("", for: .normal)
        headerLbl.text = "quick_payment_form".localizedString()
        setDefaultCardLbl.text = "set_your_default_card".localizedString()

        backBtn.setTitle("back".localizedString(), for: .normal)
        changeLangBtn.setTitle("change_lang".localizedString(), for: .normal)
        termsAndConditionsBtn.setTitle("terms_conditions".localizedString(), for: .normal)

        manageCardsListTbl.register(UINib(nibName: "ManageCardsTableHeader", bundle: nil),
                                    forHeaderFooterViewReuseIdentifier: "ManageCardsTableHeader")
        manageCardsListTbl.register(UINib(nibName: "ManageCardsTblCell", bundle: nil),
                                    forCellReuseIdentifier: "ManageCardsTblCell")
        manageCardsListTbl.dataSource = self
        manageCardsListTbl.delegate = self
        manageCardsListTbl.estimatedRowHeight = 80
        manageCardsListTbl.rowHeight = UITableView.automaticDimension
    }

    private func addSpinnerView() {
        view.addSubview(loadingSpinner)
        loadingSpinner.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        loadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @IBAction func dismissCurrentPageAction(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func changeLangBtnPressed(_ sender: UIButton) {
        UIView.appearance().semanticContentAttribute = MOLHLanguage.currentAppleLanguage() == "ar" ? .forceRightToLeft : .forceLeftToRight

        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        if MOLHLanguage.currentAppleLanguage() == "en" {
            UserDefaults.standard.set("en", forKey: "AppLanguage")
        } else {
            UserDefaults.standard.set("ar", forKey: "AppLanguage")
        }
        MOLH.reset()
        Bundle.swizzleLocalization()

        let viewController = ManageCardsVC(nibName: "ManageCardsVC", bundle: nil)
        viewController.delegate = delegate
        let newPresenter = ManageCardsPresenter(view: viewController,
                                                paymentMethodData: presenter.getPaymentMethodData(),
                                                customerCards: presenter.getCustomerCards(),
                                                customerSessionId: presenter.getSessionId())
        viewController.presenter = newPresenter
        if UIApplication.topViewController()?.navigationController != nil {
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
            })
        } else {
            viewController.modalPresentationStyle = .fullScreen
            UIApplication.topViewController()?.dismiss(animated: true, completion: {
                UIApplication.topViewController()?.present(viewController, animated: true)
            })
        }
    }

    @IBAction func termsAndConditionsBtnPressed(_ sender: UIButton) {
    }
}

extension ManageCardsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getCustomerCards().cardsList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageCardsTblCell", for: indexPath) as! ManageCardsTblCell
        cell.configure(presenter.getCustomerCards().cardsList?[indexPath.row])
        cell.tag = indexPath.row
        cell.delegate = presenter.view
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ManageCardsTableHeader") as! ManageCardsTableHeader
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ManageCardsVC: ManageCardView {
    func didTapRadioButton(forCell selectedCell: ManageCardsTblCell) {
        debugPrint("didTapRadioButton")
    }

    func didTapDeleteButton(forCell selectedCell: ManageCardsTblCell) {
        debugPrint("didTapDeleteButton")
    }
}
