//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages : [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.title = K.appName
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadMessages()
    }
    
    func loadMessages(){
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { snapshot, error in
            if let e = error{
                print(e)
                return
            }else{
                self.messages = []
                if let snapShotDocuments = snapshot?.documents{
                    for doc in snapShotDocuments{
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String , let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: messageSender, body: messageBody, userName: Auth.auth().currentUser?.displayName ?? "Sender")
                            self.messages.append(newMessage)
                            
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        print(Auth.auth().currentUser?.displayName! as! String)
        if let message = messageTextfield.text,let email = Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField:email,K.FStore.bodyField:message,K.FStore.dateField:Date().timeIntervalSince1970]) { error in
                    if let e = error{
                        print(e)
                        
                        DispatchQueue.main.async {
                            
                            self.messageTextfield.text  = ""
                        }
                    }
                    else{
                        print("No Error Occured")
                    }
                }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try  Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError{
            print(signOutError)
        }
    }
    
}

extension ChatViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier ,for: indexPath) as! MessageCell
        cell.label.text = String(message.body)
        
        
        
        if message.sender == Auth.auth().currentUser?.email{
            cell.rightImageView.isHidden = false
            cell.userName.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }else{
            cell.rightImageView.isHidden = true
            cell.userName.isHidden = false
            cell.userName.text = message.userName
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
       
        return cell
    }
}

extension ChatViewController : UITableViewDelegate{
    
}
