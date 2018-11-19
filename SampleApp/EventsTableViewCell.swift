//
//  EventsTableViewCell.swift
//  SampleApp
//
//  Created by Sanchit Mittal on 19/11/18.
//  Copyright © 2018 Sanchit Mittal. All rights reserved.
//

import UIKit
import SixgillSDK

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func configureCell(sensorData: Event) {
        
        let date = Date(timeIntervalSince1970: (TimeInterval(sensorData.timestamp) / 1000.0))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a, MMMM dd, yyyy"
        timestampLabel.text = dateFormatter.string(from: date)

         if let activity = sensorData.activitiesArray.firstObject as? Activity {
            activityLabel.text = activity.type
        }
        
        if let location = sensorData.locationsArray.firstObject as? Location {
            locationLabel.text = String(describing: location.latitude) + ", " + String(describing: location.longitude)
        }
    }

}
