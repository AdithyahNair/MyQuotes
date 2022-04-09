//
//  QuotesViewController.swift
//  MyQuotes
//
//  Created by Adithyah Nair on 09/04/22.
//

import UIKit
import ChameleonFramework
import StoreKit

class QuotesViewController: UITableViewController, SKPaymentTransactionObserver {
    
    let quoteType = MyQuotes()
    
    let productID = "com.adithyahnair.MyQuotes.PremiumQuotes"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPurchased() {
            showPremiumQuotes()
        }
        
        SKPaymentQueue.default().add(self) // SKPaymentQueue's Transaction Observer is self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isPurchased() {
            return quoteType.nonPremiumQuotes.count
        } else {
            return quoteType.nonPremiumQuotes.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        if indexPath.row < quoteType.nonPremiumQuotes.count {
            
            cell.textLabel?.text = quoteType.nonPremiumQuotes[indexPath.row]
            cell.textLabel?.textColor = .none
            cell.accessoryType = .none
        } else {
            
            cell.textLabel?.text = "Buy Premium Quotes"
            cell.textLabel?.textColor = UIColor(hexString: "1D9BF6")
            cell.accessoryType = .disclosureIndicator
            tableView.rowHeight = 65
        }
        cell.textLabel?.numberOfLines = 0 // prevents truncation of text
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == quoteType.nonPremiumQuotes.count {
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - buyPremiumQuotes()
    
    func buyPremiumQuotes() {
        
        let paymentRequest = SKMutablePayment()
        
        paymentRequest.productIdentifier = productID
        
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    //MARK: - SKPaymentTransactionObserver methods
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // check for each transaction state
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("Transaction Successful.")
                
                showPremiumQuotes()
                
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                
                if let error = transaction.error {
                    print("Transaction Failed. Error: \(error)")
                }
            }
        }
    }
    
    //MARK: - showPremiumQuotes()
    
    func showPremiumQuotes() {
        
        UserDefaults.standard.set(true, forKey: K.isPurchased)
        
        quoteType.nonPremiumQuotes.append(contentsOf: quoteType.premiumQuotes)
        
        navigationItem.setRightBarButton(nil, animated: true)
        
        tableView.reloadData()
    }
    
    //MARK: - isPurchased()
    
    func isPurchased() -> Bool {
        
        if UserDefaults.standard.bool(forKey: K.isPurchased) {
            print("isPurchased")
            return true
        } else {
            print("isNotPurchased")
            return false
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        showPremiumQuotes()

    }
    
    //MARK: - restorePressed Action
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
