//
//  APIEndpointBaseEnum.swift
//  PhonePe
//
//  Created by Himanshu Singh on 19/11/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
//    as we have defined the base url in String extension we can use it
    var baseUrl: String { get }
    var path: String { get }
    var body: Data? { get }
    var headers: [String: Any]? { get }
    var queryParams: [String:String?]? { get }
}
extension Endpoint {
    var body: Data? { return nil }
    var headers: [String: Any]? { return nil }
    var queryParams: [String:String?]? { return nil }
}
extension Endpoint {
    var url:String {
        var urlComponent = URLComponents(string: baseUrl)
        urlComponent?.path = path
        urlComponent?.queryItems = self.queryParams?.map({ (name,value) in
            return URLQueryItem(name: name, value: value)
        })
        return urlComponent?.string ?? ""
    }
}
