//
//  ViewController.swift
//  GetOnThatBus
//
//  Created by Julian Lee on 2/2/16.
//  Copyright © 2016 mobilemakers. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    //properties
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    var busStopsDict = NSDictionary()
    var busStopsArray = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        segmentedControl.layer.cornerRadius = 5;
        tableView.hidden = true;
        let url = NSURL(string: "https://s3.amazonaws.com/mmios8week/bus.json")
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                self.busStopsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                self.busStopsArray = self.busStopsDict.objectForKey("row") as! [NSDictionary]
                print(self.busStopsArray)
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    
    @IBAction func onViewSegmentButtonTapped(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            mapView.hidden = false;
            tableView.hidden = true;
        } else {
            mapView.hidden = true;
            tableView.hidden = false;
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        let currentBusStop = self.busStopsArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = currentBusStop.objectForKey("cta_stop_name") as? String
        let routesString = currentBusStop.objectForKey("routes") as? String
        cell.detailTextLabel?.text = "Available Routes:\n\((routesString)!)"
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.busStopsArray.count
    }
    
    
    
    
    
    
    
    
    
    
}