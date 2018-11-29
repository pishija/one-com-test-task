//
//  CommentCell.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/27/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit

protocol CommentCellDelegate: class {
    func comment(cell: CommentCell, didTapLike sender: AnyObject)
    func comment(cell: CommentCell, didTapShare sender: AnyObject)
    func comment(cell: CommentCell, didTapDelete sender: AnyObject)
}

class CommentCell: UITableViewCell {

    @IBOutlet private weak var commentLabel: UILabel!
    
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var dateIcon: UIImageView!
    
    @IBOutlet private weak var contentLeadingConstraint: NSLayoutConstraint!
    
    
    //MARK: Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.likeButton.imageView?.contentMode = .scaleAspectFit
        self.shareButton.imageView?.contentMode = .scaleAspectFit
        self.deleteButton.imageView?.contentMode = .scaleAspectFit
        
        self.deleteButton.tintColor = UIColor.red
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentLeadingConstraint.constant = 0.0
    }
    
    
    //MARK: Interface
    
    func set(comment: String) {
        self.commentLabel.text = comment
    }
    
    func set(username: String) {
        self.usernameLabel.text = username
    }
    
    func creation(date: String) {
        self.dateLabel.text = date
    }
    
    func set(image: UIImage) {
        self.userImageView.image = image
    }
    
    func setImageFrom(url: URL) {
        //TODO: 
    }
    
    func setLikes(text: String) {
        self.likeButton.setTitle(text, for: .normal)
    }
    
    func setShare(text: String) {
        self.shareButton.setTitle(text, for: .normal)
    }
    
    func setDelete(text: String) {
        self.deleteButton.setTitle(text, for: .normal)
    }
    
    func setDate(text: String) {
        self.dateLabel.text = text
    }
    
    func setDelete(hidden: Bool) {
        self.deleteButton.alpha = hidden ? 0.0 : 1.0
        self.deleteButton.isEnabled = !hidden
    }
    
    private static let indentationValue: CGFloat = 8.0
    func setContent(indented: Bool) {
        if indented {
            self.contentLeadingConstraint.constant = CommentCell.indentationValue
        } else {
            self.contentLeadingConstraint.constant = 0.0
        }
    }
}


extension CommentCell {
    
    @objc dynamic var usernameColor: UIColor? {
        set {
            self.usernameLabel.textColor = newValue
        }
        get {
            return self.usernameLabel?.textColor
        }
    }
    
    @objc dynamic var usernameFont: UIFont? {
        set {
            self.usernameLabel.font = newValue
        }
        get {
            return self.usernameLabel.font
        }
    }
    
    @objc dynamic var dateColor: UIColor? {
        set {
            self.dateLabel.textColor = newValue
            self.dateIcon.tintColor = newValue
        }
        get {
            return self.dateLabel?.textColor
        }
    }
    
    @objc dynamic var dateFont: UIFont? {
        set {
            self.dateLabel.font = newValue
        }
        get {
            return self.dateLabel.font
        }
    }
    
    
    @objc dynamic var commentColor: UIColor? {
        set {
            self.commentLabel.textColor = newValue
        }
        get {
            return self.commentLabel?.textColor
        }
    }
    
    @objc dynamic var commentFont: UIFont? {
        set {
            self.commentLabel.font = newValue
        }
        get {
            return self.commentLabel.font
        }
    }
    
    @objc dynamic var likeColor: UIColor? {
        set {
            self.likeButton.setTitleColor(newValue, for: .normal)
            self.likeButton.tintColor = newValue
        }
        get {
            return self.likeButton.titleColor(for: .normal)
        }
    }
    
    @objc dynamic var likeFont: UIFont? {
        set {
            self.likeButton.titleLabel?.font = newValue
        }
        get {
            return self.likeButton.titleLabel?.font
        }
    }
    
    @objc dynamic var shareColor: UIColor? {
        set {
            self.shareButton.setTitleColor(newValue, for: .normal)
            self.shareButton.tintColor = newValue
        }
        get {
            return self.shareButton.titleColor(for: .normal)
        }
    }
    
    @objc dynamic var shareFont: UIFont? {
        set {
            self.shareButton.titleLabel?.font = newValue
        }
        get {
            return self.shareButton.titleLabel?.font
        }
    }
    
    @objc dynamic var deleteColor: UIColor? {
        set {
            self.deleteButton.setTitleColor(newValue, for: .normal)
            self.deleteButton.tintColor = newValue
        }
        get {
            return self.deleteButton.titleColor(for: .normal)
        }
    }
    
    @objc dynamic var deleteFont: UIFont? {
        set {
            self.deleteButton.titleLabel?.font = newValue
        }
        get {
            return self.deleteButton.titleLabel?.font
        }
    }
    
}
