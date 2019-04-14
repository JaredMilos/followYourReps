//
//  APIResultTableViewController.swift
//  Follow Your Reps
//
//  Created by Jared Milos on 11/19/18.
//  Copyright © 2018 Jared Milos. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class APIResultTableViewController: UITableViewController, CustomCellDelegate, NoPhotoCustomCellDelegate {
    
    var zipCode: String?
    var officialArray = [String]()
    var positionArray = [String]()
    var imageURLArray = [String]()
    var twitterHandleArray = [String]()
    var twitterHandle = ""

    @IBAction func returnButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make request from Google Civic API based on user input ZIP code
        let url = URL(string: "https://www.googleapis.com/civicinfo/v2/representatives?address="+zipCode!+"&key=AIzaSyBRSvVycId45s4bWQBj8GOANBWIIj67svs")
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            do {
                //get results from Google Civic API
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let results = jsonResult["officials"] {
                        let resultsArray = results as! NSArray
                        
                        //Loop through results to populate arrays
                        for x in 0..<resultsArray.count {
                            let name = resultsArray[x] as! [String: AnyObject]
                            //Get official's name
                            self.officialArray.append(name["name"] as! String)
                            //If photo in API, get string, if not, load "No Photo" into array
                            if name["photoUrl"] != nil {
                                self.imageURLArray.append(name["photoUrl"] as! String)
                            } else {
                                self.imageURLArray.append("No photo")
                            }
                            //If Twitter handle available, add to array, if not, add empty string
                            if let channelsArray = name["channels"] as? NSArray {
                                for i in 0..<channelsArray.count {
                                    let channels = channelsArray[i] as! [String: String]
                                    if channels["type"] == "Twitter" {
                                        self.twitterHandle = channels["id"]!
                                    }
                                }
                            }
                            self.twitterHandleArray.append(self.twitterHandle)
                            self.twitterHandle = ""
                        }
                    }
                    //Positions/Titles for officials are in separate part of the API
                    if let officeResults = jsonResult["offices"] {
                        let resultsArray2 = officeResults as! NSArray
                        
                        //Populate positionArray with official's titles
                        for x in 0..<resultsArray2.count {
                            let position = resultsArray2[x] as! [String: AnyObject]
                            if let indiciesResult = position["officialIndices"] as? [Int] {
                                for _ in indiciesResult {
                                    self.positionArray.append(position["name"] as! String)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async { [weak self] in self?.tableView.reloadData()}
                }
            } catch {
                print(error)
            }
        })

        task.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return officialArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if imageURLArray[indexPath.row] != "No photo" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
            cell.delegate = self
            cell.indexPath = indexPath as NSIndexPath
        
            cell.repNameLabel.text = officialArray[indexPath.row]
            cell.repPositionLabel.text = positionArray[indexPath.row]
        
            cell.repImage.image = nil
            let url = URLRequest(url: URL(string: imageURLArray[indexPath.row])!)
            
            var skipFlag = false
        
            // check if the image is already in the cache
            if let imageToCache = imageCache.object(forKey: imageURLArray[indexPath.row] as NSString) {
                cell.repImage.image = (imageToCache as! UIImage)
                skipFlag  = true
            }
            
            // download the image asynchronously
            if skipFlag == false {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        skipFlag  = true
                    }
                    if skipFlag == false {
                        DispatchQueue.main.async {
                            // create UIImage
                            let imageToCache = UIImage(data: data!)
                            if imageToCache != nil {
                                // add image to cache
                                imageCache.setObject(imageToCache!, forKey: self.imageURLArray[indexPath.row] as NSString)
                                cell.repImage.image = (imageToCache)
                            } else {
                                cell.repImage.image = UIImage(named: "noPhoto")
                            }
                        }
                    }
                }
            task.resume()
            }
            
            print(twitterHandleArray)
            if twitterHandleArray[indexPath.row] == "" {
                cell.buttonOutlet.setImage(UIImage(named: "noTwitter"), for: UIControl.State.normal)
            }
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoPhotoCustomCell", for: indexPath) as! NoPhotoCustomCell
            
            cell.NPdelegate = self
            cell.indexPath = indexPath as NSIndexPath
            
            cell.NPRepLabelName.text = officialArray[indexPath.row]
            cell.NPPositionName.text = positionArray[indexPath.row]
            
            print(twitterHandleArray[indexPath.row])
            if twitterHandleArray[indexPath.row] == "" {
                cell.NPButtonOutlet.setImage(UIImage(named: "noTwitter"), for: UIControl.State.normal)
            }
            
            
            return cell
        }
    }
    
    func twitterIconPressed(at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let screenName = twitterHandleArray[ip.row]
            if screenName == "" {
                print("No Twitter acct")
                return
            } else {
                let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
                let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
                
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL as URL) {
                    application.open(appURL as URL)
                } else {
                    application.open(webURL as URL)
                }
            }
        }
    }
    
    func NPtwitterIconPressed(at indexPath: NSIndexPath?) {
        if let ip = indexPath {
            let screenName = twitterHandleArray[ip.row]
            if screenName == "" {
                print("No Twitter acct")
                return
            } else {
                let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
                let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
                
                let application = UIApplication.shared
                
                if application.canOpenURL(appURL as URL) {
                    application.open(appURL as URL)
                } else {
                    application.open(webURL as URL)
                }
            }
        }
    }
}
