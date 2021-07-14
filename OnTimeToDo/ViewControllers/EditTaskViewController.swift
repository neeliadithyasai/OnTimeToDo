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
        
        
    }
    
}
