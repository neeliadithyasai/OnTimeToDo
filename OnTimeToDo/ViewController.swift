//
//  ViewController.swift
//  OnTimeToDo
//
//  Created by adithyasai neeli on 2021-06-01.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sideview: UIView!
    @IBOutlet weak var sidetableview: UITableView!
    @IBOutlet weak var coverpic: UIImageView!
    @IBOutlet weak var profilepic: UIImageView!
    var isSideViewOpen : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "All Tasks"
        
        sideview.isHidden = true
        isSideViewOpen = false
        
        profilepic.layer.cornerRadius = 55
        profilepic.clipsToBounds = true
        let imageView =  UIImage(named: "sandwichbtn")
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(presentmenu) )
        button.image = imageView
        navigationItem.leftBarButtonItem = button
        navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        
        
        
        
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
    
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == sidetableview{
            
           return  4
        }else{
       return 10
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sidetableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "sidetablecell") as? UITableViewCell
            cell?.layer.cornerRadius = 12
            cell?.layer.masksToBounds = true
            cell?.layer.borderWidth = 1
            cell?.alpha = 0.5
            
            return cell!
        }else{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell") as? UITableViewCell
        cell?.layer.cornerRadius = 12
        cell?.layer.masksToBounds = true
        cell?.layer.borderWidth = 1
        cell?.alpha = 0.5
            return cell!
            
        }
        
       
    }
    
    
}
