//
//  NearByDataRepo.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
struct NearByDataRepo: NearbyRepository {
    func loadCached() -> Result<[any Venue], NearbyPlacesRepoErrors> {
        guard let data = UserDefaults.standard.data(forKey: "venue") else {
            return .failure(.noCache)
        }
        do {
            let cache = try JSONDecoder().decode([VenueModel].self, from: data)
            return .success(cache)
        } catch {
            return .failure(.noCache)
        }
    }
    
    
    func addToCache(venues: [Venue]) {
        let models = venues.map({ VenueModel(name: $0.name, displayAddress: $0.displayAddress, ticketURL: $0.ticketURL) })
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(models)
            UserDefaults.standard.set(encodedData, forKey: "venue")
        } catch {
            print("Error encoding venue: \(error)")
        }
    }
    func fetchNearBYPlaces(lat: Double, long: Double, range: Double, searchString: String, page: Int, perPage: Int, completion: @escaping ((Result<[any Venue], NearbyPlacesRepoErrors>) -> Void)) {
        guard let data = UserDefaults.standard.data(forKey: "venue") else {
            completion(.failure(.noCache))
            return
        }
        do {
            let cache = try JSONDecoder().decode([VenueModel].self, from: data)
            completion(.success(cache))
        } catch {
            completion(.failure(.noCache))
        }
    }
    
}
