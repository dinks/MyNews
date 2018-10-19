//
//  ViewController.swift
//  MyNews
//
//  Created by Dinesh V on 18.10.18.
//  Copyright © 2018 Dinesh. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let source: String
        
        switch indexPath.row {
        case 0:
            source = "techcrunch"
        case 1:
            source = "buzzfeed"
        case 2:
            source = "cnbc"
        case 3:
            source = "cnn"
        case 4:
            source = "engadget"
        default:
            source = "espn"
        }
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticlesListViewController") as? ArticlesListViewController {
            
            viewController.source = source
            viewController.title = source
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
