//
//  CommentsFeedViewController.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/27/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit

class CommentsFeedViewController: FeedControllerBase<Comment>, UITableViewDelegate, UITableViewDataSource, CommentCellDelegate, LeaveCommentViewDelegate, View {
    
    typealias Presenter = CommentsFeedPresenter
    var presenter: Presenter
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leaveCommentViewBottomConstraint: NSLayoutConstraint!

    
    //MARK: Initialization
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, presenter: Presenter) {
        self.presenter = presenter
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(presenter: Presenter) {
        self.init(nibName: nil, bundle: nil, presenter: presenter)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CommentCell")
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 128.0, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        self.scrollView?.scrollIndicatorInsets = contentInsets
        
        self.presenter.attach(view: self)
        self.presenter.loadData()
    }
    
    //MARK: Overrides
    
    override func set(items: [Comment]) {
        super.set(items: items)
        self.tableView.reloadData()
    }
    
    override func append(items: [Comment]) {
        super.append(items: items)
        self.tableView.reloadData()
    }
    
    override func remove(item: Comment) {
        super.remove(item: item)
        self.tableView.reloadData()
    }
    
    //MARK: UITableViewDatasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        let item = self.items[indexPath.row]
        
        cell.delegate = self
        
        if let url = item.user.imageUrl {
            cell.setImageFrom(url: url)
        }
        
        cell.set(username: item.user.username)
        cell.set(comment: item.text)
        cell.setDate(text: "6h ago")
        
        cell.setLikes(text: "0 likes")
        cell.setShare(text: "Share")
        cell.setDelete(text: "Delete")
        
        if self.presenter.user.id == item.user.id {
            cell.setDelete(hidden: false)
            cell.setContent(indented: true)
        } else {
            cell.setDelete(hidden: true)
        }
        
        return cell
    }
    
    //MARK: CommentCellDelegate
    
    func comment(cell: CommentCell, didTapLike sender: Any) {
        
    }
    
    func comment(cell: CommentCell, didTapShare sender: Any) {
        
    }
    
    func comment(cell: CommentCell, didTapDelete sender: Any) {
        if let indexPath = self.tableView.indexPath(for: cell) {
            let comment = self.items[indexPath.row]
            self.presenter.onDeleteButtonTappedFor(comment: comment)
        }
    }
    
    //MARK: LeaveCommentViewDelegate
    
    func leaveComment(view: LeaveCommentView, didTapSend button: UIButton) {
        if let text = view.text, text.count > 0 {
            self.presenter.onSendButtonTapped(text: text)
        }
        view.text = ""
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
