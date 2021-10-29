//
//  Manager.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/26.
//  
//

import Foundation
import Combine
import Alamofire

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    static var task = Set<AnyCancellable>()
    let queue: DispatchSemaphore = DispatchSemaphore(value: 1)
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    static func publish<T: RequestType>(_ request: T) -> DataResponsePublisher<T.ResponseType> where T.ResponseType: Decodable {
        AF.request(request)
            .validate(statusCode: 200 ... 200)
            .validate(contentType: ["application/json"])
            .cURLDescription { request in
                print(request)
            }
            .publishDecodable(type: T.ResponseType.self, decoder: decoder)
    }
    
    static func signIn(damtomoId: String, password: String, completion: @escaping (DataResponse<Login.Response, AFError>) -> ()) {
        let request = Login(damtomoId: damtomoId, password: password)
        NetworkManager.publish(request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { response in
                completion(response)
            })
            .store(in: &task)
    }
}
