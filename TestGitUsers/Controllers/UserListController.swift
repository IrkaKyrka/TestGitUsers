//
//  UserListController.swift
//  TestGitUsers
//
//  Created by Ira Golubovich on 2/18/19.
//  Copyright © 2019 Ira Golubovich. All rights reserved.
//

import UIKit

class UserListController: UITableViewController {
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return refreshControl
    }()
    
    var users = [User]()
    var imageCache = [String: UIImage]()
    var loadingData = true
    var since = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        tableView.refreshControl = refresher
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell()}
        
        if let imageUrl = users[indexPath.row].avatar_url {
            DispatchQueue.global().async {
                if let cachedImage = self.imageCache[imageUrl] {
                    DispatchQueue.main.async {
                        cell.avatar.image = cachedImage
                    }
                }else{
                    let image = self.getImage(imageString: imageUrl)
                    self.imageCache[imageUrl] = image
                    DispatchQueue.main.async {
                        cell.avatar.image = image
                    }
                }
            }
        }
        
        cell.login.text = self.users[indexPath.row].login
        cell.id.text = String(self.users[indexPath.row].id)
        cell.avatar.layer.cornerRadius = cell.avatar.frame.size.width/2
        cell.avatar.clipsToBounds = true
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showUserDetails" {
            if let userDetails = segue.destination as? UserDetailController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if (tableView.cellForRow(at: indexPath) as? UserCell) != nil {
                        userDetails.login = users[indexPath.row].login
                    }
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 4 {
            if !loadingData {
                loadingData = true
                getUsers()
            }
        }
    }
    
    private func getImage(imageString: String) -> UIImage{
        
        var image = UIImage()
        
        if let imageUrl = URL(string: imageString){
            let data = try? Data(contentsOf: imageUrl)
            
            if let data = data{
                image = UIImage(data: data)!
            }
        }
        return image
    }
    
    private func getUsers() {
        Service.shared.getData(method: "users", since: since) { (data) in
            self.loadingData = false
            
            do{
                let downloadingUsers = try JSONDecoder().decode([User].self, from: data)
                self.users += downloadingUsers
                self.since = (downloadingUsers.last?.id)!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }catch let error {
                print(error)
            }
        }
    }
    
    @objc
    private func refreshData() {
        users = []
        since = 0
        getUsers()
        refresher.endRefreshing()
    }
    
}
