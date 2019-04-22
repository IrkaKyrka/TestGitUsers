//
//  UserDetailController.swift
//  TestGitUsers
//
//  Created by Ira Golubovich on 2/18/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit

class UserDetailController: UIViewController {
    
    var login: String?
    
    lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        
        var center = self.view.center
        if let navigationBarFrame = self.navigationController?.navigationBar.frame {
            center.y -= (navigationBarFrame.origin.y + navigationBarFrame.size.height)
        }
        
        activityIndicatorView.center = center
        
        self.view.addSubview(activityIndicatorView)
        return activityIndicatorView
    }()
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        guard let login = self.login else { return }
        Service.shared.getData(method: "users/\(login)", since: nil) { (data) in
            
            do{
                let downloadedUser = try JSONDecoder().decode(UserDetails.self, from: data)
                if let imageUrl = URL(string: downloadedUser.avatar_url!) {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: imageUrl)
                        if let data = data{
                            let image = UIImage(data: data)
                            DispatchQueue.main.async {
                                self.avatar.image = image
                                
                                if let name = downloadedUser.name {
                                    self.name.text = "User Name: \(name)"
                                }
                                
                                if let email = downloadedUser.email {
                                    self.email.text = "Email: \(email)"
                                } else {
                                    self.email.text = nil
                                }
                                
                                if let company = downloadedUser.company {
                                    self.company.text = "Company: \(company)"
                                } else {
                                    self.company.text = nil
                                }
                                
                                if let following = downloadedUser.following {
                                    self.followingCount.text = "Following: \(String(following))"
                                }
                                
                                if let followers = downloadedUser.followers{
                                    self.followersCount.text = "Followers: \(String(followers))"
                                }
                                
                                self.creationDate.text = "Creation date: \(self.dateFormatting(date: downloadedUser.created_at))"
                                
                                self.activityIndicatorView.stopAnimating()
                            }
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        activityIndicatorView.startAnimating()
    }
    
    private func dateFormatting(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let newDate = dateFormatter.date(from:date)!
        
        return newDate.description
    }
    
}
