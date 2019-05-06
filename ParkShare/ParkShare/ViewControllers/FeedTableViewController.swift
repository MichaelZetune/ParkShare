//
//  FeedTableViewController.swift
//  ParkShare
//
//  Created by Jonathan Bautista on 4/8/19.
//  Copyright © 2019 Michael Zetune. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedTableViewController: UITableViewController, FilterDelegate {
    
    var currentMaxCostFilter: Int = 100 // gets set again by FeedFilterViewController
    var posts = [PFObject]()
    

    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("view appeared")
        
        let query = PFQuery(className: "Post")
        query.includeKeys(["author", "title", "parkingImage", "description",
                           "location", "monthlyPrice", "parkingType", "availableDates", "phoneNumber"])
        query.limit = 100
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingCell") as! ListingCell

        let currentPost = posts[indexPath.section]
        let user = currentPost["author"] as! PFUser
        
        cell.titleLabel!.text = currentPost["title"] as? String
        cell.infospotLabel!.text = currentPost["description"] as? String
        
        cell.usernameLabel!.text = user["name"] as? String
        
        if let profilePicFile = user["profilePicture"] as? PFFileObject {
            let profilePicUrlString = profilePicFile.url!
            let profilePicUrl = URL(string: profilePicUrlString)!
            cell.profilepicImage.af_setImage(withURL: profilePicUrl)
        } else {
            cell.profilepicImage.image = UIImage(named: "default-avatar")
        }
        
        if let parkingImageFile = currentPost["parkingImage"] as? PFFileObject {
            let parkingImageUrlString = parkingImageFile.url!
            let parkingImageUrl = URL(string: parkingImageUrlString)!
            cell.parkingImage.af_setImage(withURL: parkingImageUrl)
        } else {
            // do nothing, we can leave the pic blank.
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("segue from feed table to feed filter")
        
        if (segue.identifier == "FeedTableToFeedFilterSegue"){
            let destFeedFilterViewController = segue.destination as! FeedFilterViewController
            destFeedFilterViewController.delegate = self
            destFeedFilterViewController.currentCostValue = currentMaxCostFilter
        }
    }
    
    func changeMaxCostValue(newValue: Int!) {
        currentMaxCostFilter = newValue
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
