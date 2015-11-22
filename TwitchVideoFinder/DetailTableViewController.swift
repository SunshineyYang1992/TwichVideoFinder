//
//  DetailTableViewController.swift
//  TwitchVideoFinder
//
//  Created by Sunshine Yang on 11/21/15.
//  Copyright © 2015 SunshineYang. All rights reserved.
//

import UIKit


// Hard code url

var urlStringTopVideos = "https://api.twitch.tv/kraken/videos/top?+Talk+Shows&period=month"
let urlStringChannel = "https://api.twitch.tv/kraken/channels/twitch/videos?limit=10"

class DetailTableViewController: UITableViewController {
	
	// Hold Video 
	var video:[Video] = []
	var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

		
		self.navigationItem.rightBarButtonItem = self.editButtonItem()

		tableView.rowHeight = 300
		
		let xPoint = tableView.frame.size.width / 2 - 50
		let yPoint = tableView.frame.size.height / 2 - 50
		
		let waitView = UIActivityIndicatorView(frame: CGRect(x: xPoint, y: yPoint, width: 100, height: 100))
		waitView.activityIndicatorViewStyle = .WhiteLarge
		waitView.color = UIColor.blueColor()
		activityIndicator = waitView
		tableView.addSubview(activityIndicator)
		
		activityIndicator.startAnimating()
		
	    getDataFromTwitch(urlStringTopVideos)
		
    }
	
	override func setEditing(editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		tableView.setEditing(editing, animated: animated)
		
	}
	
	@IBAction func topVideosDidTap(sender: AnyObject) {
		
		activityIndicator.hidden = false
		navigationItem.title = "Top Videos"
		video.removeAll()
		getDataFromTwitch(urlStringTopVideos)
		tableView.reloadData()

	}
	
	@IBAction func topChannelDidTap(sender: AnyObject) {
		
		activityIndicator.hidden = false
		navigationItem.title = "Top Channel"

		video.removeAll()
		getDataFromTwitch(urlStringChannel)
		tableView.reloadData()
		

	}
	@IBAction func searchDidTap(sender: AnyObject) {
		navigationItem.title = "Search"
		let searchController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchController")
		navigationController?.pushViewController(searchController, animated: true)
	}
	
	// MARK: Helper method
	func getDataFromTwitch(urlString: String) {
		
		let session = NSURLSession.sharedSession()
		let url = NSURL(string: urlString)!
		let request = NSURLRequest(URL: url)
		
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			// GUARD: Was there an error?
			guard (error == nil) else {
				print("There was an error with your request: \(error)")
				return
			}
			
			// GUARD: Did we get a successful 2XX response?
			guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
				if let response = response as? NSHTTPURLResponse {
					print("Your request returned an invalid response! Status code: \(response.statusCode)!")
				} else if let response = response {
					print("Your request returned an invalid response! Response: \(response)!")
				} else {
					print("Your request returned an invalid response!")
				}
				return
			}
			
			// GUARD: Was there any data returned?
			guard let data = data else {
				print("No data was returned by the request!")
				return
			}
			
			// Parse JSON
			let parsedResult: AnyObject!
			do {
				parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
			} catch {
				parsedResult = nil
				print("Could not parse the data as JSON: '\(data)'")
				return
			}
			
			
			// GUARD: If "videos" keys in the result?
			guard let topVideosArray = parsedResult["videos"] as? [[String: AnyObject]] else {
				print("Cannot find keys 'videos' in \(parsedResult)")
				return
			}
			
			// Append videos
			for videos in topVideosArray {
				guard let videoTitle = videos["title"] as? String else {
					return
				}
				guard let decription = videos["description"] as? String else {
					return
				}
				guard let views = videos["views"] as? Int else {
					return
				}
				guard let channel = videos["channel"]!["name"] as? String else {
					return
				}
				guard let imageURLString = videos["preview"] as? String else {
					return
				}
				guard let length = videos["length"] as? Int else {
					return
				}
				guard let url = videos["url"] as? String else {
					return
				}
				self.video.append(Video(title: videoTitle, description: decription, views: "\(views) · views ", channel: channel, previewImageURL:imageURLString, thumbnail: imageURLString, length:"\(length)", url: url))
				
			}
			// refreshing using main queue
			dispatch_async(dispatch_get_main_queue(), {
				self.tableView.reloadData()
				self.activityIndicator.hidden = true

			})
		}
		task.resume()
		
	}
	
	
	// Format video length
	func timeFormatted(totalSeconds:Int) -> String {
		let seconds:Int = totalSeconds % 60
		let minutes:Int = (totalSeconds / 60) % 60
		return "\(minutes):\(seconds)"
		
	}
	
	
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

		return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return video.count
    }

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: VideoCell = tableView.dequeueReusableCellWithIdentifier("videoCell", forIndexPath: indexPath) as! VideoCell
		
		cell.videoTitle.text = video[indexPath.row].title
		cell.videoDescription.text = video[indexPath.row].description
		cell.videoViews.text = video[indexPath.row].views
		cell.videoChannel.text = video[indexPath.row].channel
		
		// Format time for video length
		let length = Int(video[indexPath.row].length)
		cell.length.text = "\(timeFormatted(length!))"
		

		let imageURL = NSURL(string: video[indexPath.row].previewImageURL)
		
		if let imageData = NSData(contentsOfURL: imageURL!) {
			
			cell.thumbnailImage.image = UIImage(data: imageData)?.circle
			cell.previewImage.image =  UIImage(data: imageData)
		}
        return cell
    }
	
	// MARK: - Table view delegate 
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == .Delete {
			video.removeAtIndex(indexPath.row)
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
			
		}
	}
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let string = video[indexPath.row].url
		UIApplication.sharedApplication().openURL(NSURL(string: string)!)
	}

}
