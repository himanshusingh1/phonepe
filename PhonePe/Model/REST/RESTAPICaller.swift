//
//  RESTAPICaller.swift
//  PhonePe
//
//  Created by Himanshu Singh on 19/11/22.
//

import Foundation

class RESTAPICaller<endpoint: Endpoint, RESPONSE> where RESPONSE : Codable {
    enum RESTAPICallerErrors: Error {
        case jsonParserError
        case unknownError
    }

//    variables are abstracted to make use of Dependency injection
//     for example at runtime api caller can be switched can be the case in future instead of REST we will fetch data using some other transport layer
//     further, parser can be JSON parser or SOAP or plist parser
    private var restRequester: APICaller
    private var parser: ResponseParser
    init(requester:APICaller = BaseRestCaller(), parser: ResponseParser = JSONParser() ) {
        self.restRequester = requester
        self.parser = parser
    }

    func request(_ endpoint: Endpoint, result:  ( (Swift.Result<RESPONSE,Error>) -> Void)? ) {
        restRequester.request(endpoint: endpoint) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                result?(.failure(error))
                return
            }
            guard let data = data else {
                result?(.failure(RESTAPICallerErrors.jsonParserError))
                return
            }
            do {
                print(String(data: data, encoding: .utf8))
                let parsedJson = try self.parser.decode(RESPONSE.self, from: data)
                result?(.success(parsedJson))
            } catch {
                print(error)
                result?(.failure(RESTAPICallerErrors.jsonParserError))
            }
        }
    }
}
