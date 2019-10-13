//
//  Firebase.swift
//  Feel Better
//
//  Created by Xinyi Xiang
//  Copyright © 2019 Feel Better. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

public class Firebase {
    public static let database = Firebase()
    private init() { }
    
    private let db = Firestore.firestore()
    var diariesRef: CollectionReference {
        let uid = Auth.auth().currentUser!.uid
        return db.collection("users").document(uid).collection("diaries")
    }
    private let storage = Storage.storage()
    private lazy var storageRef = storage.reference()
    // private let ref: DatabaseReference = Database.database().reference()
    // create record into Firebases
    // ref.child("name").childByAutoId().setValue("visual")
    // ref.child("name").childByAutoId().setValue("phanith")
    
    func replaceMemory<T>(withID documentID: String, _ property: KeyPath<LocalMemory, T>, with newValue: T) {
        let ref = diariesRef.document(documentID)
        switch property._kvcKeyPathString! {
        case "image":
            guard let image = newValue as? UIImage else {
                return print("ERROR: \(newValue) not an image")
            }
            uploadImage(image.pngData()!, for: documentID)
        case "saveDate":
            guard let date = newValue as? Date else {
                return print("ERROR: \(newValue) not a date")
            }
            ref.setValue(Timestamp(date: date), forKey: "saveDate")
        case let key:
            ref.setValue(newValue, forKey: key)
        }
    }
    
    func replaceMemory(withID documentID: String, with memory: LocalMemory, tags: [String]) {
        if let data = memory.image?.pngData() {
            uploadImage(data, for: documentID)
        }
        
        diariesRef.document(documentID).setData([
            "title": memory.title,
            "content": memory.content,
            "sentiments": memory.sentiment,
            "saveDate": Timestamp(date: memory.saveDate),
            "tags": tags
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document \(documentID) successfully written!")
            }
        }
    }
    
    /// Add a new document in collection "diaries"
    func saveNewMemory(_ memory: LocalMemory, tags: [String]) {
        let newMemoryRef = diariesRef.document()
        let documentID = newMemoryRef.documentID
        replaceMemory(withID: documentID, with: memory, tags: tags)
    }
    
    func getMemory(withID documentID: String, then process: @escaping (Result<CloudMemory, Error>) -> Void) {
        // get the document from designated collection
        diariesRef.document(documentID).getDocument { [unowned self] (document, error) in
            guard let data = document?.data() else {
                print("Document does not exist")
                return
            }
            guard let title = data["title"] as? String
                , let content = data["content"] as? String
                , let sentiment = data["sentiment"] as? Int
                , let saveTimestamp = data["saveDate"] as? Timestamp
                , let tags = data["tags"] as? [String]
                else {
                    return print("Wrong memory format: \(data)")
            }
            self.getImage(for: documentID) { (result) in
                process(result.map {
                    CloudMemory(documentID: documentID, title: title, content: content,
                    sentiment: sentiment, tags: tags,
                    saveDate: saveTimestamp.dateValue(), imageURL: $0)
                })
            }
        }
    }
    
    private func uploadImage(_ data: Data, for documentID: String){
        // Create a reference to the file you want to upload
        let picsRef = storageRef.child(documentID + ".png")
        picsRef.delete { _ in
            // Upload the file to the path "images/rivers.jpg"
            picsRef.putData(data, metadata: nil)
        }
    }
    
    public func getImage(for documentID: String, then process: @escaping (Result<URL, Error>) -> Void) {
        let picsRef = storageRef.child(documentID + ".png")
        picsRef.downloadURL { (url, error) in
            if let url = url {
                process(.success(url))
            } else {
                process(.failure(error!))
            }
        }
    }
}
