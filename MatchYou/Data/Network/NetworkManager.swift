//
//  NetworkManager.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation
import FirebaseFirestore

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(table: String) async -> Result<[T], NetworkError>
}

public class NetworkManager {
    func fetchData<T: Decodable>(table: String) async -> Result<[T], NetworkError> {
        do {
            let documents = try await Firestore.firestore().collection(table).order(by: "date", descending: true).getDocuments().documents
            
            let datas = try documents.compactMap { document in
                return try document.data(as: T.self)
            }
            
            return .success(datas)
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
}
