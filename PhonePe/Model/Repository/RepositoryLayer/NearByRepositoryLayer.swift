//
//  VenueRepository.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
struct NearByRepositoryLayer: NearbyRepository {
    
    private let dataRepo: NearbyRepository
    private let apiRepo: NearbyRepository
    
    init(dataRepo: NearbyRepository, api: NearbyRepository) {
        self.dataRepo = dataRepo
        apiRepo = api
    }
    
    func loadCached() -> Result<[any Venue], NearbyPlacesRepoErrors> {
        return dataRepo.loadCached()
    }
    
    func fetchNearBYPlaces(lat: Double, long: Double, range: Double, searchString: String, page: Int, perPage: Int, completion: @escaping ((Result<[any Venue], NearbyPlacesRepoErrors>) -> Void)) {
        apiRepo.fetchNearBYPlaces(lat: lat, long: long, range: range, searchString: searchString, page: page, perPage: perPage, completion: completion)
    }
    
}
