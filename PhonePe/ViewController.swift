//
//  ViewController.swift
//  PhonePe
//
//  Created by Himanshu Singh on 11/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel: PlacesViewModel = .init()
    
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search venue"
        search.delegate = self
        return search
    }()
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 12
        slider.value = 1
        slider.isContinuous = false
        slider.addTarget(self, action: #selector(didSliderChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    override func loadView() {
        super.loadView()
        self.view.addSubview(searchBar)
        self.view.addSubview(slider)
        self.view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 32),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            slider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            slider.topAnchor.constraint(equalTo: tableView.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.accessUserLocation()
    }
   
}
extension ViewController: PlacesViewModelDelegates {
    func didStateChanged(state: PlacesViewModelState) {
        switch state {
        case .initialized:
            viewModel.loadLastSession()
            viewModel.accessUserLocation()
        case .userLocationNotEnabled:
            viewModel.accessUserLocation()
        case .userLocationEnabled:
            print("got the location")
        case .didReceivedUserLocation:
            viewModel.loadData(page: 0, perPage: 10)
        case .fetchingNewData:
            print("Show loader")
        case .didFetchedNewData:
            print("Hide loader")
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        case .errorOccured:
            print("Show Error")
        }
    }
}
extension ViewController {
    @objc func didSliderChanged(_ sender: UISlider) {
        print(sender.value)
        viewModel.range = Double(sender.value)
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.query = searchText
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.venues.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.venues[indexPath.row].name
        cell.detailTextLabel?.text = viewModel.venues[indexPath.row].displayAddress
        
        viewModel.paginator.viewingItemAt(indexPath: indexPath, currentItemCount: self.viewModel.venues.count)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let url = viewModel.venues[indexPath.row].ticketURL
        guard let url  = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    
}
