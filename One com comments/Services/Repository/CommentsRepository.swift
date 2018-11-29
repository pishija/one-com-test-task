//
//  CommentsRepository.swift
//  Comments
//
//  Created by Mihail Stevcev on 11/29/18.
//  Copyright © 2018 Rumberos. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


struct User: Codable {
    var id: String
    var username: String
    
}

struct Comment: Codable, Equatable {
    var id: String
    var text: String
    var user: User
    
    //Kept simple for this test
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
}

protocol CommentsRepository {
    func createUser(with username: String, image: UIImage?, completion: @escaping (User?, Error?) -> Void)
    func getAllComments(completion: @escaping ([Comment]?, Error?) -> Void)
    func createComment(with text: String, from user: User, completion: @escaping (Comment?, Error?) -> Void)
    func delete(comment: Comment, completion: @escaping (Error?) -> Void)
}


class CommentsRepositoryFirebase: CommentsRepository{
    
    private var ref: DatabaseReference = Database.database().reference()
    
    
    func createUser(with username: String, image: UIImage?, completion: @escaping (User?, Error?) -> Void) {
        
        let userRef = self.ref.child("users").childByAutoId()
        if let newUserId = userRef.key {
            let user = User(id: newUserId, username: username)
            
            do {
                let userDictionary =  try user.asDictionary()
                userRef.setValue(userDictionary) { (error, ref) in
                    guard error == nil else {
                        completion(nil, error)
                        return
                    }
                    completion(user, nil)
                }
            }
            catch let error {
                completion(nil, error)
            }
        } else {
            //TODO: Add custom error
            completion(nil, nil)
        }
        

    }
    
    func createComment(with text: String, from user: User, completion: @escaping (Comment?, Error?) -> Void) {
        let commentRef = self.ref.child("comments").childByAutoId()
        
        if let newCommentId = commentRef.key {
            let comment = Comment(id: newCommentId, text: text, user: user)
            do {
                let commentDictionary = try comment.asDictionary()
                commentRef.setValue(commentDictionary) { (error, _) in
                    guard error == nil else {
                        completion(nil, error)
                        return
                    }
                    completion(comment, nil)
                }
            }
            catch let error {
                completion(nil, error)
            }
        } else {
            //TODO: Add custom error
            completion(nil, nil)
        }
    }
    
    func getAllComments(completion: @escaping ([Comment]?, Error?) -> Void) {
        
        ref.child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            var comments: [Comment] = []
            if let allComments = snapshot.value as? [String:AnyObject] {
                for (_,comment) in allComments {
                    
                    if let comment = try? Comment(from: comment) {
                        comments.append(comment)
                    }
                }
            }
            completion(comments, nil)
        }) { (error) in
            completion(nil, error)
        }
        
    }
    
    func delete(comment: Comment, completion: @escaping (Error?) -> Void) {
        self.ref.child("comments").child(comment.id).removeValue { (error, _) in
            completion(error)
        }
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

extension Decodable {
    init(from: Any) throws {
        let data = try JSONSerialization.data(withJSONObject: from, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }
}
