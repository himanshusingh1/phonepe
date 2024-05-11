//
//  NearbyPlacesRepo.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
enum NearbyPlacesRepoErrors: Error {
    case network(error: Error)
    case noCache
}
protocol NearbyRepository {
    func loadCached() -> Result<[Venue], NearbyPlacesRepoErrors>
    
    func fetchNearBYPlaces(lat: Double, long: Double, range: Double, searchString: String, page: Int, perPage: Int, completion: @escaping ( (Result<[Venue], NearbyPlacesRepoErrors>) -> Void ) )
}
