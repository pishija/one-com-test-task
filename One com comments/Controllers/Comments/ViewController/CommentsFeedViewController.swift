//
//  CommentsFeedViewController.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/27/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit

class CommentsFeedViewController: ViewControllerBase, UITableViewDelegate, UITableViewDataSource, CommentCellDelegate, LeaveCommentViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leaveCommentViewBottomConstraint: NSLayoutConstraint!
    
    private var comments: [String] = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse et lacus sit amet diam bibendum fermentum et quis tortor."]
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 128.0, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.set(username: "Lorem ipsum")
        cell.set(comment: self.comments[indexPath.row])
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
    
    //MARK: LeaveCommentViewDelegate
    
    func leaveComment(view: LeaveCommentView, didTapSend button: UIButton) {
        if let text = view.text {
            view.text = ""
            self.comments.append(text)
            self.tableView.reloadData()
        }
        _ = view.resignFirstResponder()
    }
    
    //MARK: Keyboard
    
    @objc override func keyboardWillBeHidden(sender: NSNotification) {
        self.leaveCommentViewBottomConstraint.constant = 0.0
        
        if let info: NSDictionary = sender.userInfo as NSDictionary? {
            
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 128.0, right: 0.0)
            self.scrollView?.contentInset = contentInsets
            self.scrollView?.scrollIndicatorInsets = contentInsets
    
            self.leaveCommentViewBottomConstraint.constant = 0.0
            
            let animationCurveRawNSN = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc override func keyboardWillBeShown(sender: NSNotification) {
        if let info: NSDictionary = sender.userInfo as NSDictionary? {
            let value: NSValue = info.value(forKey: UIResponder.keyboardFrameBeginUserInfoKey) as! NSValue
            let keyboardSize: CGSize = value.cgRectValue.size
            
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
            
            let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height + 128.0, right: 0.0)
            self.scrollView?.contentInset = contentInsets
            self.scrollView?.scrollIndicatorInsets = contentInsets
            
            self.leaveCommentViewBottomConstraint.constant = keyboardSize.height
            
            let animationCurveRawNSN = info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: {
                            self.view.layoutIfNeeded() },
                           completion: nil)
        }
        
    }

    
}
