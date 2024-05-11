//
//  GetMovieList+Endpoint.swift
//  PhonePe
//
//  Created by Himanshu Singh on 19/11/22.
//

import Foundation
enum GETVenueEndpoint: Endpoint {
    case getVenues(lat: Double, long: Double, query: String, range: Double, page: Int, perPage: Int)
    
    
    var httpMethod: HTTPMethod { return .get }
    var baseUrl: String { "https://api.seatgeek.com/2" }
    var path: String { "/venues"}
    var queryParams: [String : String?]? {
        switch self {
        case .getVenues(lat: let lat, long: let long, query: let query, range: let range, page: let page, perPage: let per_page):
            return ["per_page": "\(per_page)",
                    "client_id":"Mzg0OTc0Njl8MTcwMDgxMTg5NC44MDk2NjY5",
                    "page":"\(page)",
                    "lat": String(format: "%.2f", lat),
                    "lon": String(format: "%.2f", long),
                    "range": String(format: "%.1f", range) + "mi",
                    "q": query
            ]
        }
    }
    
}
