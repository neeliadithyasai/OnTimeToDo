//
//  DeleteTaskViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-07-26.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class DeleteTaskViewController: UIViewController {

    @IBOutlet weak var deleteTasksTableView: UITableView!
    
    var groupname:String?
    let db = Firestore.firestore()
    var tasknames = [String]()
    var taskstatus = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        populatetableview()
        self.deleteTasksTableView.allowsMultipleSelection = true
        self.deleteTasksTableView.allowsMultipleSelectionDuringEditing = true
    }
    

    @IBAction func btnDeleteTask(_ sender: Any) {
        
        
        if let selectedRows = deleteTasksTableView.indexPathsForSelectedRows{
            
            var items = [String]()
                  for indexPath in selectedRows  {
                      items.append(tasknames[indexPath.row])
                  }
                
            for item in items{
                let currentUser = Auth.auth().currentUser?.uid
                db.collection("users").document(currentUser!).collection("groups").document(self.groupname!).collection(self.groupname!).document(item).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                        self.populatetableview()
                        let alert = UIAlertController(title: "deleted", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            }
            
            
        }
        
        
    }
    
    
    func populatetableview(){
        
        
        
        if let currentUser = Auth.auth().currentUser?.uid{
            
            db.collection("users").document(currentUser).collection("groups").document(self.groupname!).collection(self.groupname!).getDocuments { (data, error) in
                if error != nil{
                    return
                }else{
                    if let tasknames = data?.documents{
                            
                        self.tasknames.removeAll()
                        self.taskstatus.removeAll()
                        for taskname in tasknames{
                            
                            self.tasknames.append(taskname.documentID)
                            self.taskstatus.append(taskname.data()["status"] as! String)
                            
                        }
                       // print("totaltasks:\(self.tasknames[0])")
                    }
                    self.deleteTasksTableView.reloadData()
                    
                }
            }
           
        }
       
      //  self.tasksTableView.reloadData()
     
    }

    
}


extension DeleteTaskViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tasknames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "deleteTaskCell") as! deleteTaskCell
       
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.alpha = 0.5
        cell.label.text = self.tasknames[indexPath.row]
        
        
        if self.taskstatus[indexPath.row] == "Pending"{
            
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.1332711279, blue: 0.1742172837, alpha: 1)
        }else if self.taskstatus[indexPath.row] == "In progress"{
            
            cell.backgroundColor = #colorLiteral(red: 0.9990808368, green: 1, blue: 0.4584205747, alpha: 1)
        }else if self.taskstatus[indexPath.row] == "Done"{
        
            cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            
        }
        
        return cell
    }
    
    
    
    
    
    
    
}
