//
//  AppManager.swift
//  denmokuplus
//
//  Created by tkgstrator on 2021/10/26.
//  
//

import Foundation
import RealmSwift
import SwiftUI
import Gzip
import SwiftyJSON
import Combine
import simd
import zlib

final class AppManager: NetworkManager, ObservableObject {
    private let realm: Realm
    private let schemeVersion: UInt64 = 0
    @Published var appVersion: String = "0.0.1"
    @Published var releaseDate: String
    @Published var progress: Int = 0
    @Published var maxValue: Int = 0
    @AppStorage("APP_USER_CDMNO") var cdmNo: String = ""
    @AppStorage("APP_USER_DAMTOMOID") var damtomoId: String = ""
    @AppStorage("APP_FIRST_LAUNCH") var isFirstLaunch: Bool = true
    @AppStorage("APP_DEVIDE_QR") var qrcode: String = ""
    
    override init() {
        do {
            self.realm = try Realm()
        } catch {
            var config: Realm.Configuration = Realm.Configuration.defaultConfiguration
            config.deleteRealmIfMigrationNeeded = true
            config.schemaVersion = schemeVersion
            self.realm = try! Realm(configuration: config, queue: nil)
        }
        self.releaseDate = realm.objects(RealmRequest.self).sorted(byKeyPath: "releaseDate").last?.releaseDate ?? "1970-01-01"
    }
    
    private func save<T: Object>(_ object: T) {
        if realm.isInWriteTransaction {
            realm.create(T.self, value: object, update: .all)
        } else {
            try? realm.write {
                realm.create(T.self, value: object, update: .all)
            }
        }
    }
    
    private func save<T: Object>(_ objects: [T]) {
        if realm.isInWriteTransaction {
            for object in objects {
                realm.create(T.self, value: object, update: .all)
            }
        } else {
            realm.beginWrite()
            for object in objects {
                realm.create(T.self, value: object, update: .all)
            }
            try? realm.commitWrite()
        }
    }
    
    public func loadFromServer(completion: @escaping (Result<Bool, Error>) -> ()) {
        DispatchQueue(label: "RealmManager").async {
            guard let realm = try? Realm() else { return }
            let requestIds: Set<String> = Set(realm.objects(RealmRequest.self).map({ $0.requestNo }))
            let request = Publish(cdmNo: self.cdmNo)
            NetworkManager.publish(request)
                .sink(receiveValue: { response in
                    switch response.result {
                        case .success(let value):
                            let results: Set<String> = Set(value.searchResult.map({ "\($0.reqNo.prefix(4))-\($0.reqNo.suffix(2))" }))
                            let subtract = Array(results.subtracting(requestIds)).sorted()
                            
                            subtract
                                .publisher
                                .receive(on: DispatchQueue.main, options: nil)
                                .delay(for: 1, scheduler: RunLoop.main)
                                .flatMap(maxPublishers: .max(1), { NetworkManager.publish(Song(requestNo: $0)) })
                                .sink(receiveCompletion: { _ in
                                    completion(.success(true))
                                }, receiveValue: { response in
                                    switch response.result {
                                        case .success(let value):
                                            self.save(RealmRequest(from: value))
                                        case .failure(let error):
                                            print(error)
                                    }
                                })
                                .store(in: &NetworkManager.task)
                        case .failure(let error):
                            print(error)
                    }
                })
                .store(in: &NetworkManager.task)
        }
    }
    
    public func loadFromDatabase(completion: @escaping (Result<Bool, Error>) -> ()) {
        DispatchQueue(label: "RealmManager").async {
            guard let realm = try? Realm() else { return }
            guard let url: URL = Bundle.main.url(forResource: "database", withExtension: "gz") else { return }
            do {
                let data: Data = try Data(contentsOf: url)
                let request: Data = try data.gunzipped()
                let decoder: JSONDecoder = {
                    let decoder : JSONDecoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return decoder
                }()
                let response = try decoder.decode([Song.Local].self, from: request).chunked(by: 1000)
                for response in response {
                    if realm.isInWriteTransaction {
                        for response in response {
                            realm.create(RealmRequest.self, value: RealmRequest(from: response), update: .all)
                        }
                    } else {
                        realm.beginWrite()
                        for response in response {
                            realm.create(RealmRequest.self, value: RealmRequest(from: response), update: .all)
                        }
                        try? realm.commitWrite()
                    }
                    DispatchQueue.main.async {
                        withAnimation {
                            self.progress += response.count
                        }
                    }
                }
                completion(.success(true))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
