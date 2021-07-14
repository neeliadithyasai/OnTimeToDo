//
//  GroupTasksViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-14.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class GroupTasksViewController: UIViewController {

    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var groupname:String?
    let db = Firestore.firestore()
    var tasknames = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = groupname
        populatetableview()
        self.hideKeyboardWhenTappedAround()
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        populatetableview()
    }

    @IBAction func AddTaskBtn(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: nil, message: "Create Task", preferredStyle: .alert)
        alertController.addTextField()
        alertController.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "ok", style: .default, handler: { [self]action in
            if let currentUser = Auth.auth().currentUser?.uid{
                if let answer = alertController.textFields![0].text{
                    
                    db.collection("users").document(currentUser).collection("groups").document(self.groupname!).collection(self.groupname!).document(answer).setData(["Description" : "" , "deadline":"", "status":"" , "groupname":self.groupname!])
                 
                       
                       
            
                }
            }
            
            let talertController = UIAlertController(title: nil, message: "task created", preferredStyle: .alert)
                talertController.addAction(UIAlertAction(title: "ok", style: .default, handler:{action in
                  self.populatetableview()
                  
                }))
            self.present(talertController, animated: true, completion: {populatetableview()})
          
        
        }))
        self.present(alertController, animated: true)
       
        
        
    
    }
    
    @IBAction func deleteTaskbtn(_ sender: Any) {
        
        populatetableview()
    }
    
    
  
    
    
    
    func populatetableview(){
        
        
        
        if let currentUser = Auth.auth().currentUser?.uid{
            
            db.collection("users").document(currentUser).collection("groups").document(self.groupname!).collection(self.groupname!).getDocuments { (data, error) in
                if error != nil{
                    return
                }else{
                    if let tasknames = data?.documents{
                            
                        self.tasknames.removeAll()
                        for taskname in tasknames{
                            
                            self.tasknames.append(taskname.documentID)
                        }
                       // print("totaltasks:\(self.tasknames[0])")
                    }
                    
                    
                }
            }
           
        }
       
        self.tasksTableView.reloadData()
     
    }
        
        
    
    
  

}

extension GroupTasksViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasknames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasktablecell") as? tasktablecell
        cell?.layer.cornerRadius = 12
        cell?.layer.masksToBounds = true
        cell?.layer.borderWidth = 1
        cell?.alpha = 0.5
        cell?.lbltaskname.text = self.tasknames[indexPath.row]
        return cell!
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let edittasksvc = self.storyboard?.instantiateViewController(identifier: "edittasksVC") as? EditTaskViewController{
            
            edittasksvc.taskname = self.tasknames[indexPath.row]
            self.navigationController?.pushViewController(edittasksvc, animated: true)
            
        }
    }
    
 
}
