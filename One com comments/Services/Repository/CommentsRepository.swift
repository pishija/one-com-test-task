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
import FirebaseStorage


struct User: Codable {
    var id: String
    var username: String
    var imageUrl: URL?
    
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
    private let storageRef = Storage.storage().reference()
    
    private let dispatchGroup = DispatchGroup()
    
    func createUser(with username: String, image: UIImage?, completion: @escaping (User?, Error?) -> Void) {
        
        let userRef = self.ref.child("users").childByAutoId()
        
        if let newUserId = userRef.key {
            var imageURL: URL? = nil
            if let anImage = image?.resized(toWidth: UIScreen.main.bounds.width), let data = anImage.pngData()  {
                self.dispatchGroup.enter()
                // Create a reference to the file you want to upload
                let riversRef = storageRef.child("images/\(newUserId).jpg")
                
                // Upload the file to the path "images/rivers.jpg"
                let _ = riversRef.putData(data, metadata: nil) { (metadata, error) in
                    guard error == nil else {
                        completion(nil, error)
                        return
                    }
                    riversRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            completion(nil, error)
                            return
                        }
                        imageURL = downloadURL
                        self.dispatchGroup.leave()
                    }
                }
            }
            
            
            // Notify dispatch group
            self.dispatchGroup.notify(queue: .main) {
                let user = User(id: newUserId, username: username, imageUrl: imageURL)
                
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

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
