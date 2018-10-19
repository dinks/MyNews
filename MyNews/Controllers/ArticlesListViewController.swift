//
//  ArticlesListViewController.swift
//  MyNews
//
//  Created by Dinesh V on 19.10.18.
//  Copyright © 2018 Dinesh. All rights reserved.
//

import UIKit

class ArticlesListViewController: UITableViewController {
    
    var articles: Array<Article> = []
    var source: String = ""

    override func viewWillAppear(_ animated: Bool) {
        Article.getArticlesFor(source) { (articles, error) in
            guard error == nil else {
                let alertCtrl = UIAlertController(
                    title: NSLocalizedString("Error getting Items", comment:"Error"),
                    message: String(format:NSLocalizedString("Could not connect to server: %@", comment: "Error message"),(error?.localizedDescription)!),
                    preferredStyle: .alert)
                
                self.present(alertCtrl, animated: true, completion: nil)
                
                return
            }
            
            self.articles = articles!
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 340
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlecell", for: indexPath) as! ArticleViewCell

        let article: Article = articles[indexPath.row]
        
        let title = article.title
        if title != nil {
            cell.titleLabel.text = title
        } else {
            cell.titleLabel.text = ""
        }
        
        let author = article.author
        if author != nil {
            cell.authorLabel.text = author
        } else {
            cell.authorLabel.text = ""
        }
        
        if let content = article.description {
            cell.contentLabel.text = content
        } else {
            cell.contentLabel.text = ""
        }
        
        if let imageUrl = article.urlToImage {
            cell.contentImageView.downloaded(from: imageUrl)
        }
        
        return cell
    }
    
    func getData(from: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: from, completionHandler: completion).resume()
    }
    
    func downloadImage(from: URL, forImageView: UIImageView) {
        getData(from: from) { data, response, error in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async() {
                forImageView.image = UIImage(data: data)
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
