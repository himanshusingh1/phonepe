//
//  NearByAPIRepo.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
struct NearByAPIRepo: NearbyRepository {
    let apiCaller = RESTAPICaller<GETVenueEndpoint, VenuesAPIResponse>.init()

    func loadCached() -> Result<[any Venue], NearbyPlacesRepoErrors> {
        return .failure(.noCache)
    }
    
    func fetchNearBYPlaces(lat: Double, long: Double, range: Double, searchString: String, page: Int, perPage: Int, completion: @escaping ((Result<[any Venue], NearbyPlacesRepoErrors>) -> Void)) {
        apiCaller.request(GETVenueEndpoint.getVenues(lat: lat, long: long, query: searchString, range: range, page: page, perPage: perPage)) { result in
            switch result {
            case .success(let success):
                completion(.success(success.venues))
            case .failure(let failure):
                completion(.failure(.network(error: failure)))
            }
        }
    }
}
