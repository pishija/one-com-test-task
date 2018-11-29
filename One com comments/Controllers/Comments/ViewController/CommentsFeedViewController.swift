//
//  CommentsFeedViewController.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/27/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit

class CommentsFeedViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource, CommentCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.set(username: "Lorem ipsum")
        cell.set(comment: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse et lacus sit amet diam bibendum fermentum et quis tortor.")
        cell.setDate(text: "6h ago")
        cell.setLikes(text: "0 likes")
        cell.setShare(text: "Share")
        cell.setDelete(text: "Delete")
        cell.setDelete(hidden: true)
        
        if indexPath.row % 2 == 0 {
            cell.setContent(indented: true)
            cell.setDelete(hidden: false)
        }
        
        return cell
    }
    
    //MARK: CommentCellDelegate
    
    func comment(cell: CommentCell, didTapLike sender: AnyObject) {
        
    }
    
    func comment(cell: CommentCell, didTapShare sender: AnyObject) {
        
    }
    
    func comment(cell: CommentCell, didTapDelete sender: AnyObject) {
        
    }
    
}
