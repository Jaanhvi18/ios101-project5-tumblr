//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke


class ViewController: UIViewController, UITableViewDataSource {
    
    let refreshControl = UIRefreshControl()

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post] = []
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.addSubview(refreshControl)
            refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
            
            fetchPosts()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
            let post = posts[indexPath.row]

            cell.postLabel.text = post.summary

            if let photo = post.photos.first {
                let url = photo.originalSize.url
                Nuke.loadImage(with: url, into: cell.postImage)
            }
            
            return cell
        }
        
        @objc func refreshPosts() {
            fetchPosts()
        }
        
        func fetchPosts() {
            let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
            let session = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("❌ Error: \(error.localizedDescription)")
                    self.refreshControl.endRefreshing()
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                    print("❌ Response error: \(String(describing: response))")
                    self.refreshControl.endRefreshing()
                    return
                }
                
                guard let data = data else {
                    print("❌ Data is NIL")
                    self.refreshControl.endRefreshing()
                    return
                }
                
                do {
                    let blog = try JSONDecoder().decode(Blog.self, from: data)
                    
                    DispatchQueue.main.async { [weak self] in
                        let posts = blog.response.posts
                        self?.posts = posts
                        self?.tableView.reloadData()
                        self?.refreshControl.endRefreshing()
                        
                        print("✅ We got \(posts.count) posts!")
                    }
                    
                } catch {
                    print("❌ Error decoding JSON: \(error.localizedDescription)")
                    self.refreshControl.endRefreshing()
                }
            }
            session.resume()
        }
    }
