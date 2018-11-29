//
//  LeaveCommentView.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/29/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit

@objc protocol LeaveCommentViewDelegate: class {
    func leaveComment(view: LeaveCommentView, didTapSend button: UIButton)
}

class LeaveCommentView: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet private weak var sendButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    
    @IBOutlet weak var delegate: LeaveCommentViewDelegate?
    
    
    public var text: String? {
        get {
            return self.textView.text
        }
        set {
            self.textView.text = newValue
        }
    }
    
    //MARK: Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    //MARK: Setup
    
    private func commonInit() {
        self.backgroundColor = .clear
        
        let bundle = Bundle(for: LeaveCommentView.self)
        bundle.loadNibNamed("LeaveCommentView", owner: self, options: nil)
        self.addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.sendButton.layer.cornerRadius = 8.0
        self.textView.layer.cornerRadius = 8.0
    }
    
    //MARK: Overrides
    
    override func resignFirstResponder() -> Bool {
        return self.textView.resignFirstResponder()
    }
    
    override func becomeFirstResponder() -> Bool {
        return self.textView.becomeFirstResponder()
    }
    
    //MARK: Actions
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        self.delegate?.leaveComment(view: self, didTapSend: sender)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.textView.resignFirstResponder()
    }
    
}


