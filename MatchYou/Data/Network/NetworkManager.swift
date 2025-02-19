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
    func saveData<T: Encodable>(table: String, data: T) async -> Result<Void, NetworkError>
    func deleteData(table: String, dataId: String) async -> Result<Void, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
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
    
    func saveData<T>(table: String, data: T) async -> Result<Void, NetworkError> where T : Encodable {
        let reference = Firestore.firestore().collection(table).document()
        
        do {
            let encodedData = try Firestore.Encoder().encode(data)
            try await reference.setData(encodedData)
            return .success(())
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
    
    func deleteData(table: String, dataId: String) async -> Result<Void, NetworkError> {
        do {
            try await Firestore.firestore().collection(table).document(dataId).delete()
            return .success(())
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
}
