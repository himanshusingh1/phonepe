//
//  GenericJSONParser.swift
//  PhonePe
//
//  Created by Himanshu Singh on 19/11/22.
//

import Foundation
protocol ResponseParser {
    func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T
}
class JSONParser: ResponseParser {
     func decode<T: Decodable >(_ type: T.Type, from data: Data) throws -> T {
        let decoder = try JSONDecoder().decode(type, from: data)
        return decoder
    }
}
