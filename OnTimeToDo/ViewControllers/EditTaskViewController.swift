//
//  EditTaskViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-14.
//

import UIKit

class EditTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    
    var taskname: String?
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtDeadline: UITextField!
    @IBOutlet weak var txtStatus: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    
    let myPickerData = [String](arrayLiteral: "","Pending", "Done", "In progress")
    let thePicker = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = taskname
     
        txtStatus.inputView = thePicker
        thePicker.delegate = self
        thePicker.dataSource = self
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
        
        
    }
    
}
