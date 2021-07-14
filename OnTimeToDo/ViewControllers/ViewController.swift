//
//  ViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-01.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    @IBOutlet weak var sideview: UIView!
    @IBOutlet weak var sidetableview: UITableView!
    @IBOutlet weak var coverpic: UIImageView!
    @IBOutlet weak var profilepic: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var btnAddTask: UIButton!
    @IBOutlet weak var btnDeleteTask: UIButton!
    @IBOutlet weak var TableAllTasks: UITableView!
    
    var isSideViewOpen : Bool = false
    let db = Firestore.firestore()
    var groupnames = [String]()
    var alltasks = [String]()
    var taskgroups = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "All Tasks"
     
       // Populatemaintable()
       
        sideview.isHidden = true
        isSideViewOpen = false
        
        profilepic.layer.cornerRadius = 55
        profilepic.clipsToBounds = true
        let imageView =  UIImage(named: "sandwichbtn")
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(presentmenu) )
        button.image = imageView
        navigationItem.leftBarButtonItem = button
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        Utilities.styleFilledButton(btnAddTask)
        Utilities.styleFilledButton(btnDeleteTask)
        //btnAddTask.frame.size = CGSize(width: 220, height: 35)
        greetUser()
      
        populatesidetable()
    
        self.hideKeyboardWhenTappedAround()
      
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        greetUser()
        populatesidetable()
        Populatemaintable()
    }
    
    @IBAction func btnSettings(_ sender: Any) {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: "editVC") as? EditViewController
     self.navigationController?.pushViewController(homeViewController!, animated: true)
    }
    func greetUser(){
        
        
      
        db.collection("users").getDocuments { (querySnapshot, error) in
            if error != nil{
                return
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let currentUser = Auth.auth().currentUser?.uid{
                            if let u = data["uuid"] as? String{
                                if u == currentUser{
                                    if let name = data["Name"] as? String , let email = data["email"] as? String {
                                        DispatchQueue.main.async {
                                           self.lblUserName.text = name
                                           self.lblEmail.text = email
                                            let itemimageurl = data["prourl"] as? String
                                            let url = URL(string: itemimageurl!)
                                               URLSession.shared.dataTask(with: url!) { (data, response, error) in
                                                   if error != nil{
                                                       print(error!)
                                                       return
                                                   }
                                                   
                                                   DispatchQueue.main.async(execute: {

                                                    self.profilepic.image = UIImage(data: data!)
//                                                        cell.imgitem.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
                                                       })
                                               }.resume()
                                            let coverimageurl = data["curl"] as? String
                                            let url2 = URL(string: coverimageurl!)
                                               URLSession.shared.dataTask(with: url2!) { (data, response, error) in
                                                   if error != nil{
                                                       print(error!)
                                                       return
                                                   }
                                                   
                                                   DispatchQueue.main.async(execute: {

                                                    self.coverpic.image = UIImage(data: data!)
                                                    self.coverpic.frame = CGRect(x: 0, y: 0, width: 240, height: 230)
//                                                        cell.imgitem.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
                                                       })
                                               }.resume()
                                            
                                        }
                                    }
                                    
                                  
                                    
                                }
                            }
                        }
                        
                    }}
            }
        }
        
    }

    
    
    @objc func presentmenu(){
        sidetableview.isHidden = false
        sideview.isHidden = false
        coverpic.isHidden = false
        self.view.bringSubviewToFront(sideview)
        if !isSideViewOpen {
            isSideViewOpen = true
            sideview.frame = CGRect(x: 0, y: 96, width: 3, height: 717)
            sidetableview.frame = CGRect(x: 0, y: 0, width: 0, height: 717)
            coverpic.frame = CGRect(x: 0, y: 0, width: 0, height: 717)
            UIView.setAnimationDuration(0.5)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            
            sideview.frame = CGRect(x: 0, y: 96, width: 240, height: 717)
            sidetableview.frame = CGRect(x: 0, y: 0, width: 240, height: 717)
            coverpic.frame = CGRect(x: 0, y: 0, width: 240, height: 717)
            UIView.commitAnimations()
        }
        
        else {
            sidetableview.isHidden = true
            sideview.isHidden = true
            coverpic.isHidden = true
            isSideViewOpen = false
            sideview.frame = CGRect(x: 0, y: 96, width: 240, height: 717)
            sidetableview.frame = CGRect(x: 0, y: 0, width: 240, height: 717)
            coverpic.frame = CGRect(x: 0, y: 0, width: 240, height: 717)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationDelegate(self)
            UIView.beginAnimations("TableAnimation", context: nil)
            sideview.frame = CGRect(x: 0, y: 96, width: 3, height: 717)
            sidetableview.frame = CGRect(x: 0, y: 0, width: 0, height: 717)
            coverpic.frame = CGRect(x: 0, y: 0, width: 0, height: 717)
            UIView.commitAnimations()
        }
       
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
                        
                        
                    }
                    
                    
                }
            }
          
        }
       
    
        self.sidetableview.reloadData()
    }
    
    
    
    func Populatemaintable(){
        
        if let currentUser = Auth.auth().currentUser?.uid{
            
            db.collection("users").document(currentUser).collection("groups").getDocuments { (data, error) in
                if error != nil{
                    return
                }else{
                    if let groupnames = data?.documents{
                            
                        self.alltasks.removeAll()
                        self.taskgroups.removeAll()
                        for groupname in groupnames{
                            
                          
                            self.db.collection("users").document(currentUser).collection("groups").document((groupname.documentID)).collection(groupname.documentID).getDocuments { (data, error) in
                                if error != nil{
                                    return
                                }else{
                                    if let tasknames = data?.documents{
                                           
                                        for taskname in tasknames{
                                            
                                            self.alltasks.append(taskname.documentID)
                                            self.taskgroups.append(groupname.documentID)
                                   
                                        }
                                        print("totaltasks:\(self.alltasks.count)")
                              
                                     self.TableAllTasks.reloadData()
                                      
                                    }
                                    
                                    
                                }
                            }
                            
                           
                            
                        }
                       
                     
                    }
                 
                    
                }
            }
          
        }
     
      
    }
    
    
    
    
    
    
}






extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sidetableview{
            
            return  groupnames.count
        }else{
            
          
            return self.alltasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sidetableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sidetablecell") as? sidetablecell
            cell?.layer.cornerRadius = 12
            cell?.layer.masksToBounds = true
            cell?.layer.borderWidth = 1
            cell?.alpha = 0.5
            cell?.lblname.text = self.groupnames[indexPath.row]
            
            return cell!
        }else{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as? maintablecell
        cell?.layer.cornerRadius = 12
        cell?.layer.masksToBounds = true
        cell?.layer.borderWidth = 1
        cell?.alpha = 0.5
        cell?.taskName.text = self.alltasks[indexPath.row]
            return cell!
            
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == sidetableview{
            
            if let grouptasksvc = self.storyboard?.instantiateViewController(identifier: "grouptasksVC") as? GroupTasksViewController{
                
                grouptasksvc.groupname = self.groupnames[indexPath.row]
                self.navigationController?.pushViewController(grouptasksvc, animated: true)
                
            }
            
            
        }else{
            
            
        }
    }
    
    
}
