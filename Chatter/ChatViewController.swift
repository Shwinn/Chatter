//
//  ChatViewController.swift
//  Chatter
//
//  Created by Ashwin Gupta on 2/28/17.
//  Copyright © 2017 Ashwin Gupta. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.getMessages), userInfo: nil, repeats: true)
    }
    
    func getMessages(){
        var query = PFQuery(className: "Message")
        query.includeKey("user")
        query.order(byDescending: "createdAt")
        query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.messages = messages!
            }
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let message = PFObject(className: "Message")
        message["text"] = messageTextField.text!
        message["user"] = PFUser.current()
        message.saveInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("Succesfully saved message: \(self.messageTextField.text!)")
            }
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath as IndexPath) as! MessageCell
        cell.messageTextLabel.text = messages[indexPath.row]["text"] as? String
        let user = messages[indexPath.row]["user"] as? PFObject
        if let username = user?["username"] {
            cell.messageSenderTextLabel.text = username as! String
        }
        else {
            cell.messageSenderTextLabel.text = ""  
        }
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
