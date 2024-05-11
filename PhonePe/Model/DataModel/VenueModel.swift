//
//  VenueModel.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
protocol Venue {
    var name: String { get }
    var displayAddress: String { get }
    var ticketURL: String { get }
}
struct VenueModel: Venue, Codable {
    let name: String
    let displayAddress: String
    var ticketURL: String
}
