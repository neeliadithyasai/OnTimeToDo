//
//  EditTaskViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-14.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    var taskname: String?
    var groupname: String?
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtDeadline: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let myPickerData = [String](arrayLiteral: "","Pending", "Done", "In progress")
    let thePicker = UIPickerView()
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = taskname
        self.hideKeyboardWhenTappedAround()
        txtStatus.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        txtDeadline.inputView = datePicker
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        loadTask()
        
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
            txtDeadline.text = "\(day)-\(month)-\(year)"
            txtDeadline.resignFirstResponder()
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        myPickerData.count
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return myPickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtStatus.text = myPickerData[row]
        txtStatus.resignFirstResponder()
    }
   
    @IBAction func saveBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "update data ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "update", style: .default, handler: { (action) in
            self.updatedata()
         
            self.navigationController?.popViewController(animated: true)
           
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updatedata(){
    
        
        
        
        let db = Firestore.firestore()
        
        
        if let currentUser = Auth.auth().currentUser?.uid{
            
            db.collection("users").document(currentUser).collection("groups").document(self.groupname!).collection(self.groupname!).document(self.taskname!).updateData(["Description" : self.txtDescription.text , "status" : txtStatus.text , "deadline": txtDeadline.text])
        }
        
        
    
        
    }
    
    
    func loadTask(){
        
        let db = Firestore.firestore()
        
        
        if let currentUser = Auth.auth().currentUser?.uid{
            
            db.collection("users").document(currentUser).collection("groups").document(self.groupname!).collection(self.groupname!).getDocuments { (data, error) in
                if error != nil{
                    return
                }else{
                    if let tasknames = data?.documents{
                        
                        for task in tasknames{
                            
                            if task.documentID == self.taskname{
                                
                                let data = task.data()
                                
                                self.txtDescription.text = data["Description"] as? String
                                self.txtDeadline.text = data["deadline"] as? String
                                self.txtStatus.text = data["status"] as? String
                                
                                
                                
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
            }
           
        }
       
    }
    
}
