//
//  DeleteTaskGroupViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-07-15.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore


class DeleteTaskGroupViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
  
    
    @IBOutlet weak var deleteTable: UITableView!
    let db = Firestore.firestore()
    var groupnames = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        populatesidetable()
        // Do any additional setup after loading the view.
        self.deleteTable.allowsMultipleSelection = true
        self.deleteTable.allowsMultipleSelectionDuringEditing = true
        
    
    }
    
    func populatesidetable(){
        
        if let currentUser = Auth.auth().currentUser?.uid{
            
            db.collection("users").document(currentUser).collection("groups").getDocuments { (data, error) in
                if error != nil{
                    return
                }else{
                    if let groupnames = data?.documents{
                            
                        self.groupnames.removeAll()
                        for groupname in groupnames{
                            
                       
                            self.groupnames.append(groupname.documentID)
                        }
                        
                        print("groupnnames in database pulled\(self.groupnames.count)")
                        
                    }
                    self.deleteTable.reloadData()
                    
                }
            }
            
//
//            db.collection("users").document(currentUser).collection("groups").document(self.groupname!).collection(self.groupname!).getDocuments { (data, error) in
//                if error != nil{
//                    return
//                }else{
//                    if let tasknames = data?.documents{
//
//                        self.tasknames.removeAll()
//                        self.taskstatus.removeAll()
//                        for taskname in tasknames{
//
//                            self.tasknames.append(taskname.documentID)
//                            self.taskstatus.append(taskname.data()["status"] as! String)
//
//                        }
//                       // print("totaltasks:\(self.tasknames[0])")
//                    }
//                    self.deleteTasksTableView.reloadData()
//
//                }
//            }
            
            
          
        }
       
    
      
    }
    
    
    @IBAction func btnDelete(_ sender: Any) {
        
        if let selectedRows = deleteTable.indexPathsForSelectedRows{
            
            var items = [String]()
                  for indexPath in selectedRows  {
                      items.append(groupnames[indexPath.row])
                  }
                
            for item in items{
                
                
                if let currentUser = Auth.auth().currentUser?.uid{
                    
                    db.collection("users").document(currentUser).collection("groups").document(item).collection(item).getDocuments { [self] (data, error) in
                        if error != nil{
                            return
                        }else{
                            if let tasknames = data?.documents{
                                    
                                //if tasknames.count > 0{
                                    var statusarray = [String]()
                                    for taskname in tasknames{
                                        statusarray.append(taskname.data()["status"] as! String)
                                      
                                        
                                    }
                                    
                                    print(statusarray)
                                    if statusarray.count > 0 && statusarray.contains("Pending") || statusarray.contains("In progress"){
                                    let alert = UIAlertController(title: item, message: "Group is not empty or all done tasks", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    
                                }else{
                                    
                                 let currentUser = Auth.auth().currentUser?.uid
                                 db.collection("users").document(currentUser!).collection("groups").document(item).delete() { err in
                                     if let err = err {
                                         print("Error removing document: \(err)")
                                     } else {
                                         print("Document successfully removed!")
                                         self.populatesidetable()
                                         let alert = UIAlertController(title: "deleted", message: nil, preferredStyle: .alert)
                                         alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                                         self.present(alert, animated: true, completion: nil)
                                     }
                                 }
                                    
                                }
                                
                                
                           // }
                                }
                               // print("totaltasks:\(self.tasknames[0])")
                            }
                          
                            
                        }
                    }
                   
                
            }
            
            
        }
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupnames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deleteCell")! as! deletetablecell
        cell.deleteLabel.text = self.groupnames[indexPath.row]
        return cell
    }
}
