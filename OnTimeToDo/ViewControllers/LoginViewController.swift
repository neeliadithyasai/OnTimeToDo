//
//  LoginViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-09.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController
{
    
    @IBOutlet weak var txtemail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var switchRememberme: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        let ud = UserDefaults.standard
               let e = ud.string(forKey: "email")
               let p = ud.string(forKey: "password")
               
               if let em = e {
                   txtemail.text = "\(em)"
               }
               
               if let pa = p {
                   txtPassword.text = "\(pa)"
               }
    }
    

    @IBAction func btnLogin(_ sender: Any) {
        
        
        guard let email = txtemail.text, let password = txtPassword.text else { return }
           signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if (success) {
           
            
                   if self.switchRememberme.isOn
                                               {
                                                   self.setUserDefaults(email: email, password: password)
                                               }else
                                               {
                                                   self.removeUserDefaults()
                                               }

               message = "welcome!"
               let homeViewController = self.storyboard?.instantiateViewController(identifier: "homeVC") as? ViewController
            self.navigationController?.pushViewController(homeViewController!, animated: true)
             
               
               
            } else {
                message = "please check username or password."
                            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alertController, animated: true)
            }

       }
        
        
        
    }
    
    func setUserDefaults(email: String, password: String){

           UserDefaults.standard.set(email, forKey: "email")
           UserDefaults.standard.set(password, forKey: "password")
           
           let ud = UserDefaults.standard
           let email = ud.string(forKey: "email")
             self.txtemail.text = email
           let password = ud.string(forKey: "password")
             self.txtPassword.text = password
       }
       
       func removeUserDefaults(){
           UserDefaults.standard.removeObject(forKey: "email")
             UserDefaults.standard.removeObject(forKey: "password")
           self.txtemail.text = ""
           self.txtPassword.text = ""
       }
       
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
          Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
              if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                  completionBlock(false)
              } else {
                  completionBlock(true)
              }
          }
      }

}
