//
//  VenuesAPIResponse.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
struct VenuesAPIResponse: Codable {
    let venues: [APIVenuModel]
}

// MARK: - Meta


// MARK: - Geolocation


// MARK: - Venue
struct APIVenuModel: Codable {
   
    let name: String
    
    let url: String
    
    let displayLocation: String

    enum CodingKeys: String, CodingKey {
        case name, url
        case displayLocation = "display_location"
    }
}

extension APIVenuModel: Venue {
    var displayAddress: String {
        self.displayLocation
    }
    
    var ticketURL: String {
        self.url
    }
}
