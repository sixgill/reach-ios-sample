//
//  EventsTableViewController.swift
//  SampleApp
//
//  Created by Sanchit Mittal on 16/11/18.
//  Copyright © 2018 Sanchit Mittal. All rights reserved.
//

import UIKit
import SixgillSDK

class EventsTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, SensorUpdateDelegate {

    @IBOutlet weak var startStopButton: UIBarButtonItem!
    @IBOutlet weak var eventsTableView: UITableView!
    
    var events: [Event] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Tableview
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        
        // Hide back button
        navigationItem.hidesBackButton = true
        
        // Register to receive events
        SGSDK.register(forSensorUpdates: self)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsTableViewCellIdentifier", for: indexPath) as! EventsTableViewCell
        cell.configureCell(sensorData: events[indexPath.row])

        return cell
    }
    
    // MARK: - SensorUpdateDelegate
    
    // Receive events
    func sensorUpdateSent(withData sensorData: Event!) {
        events.insert(sensorData, at: 0)
        eventsTableView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func stopSDK(_ sender: UIBarButtonItem) {
        
        // Unregister to receive events
        SGSDK.register(forSensorUpdates: nil)
        
        // Stop SDK
        SGSDK.disable()
        
        UserDefaults.standard.set(false, forKey: Constants.IS_SDK_RUNNING)
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func forceSensorUpdateTapped(_ sender: UIButton) {
        SGSDK.forceSensorUpdate()
    }
    
}
