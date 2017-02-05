//
//  Project+Addition.swift
//  RainyDayDonation
//
//  Created by Edward Anchundia on 1/10/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import Foundation

extension Project {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        timestamp = NSDate()
    }
    
    var localizedDescription: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp! as Date)
    }
}
