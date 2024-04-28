//
//  Mockable.swift
//  ConcurrencyNetworkLayer
//
//  Created by Sharaf on 4/28/24.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJson<T:Decodable>(fileName: String, type: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJson<T:Decodable>(fileName: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("cantLoadJson")
        }
        do {
            let data = try Data(contentsOf: path)
            let decodeObject = try JSONDecoder().decode(type, from: data)
            return decodeObject
        } catch {
            fatalError("cantDecodeJson")
        }
    }
}
