//
//  RequestType.swift
//  denmokuplus
//
//  Created by devonly on 2021/10/26.
//  
//

import Foundation
import Alamofire

protocol RequestType: URLRequestConvertible {
    associatedtype ResponseType
    
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var encoding: ParameterEncoding { get }
    var parameters: Parameters? { get set }
}

extension RequestType {
    var baseURL: URL {
        URL(string: "https://denmoku.clubdam.com/dkdenmoku/")!
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var headers: [String: String]? {
        nil
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.timeoutInterval = TimeInterval(5)
        
        if let parameters = parameters {
            request = try encoding.encode(request, with: parameters)
        }
        return request
    }
}
