//
//  GenericRESTCaller.swift
//  PhonePe
//
//  Created by Himanshu Singh on 19/11/22.
//

import Foundation

protocol APICaller {
     func request(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class BaseRestCaller: APICaller {
     func request(endpoint: Endpoint, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {

        let session = URLSession.shared

//         URL
        guard let url = URL(string: endpoint.url) else {
//            this is made to crash to make sure developer keeps an eye on url in production it should be changed to handle the wrong url inputs
            fatalError("URL parsing failed this cannot create url from \(endpoint.url)")
            }
        var urlRequest = URLRequest(url: url)
       
//        HTTP Body
        urlRequest.httpBody = endpoint.body
        
//         HTTP Method
        urlRequest.httpMethod = endpoint.httpMethod.rawValue

//        Header fields
        endpoint.headers?.forEach({ header in
            urlRequest.setValue(header.value as? String, forHTTPHeaderField: header.key)
        })

        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion(data, response, error)
        }

        task.resume()
    }
}
