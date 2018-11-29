//
//  CommentsFeedPresenter.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/29/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import Foundation

class CommentsFeedPresenter: FeedPresenterBase<CommentsFeedViewController> {
    
    var repository: CommentsRepository
    var user: User
    
    //MARK: Initialization
    init(repository: CommentsRepository, user: User) {
        self.repository = repository
        self.user = user
        super.init()
    }
    
    //MARK: Presenter
    
    override func loadData() {
        self.view?.showTakeoverLoading()
        self.repository.getAllComments { (comments, error) in
            self.view?.hideTakeoverLoading()
            guard error == nil else {
                //TODO: Show error
                return
            }
            if let aComments = comments {
                DispatchQueue.main.async {
                    self.view?.set(items: aComments)
                }
            } else {
                //TODO: show message
            }
        }
    }
    
    func onSendButtonTapped(text: String) {
        self.repository.createComment(with: text, from: self.user) { (comment, error) in
            guard error == nil else {
                //TODO: Show error
                return
            }
            DispatchQueue.main.async {
                self.view?.append(items: [comment!])
            }
        }
    }
    
    func onDeleteButtonTappedFor(comment: Comment) {
        self.repository.delete(comment: comment) { (error) in
            guard error == nil else {
                //TODO: Show error
                return
            }
            self.view?.remove(item: comment)
        }
    }
}
