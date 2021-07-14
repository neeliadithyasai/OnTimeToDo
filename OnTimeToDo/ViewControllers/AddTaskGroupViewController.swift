//
//  AddTaskGroupViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-14.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AddTaskGroupViewController: UIViewController {
    
    @IBOutlet weak var txtname: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Add Group"
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        if let groupname = self.txtname.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            
            if groupname == "" {
                
                let alertController = UIAlertController(title: nil, message: "please enter Groupname", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
           
            }else{
                
        let alertController = UIAlertController(title: nil, message: "Do you want to create the group?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            
            self.creategroup(gn:groupname)
            
        }))
        
        self.present(alertController, animated: true)
        
            }
            
    }
        
    }
    
    func creategroup(gn:String){
        
        let db = Firestore.firestore()
        
    
                
                if let currentUser = Auth.auth().currentUser?.uid{
                    
                    db.collection("users").document(currentUser).collection("groups").document(gn).setData(["exists" : true])
          
            }
        
        let alertController = UIAlertController(title: nil, message: "group created", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: {action in
            self.txtname.text?.removeAll()
    
        }))
        self.present(alertController, animated: true)
        }
        
       
        
        
        
        
    }
    

