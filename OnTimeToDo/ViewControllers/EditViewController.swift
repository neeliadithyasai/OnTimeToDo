//
//  EditViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-09.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseFirestore

class EditViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var coverPic: UIImageView!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhnNo: UITextField!
    
    var name: String?
    var email: String?
    var phn: String?
    var docid: String?
    var clicked = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        greetUser()
        
        profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        coverPic.frame = CGRect(x: 0, y: 0, width: 414, height: 276)
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileimage)))
    }
    
    @objc func profileimage()
    {   clicked = true
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
        self.profilePic.image = image
        
    }
    
    func greetUser(){
        
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (querySnapshot, error) in
            if error != nil{
                return
            }
            else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        print(data)
                        if let currentUser = Auth.auth().currentUser?.uid{
                            if let u = data["uuid"] as? String{
                                if u == currentUser{
                                    if let name = data["Name"] as? String , let email = data["email"] as? String , let phn = data["phoneNumber"] as? String {
                                        DispatchQueue.main.async {
                                            self.docid = u
                                            self.txtName.text = name
                                            self.name = name
                                            self.txtEmail.text = email
                                            self.email = email
                                            self.txtPhnNo.text = phn
                                            self.phn = phn
                                            let itemimageurl = data["prourl"] as? String
                                            let url = URL(string: itemimageurl!)
                                            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                                                if error != nil{
                                                    print(error!)
                                                    return
                                                }
                                                
                                                DispatchQueue.main.async(execute: {
                                                    
                                                    self.profilePic.image = UIImage(data: data!)
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
                                                    
                                                    self.coverPic.image = UIImage(data: data!)
                                                    //                                                    self.coverpic.frame = CGRect(x: 0, y: 0, width: 240, height: 230)
                                                    //
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
    
    
    @IBAction func btnSave(_ sender: Any) {
        
        
        if let dfname = self.name ,let dfemail = self.email, let dfphn = self.phn{
            
            let db = FirebaseFirestore.Firestore.firestore()
            var message = "no data changed!"
            
            if self.txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) != dfname{
                
                
                
                db.collection("users").document(self.docid!).updateData(["Name" : self.txtName.text?.trimmingCharacters(in: .whitespacesAndNewlines) as Any])
                message = "Name changed!"
                
                
            }
            
            if self.txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) != dfemail {
                
                
                db.collection("users").document(self.docid!).updateData(["email" : self.txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) as Any])
                if message != "no data changed!"{
                message += " Email changed!"
                }else{
                    message = " Email changed!"
                }
                
            }
            
            if self.txtPhnNo.text?.trimmingCharacters(in: .whitespacesAndNewlines) != dfphn {
                
                db.collection("users").document(self.docid!).updateData(["phoneNumber" : self.txtPhnNo.text?.trimmingCharacters(in: .whitespacesAndNewlines) as Any])
                if message != "no data changed!"{
                message += " Phone Number changed!"
                }else{
                message = " Phone Number changed!"
                }
            }
            
            if clicked == true {
                
                print("photo updated!")
                let  ref = Storage.storage().reference().child("profileimages").child(self.txtName.text!)
                let uploaddata = self.profilePic.image?.jpegData(compressionQuality: 0.5)
                let md = StorageMetadata()
                md.contentType = "image/png"
                ref.putData(uploaddata! , metadata: nil) { (metadata, error) in
                    if error == nil {
                        ref.downloadURL(completion: { (url, error) in
                         
                         let prourl = String(describing: url!)
                        db.collection("users").document(self.docid!).updateData(["prourl" : prourl])
                
                        })
                        }
                        }
                if message != "no data changed!"{
                message += " Profile pic changed!"
                }else{
                message = " Profile pic changed!"
                }
            }
            
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                
                print("no updates to make")
                
            }))
            
            self.present(alertController, animated: true)
            
        }
        
        
        
    }
    
    
    
}
