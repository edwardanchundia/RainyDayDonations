//
//  Classroom.swift
//  RainyDayDonation
//
//  Created by Edward Anchundia on 1/11/17.
//  Copyright © 2017 Margaret Ikeda, Simone Grant, Edward Anchundia, Miti Shah. All rights reserved.
//

import Foundation

class Classroom {
    let lat: String
    let long: String
    let proposalURL: String
    let fundURL: String
    let title: String
    let schoolName: String
    let expirationDate: String
    
    init(lat: String, long: String, proposalURL: String, fundURL: String, title: String, schoolName: String, expirationDate: String) {
        
        self.lat = lat
        self.long = long
        self.proposalURL = proposalURL
        self.fundURL = fundURL
        self.title = title
        self.schoolName = schoolName
        self.expirationDate = expirationDate
    }
    convenience init?(classroomDict: [String : Any]) {
        guard let lat = classroomDict["latitude"] as? String,
            let long = classroomDict["longitude"] as? String,
            let proposalURL = classroomDict["proposalURL"] as? String,
            let fundURL = classroomDict["fundURL"] as? String,
            let title = classroomDict["title"] as? String,
            let schoolName = classroomDict["schoolName"] as? String,
            let expirationDate = classroomDict["expirationDate"] as? String else {
                print("Error assigning final data variables")
                return nil
        }
        
        self.init(lat: lat, long: long, proposalURL: proposalURL, fundURL: fundURL, title: title, schoolName: schoolName, expirationDate: expirationDate)
    }
    
    static func getClassrooms(data: Data) -> [Classroom]? {
        var classrooms = [Classroom]()
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        guard let dictContainingProposals = jsonData as? [String : Any] else {
            //the top layer is a dictionary
            print("No response")
            return nil
        }
        guard let proposals = dictContainingProposals["proposals"] as? [[String : Any]] else {
            //access the key proposals in the top dictionary
            print("didn't enter proposals")
            return nil
        }
        //below accesses the array of dictionaries that is proposal’s value and iterates through them
        for everyClassroomDict in 0..<proposals.count - 1 {
            //below saves the dictionary accessed as a variable
            let classroomDict = proposals[everyClassroomDict]
            //print("got classroomDict in proposals")
            
            if let newClassroomObject = Classroom(classroomDict: classroomDict) {
                classrooms.append(newClassroomObject)
            }
        }
        return classrooms
    }
}

