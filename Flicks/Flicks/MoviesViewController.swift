//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Singh, Uttam on 4/1/17.
//  Copyright © 2017 com.uttam.learning.ios. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var movies: [NSDictionary] = []
    var endPoint :String!
    var refreshControl: UIRefreshControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        // add refresh control to table view
        tableView.insertSubview(refreshControl, at: 0)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        callMovieAPI()
    }

    func checkNetworkConnections(){
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
            errorView.isHidden = true
            tableView.isHidden = false
        }
        else
        {
            print("Internet Connection not Available!")
            errorView.isHidden = false
            
            let screenSize: CGRect = UIScreen.main.bounds
            errorView.frame = CGRect(x: 0, y: 65, width: screenSize.width, height: 44)
            
            tableView.isHidden = true
            errorLabel.textAlignment = .center
            errorLabel.text = "Network Error"
            MBProgressHUD.hide(for: self.view, animated: false)
        }
    }
    func callMovieAPI(){
        //Starting progress bar
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //Check network connections before loading movie
        checkNetworkConnections()

        
        let baseUrl = "https://api.themoviedb.org/3/movie/"
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string : baseUrl + endPoint + "?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        print(responseDictionary)
                        self.movies =
                            responseDictionary["results"] as! [NSDictionary]
                        
                        self.tableView.reloadData()
                        
                        //Stop progress
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
        });
        task.resume()
    }
    
    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        print("Refreshing data...")
        callMovieAPI()
        refreshControl.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        if let poster_path = movie["poster_path"] as? String {
            let imageUrl = NSURL(string : baseUrl + poster_path)
            cell.movieImage.setImageWith(imageUrl! as URL)
        }
        
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies [(indexPath?.row)!]
        
        let detailViewController = segue.destination as! DetailViewController
        
        detailViewController.movie = movie
        
    }
    

}
