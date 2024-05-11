//
//  PlacesViewModel.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import Foundation
import CoreLocation

enum PlacesViewModelState {
    case initialized
    case userLocationNotEnabled
    case userLocationEnabled
    case didReceivedUserLocation
    case fetchingNewData(page: Int, venues: [Venue])
    case didFetchedNewData(page: Int, venues: [Venue])
    
    case errorOccured
}

protocol PlacesViewModelDelegates: AnyObject {
    func didStateChanged(state: PlacesViewModelState)
}
class PlacesViewModel: NSObject {
    
    private(set) var state: PlacesViewModelState = .initialized
    weak var delegate: PlacesViewModelDelegates? {
        didSet {
            self.delegate?.didStateChanged(state: self.state)
        }
    }
    
    var query: String? {
        didSet {
            loadData(page: 0, perPage: 10, range: self.range)
        }
    }
    var range: Double = 1 {
        didSet {
            loadData(page: 0, perPage: 10, range: self.range)
        }
    }
    
    var venues: [Venue] = []
    lazy var paginator: Paginator = { .init(delegate: self) }()
    private let locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D? {
        didSet {
            self.delegate?.didStateChanged(state: .didReceivedUserLocation)
        }
    }
    private let apiRepo = NearByAPIRepo()
    private let dataRepo = NearByDataRepo()
    lazy var repoLayer: NearByRepositoryLayer = {  NearByRepositoryLayer(dataRepo: self.dataRepo, api: self.apiRepo) }()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    func loadLastSession() {
        let result = repoLayer.loadCached()
        switch result {
        case .success(let success):
            self.venues = success
            self.delegate?.didStateChanged(state: .didFetchedNewData(page: 1, venues: self.venues))
        case .failure:
            self.loadData(page: 0, perPage: 10)
        }
    }
    func accessUserLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    func loadData(page: Int, perPage: Int, range: Double? = nil, query: String? = nil) {
        
        if page == 0 {
            venues = []
        }
        self.delegate?.didStateChanged(state: .fetchingNewData(page: page, venues: self.venues))
        repoLayer.fetchNearBYPlaces(lat: self.location?.latitude ?? 0.0, long: self.location?.longitude ?? 0.0, range: self.range, searchString: query ?? "", page: page + 1, perPage: perPage) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.venues = self.venues + success
                self.delegate?.didStateChanged(state: .didFetchedNewData(page: page, venues: self.venues))
            case .failure(let failure):
                self.delegate?.didStateChanged(state: .errorOccured)
            }
        }
    }
    
}
extension PlacesViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last?.coordinate
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        
        case .restricted:
            self.delegate?.didStateChanged(state: .userLocationNotEnabled)
        case .denied:
            self.delegate?.didStateChanged(state: .userLocationNotEnabled)
        case .authorizedAlways:
            self.delegate?.didStateChanged(state: .userLocationEnabled)
        case .authorizedWhenInUse:
            self.delegate?.didStateChanged(state: .userLocationEnabled)
        @unknown default:
            self.delegate?.didStateChanged(state: .userLocationNotEnabled)
            return
        }
    }
}
extension PlacesViewModel : PaginatorDelegate {
    func paginate(to page: Int, for paginator: Paginator) {
        self.loadData(page: page + 1, perPage: 10)
    }
}
