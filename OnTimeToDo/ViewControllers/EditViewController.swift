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
    var coverclicked = false
    var coverchanged = false
    var profilechanged = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        greetUser()
        self.hideKeyboardWhenTappedAround()
        profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        coverPic.frame = CGRect(x: 0, y: 0, width: 414, height: 276)
        profilePic.isUserInteractionEnabled = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(profileimage)))
        coverPic.isUserInteractionEnabled = true
        coverPic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(coverimage)))
        
    }
    
    
    @objc func coverimage()
    {
        
        let alertController = UIAlertController(title: nil, message: "please choose source", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [self] action in
            coverclicked = true
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [self]action in
            coverclicked = true
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
            
        }))
        
        self.present(alertController, animated: true)
        
    }
    
    
    @objc func profileimage()
    {
        
        let alertController = UIAlertController(title: nil, message: "please choose source", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { [self] action in
         
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [self]action in
    
            let vc = UIImagePickerController()
            vc.sourceType = .camera
            vc.allowsEditing = true
            vc.delegate = self
            present(vc, animated: true)
            
        }))
        
        self.present(alertController, animated: true)
        
        
        
        
  
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }

        // print out the image size as a test
        print(image.size)
        
        if coverclicked == true {
            
            self.coverPic.image = image
            coverclicked = false
            coverchanged = true
            
        }else{
            
            self.profilePic.image = image
            profilechanged = true
            
        }
      
        
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
            
            if profilechanged == true {
                
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
                            self.profilechanged = false
                        })
                        }
                        }
                if message != "no data changed!"{
                message += " Profile pic changed!"
                }else{
                message = " Profile pic changed!"
                }
            }
            
            
            if coverchanged == true {
                
                print("photo updated!")
                let  ref = Storage.storage().reference().child("coverimages").child(self.txtName.text!)
                let uploaddata = self.coverPic.image?.jpegData(compressionQuality: 0.5)
                let md = StorageMetadata()
                md.contentType = "image/png"
                ref.putData(uploaddata! , metadata: nil) { (metadata, error) in
                    if error == nil {
                        ref.downloadURL(completion: { (url, error) in
                         
                         let curl = String(describing: url!)
                        db.collection("users").document(self.docid!).updateData(["curl" : curl])
                            self.coverchanged = false
                        })
                        }
                        }
                if message != "no data changed!"{
                message += " cover pic changed!"
                }else{
                message = " cover pic changed!"
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
