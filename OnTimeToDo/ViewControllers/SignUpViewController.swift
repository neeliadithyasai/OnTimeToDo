//
//  SignUpViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-09.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class SignUpViewController: UIViewController , UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhnNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var coverPic: UIImageView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    var profileclicked = false
    var coverclicked = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileimage)))
        coverPic.isUserInteractionEnabled = true
        coverPic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverimage)))
    }
    
    
    @objc func profileimage(){
        profileclicked = true
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    @objc func coverimage(){
        coverclicked = true
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        if profileclicked == true || coverclicked == false {
            
            profilePic.image = image
            //  print(image.size)
            profileclicked = false
            //   print(profileclicked)
            
        }else if profileclicked == false || coverclicked == true  {
            
            coverPic.image = image
            print(image.size)
            coverclicked = false
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpButton(_ sender: Any) {
        
        let  ref = Storage.storage().reference().child("profileimages").child(self.txtName.text!)
        let  ref2 = Storage.storage().reference().child("coverimages").child(self.txtName.text!)
         let error = validateFields()
                           
                           if error == nil {
                           
                            let uploaddata = self.profilePic.image?.jpegData(compressionQuality: 0.5)
                          
                          let md = StorageMetadata()
                          md.contentType = "image/png"
                           ref.putData(uploaddata! , metadata: nil) { (metadata, error) in
                               if error == nil {
                                   ref.downloadURL(completion: { (url, error) in
                                    
                                    let prourl = String(describing: url!)
                              
                                    DispatchQueue.main.async {
                                    let uploaddata2 = self.coverPic.image?.jpegData(compressionQuality: 0.5)
                                    ref2.putData(uploaddata2! , metadata: nil) { (metadata, error) in
                                        if error == nil {
                                            ref2.downloadURL(completion: { (url, error) in
                                       
                        
                                              let durl = String(describing: url!)
                                              //  print("Done, url is \(String(describing: url))")
                                                self.additem(url: prourl , url2: durl)
                                             
                                             
                                             
                                            })
                                        }else{
                                            print("error \(String(describing: error))")
                                        }
                                        
                                    }
                                    }
                                     
//                                     let durl = String(describing: url!)
//                                     //  print("Done, url is \(String(describing: url))")
//                                     self.additem(url: durl)
                                    
                                    
                                    
                                   })
                               }else{
                                   print("error \(String(describing: error))")
                               }
                           }
                            
                            
         
         }else{
                                   
                                   let alertController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
                                       alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                       self.present(alertController, animated: true)
                                   
                           }
    }
    
    private func additem(url: String, url2: String){
        
        let error = validateFields()
                          
                          if error == nil {
                    
                          if let email = txtEmail.text, let password = txtPassword.text {
                            createUser(email: email, password: password , url: url , curl: url2) {[weak self] (success) in
                                  guard let `self` = self else { return }
                                  var message: String = ""
                                  if (success) {
                                      message = "User was sucessfully created."
                                 
                                  } else {
                                      message = "There was an error."
                                  }
                                  let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                                  alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                  self.present(alertController, animated: true)
                              }
                          }
                          }else{
                            
                            let alertController = UIAlertController(title: nil, message: error, preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alertController, animated: true)
                            
                    }
        
    }
    
    func createUser(email: String, password: String,url: String,curl: String , completionBlock: @escaping (_ success: Bool) -> Void) {
              Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
                  if let user = authResult?.user {
                      print(user)
                      completionBlock(true)

                 let name = self.txtName.text!
                 let email = self.txtEmail.text!
                 let phnNumber = self.txtPhnNumber.text!
                 let db = FirebaseFirestore.Firestore.firestore()
                    db.collection("users").document(authResult!.user.uid).setData(["Name":name, "email":email, "uuid": authResult!.user.uid,  "phoneNumber":phnNumber , "prourl": url  , "curl": curl])
                    self.clearfields()
                          
                          
                     
                   
                  } else {
                      completionBlock(false)
                  }
              }
          }
    
    
    func clearfields(){
        txtName.text?.removeAll()
        txtPhnNumber.text?.removeAll()
        txtPassword.text?.removeAll()
        txtRePassword.text?.removeAll()
        txtEmail.text?.removeAll()
 
    }

    
    
    func validateFields() -> String? {
        
        if txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtPhnNumber.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            txtRePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""  {
            
            return "Please fill in all fields."
        }
        if
            txtPassword.text?.trimmingCharacters(in: .whitespacesAndNewlines) !=
                txtRePassword.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            
            return "password does not match"
            
        }
        // Check if the password is secure
        let cleanedPassword = txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        
        return nil
    }
    
}
