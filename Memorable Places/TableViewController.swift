//
//  TableViewController.swift
//  Memorable Places
//
//  Created by Anil Allewar on 9/22/15.
//  Copyright © 2015 Anil Allewar. All rights reserved.
//

import UIKit
import MapKit

var placesArray = [PlacesData]()
var activePlaceIndex = -1

class TableViewController: UITableViewController {

    @IBOutlet var placesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // This is un-clear as to why the array has 1 element by default when we create a new one
        if placesArray.count == 0 {
            // Add the first place to be Taj Mahal by default
            let tajMahal = PlacesData()
            tajMahal.setCoordinates(CLLocationCoordinate2DMake(27.175268, 78.042198))
            tajMahal.setAddress("Taj Mahal, Agra, India")
            
            placesArray.append(tajMahal)
        }
    }
    
    override func viewDidAppear(animated:Bool) {
        placesTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return placesArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        print("The address at \(indexPath.row) is :"  + placesArray[indexPath.row].getAddress())
        
        // getAddress() doesn't show anything
        cell.textLabel?.text = String(placesArray[indexPath.row].getCoordinates())

        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            placesArray.removeAtIndex(indexPath.row)
            // reload the data
            placesTable.reloadData()
        }
    }
    
   // Set the active place index when we click on the row
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        activePlaceIndex = indexPath.row
        
        return indexPath
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newPlaceButtonSegue" {
            activePlaceIndex = -1
        }
    }
}

// Model to hold the coordinates and the associated address
class PlacesData {
    private var coordinates : CLLocationCoordinate2D!
    private var address : String = " "
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return coordinates
    }
    
    func setCoordinates(inputCoordinates:CLLocationCoordinate2D) -> Void {
        self.coordinates = inputCoordinates
    }
    
    func getAddress() -> String {
        return address
    }
    
    func setAddress(inputAddress:String) -> Void {
        self.address = inputAddress
    }
}
