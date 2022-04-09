//
//  QuotesViewController.swift
//  MyQuotes
//
//  Created by Adithyah Nair on 09/04/22.
//

import UIKit

class QuotesViewController: UITableViewController {
    
    let quoteType = MyQuotes()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return quoteType.nonPremiumQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = quoteType.nonPremiumQuotes[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0 // prevents truncation of text
        
        return cell
    }
}
