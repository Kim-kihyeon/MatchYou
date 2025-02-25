//
//  NetworkManager.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation
import FirebaseFirestore

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(table: String, id: String) async -> Result<[T], NetworkError>
    func saveData<T: Encodable>(table: String, data: T) async -> Result<Void, NetworkError>
    func deleteData(table: String, dataId: String) async -> Result<Void, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
    private let db = Firestore.firestore()
    
    private var lastDocuments: [String: DocumentSnapshot] = [:]
    
    func fetchData<T: Decodable>(table: String, id: String) async -> Result<[T], NetworkError> {
        do {
            var query = db.collection(table)
                .order(by: "date", descending: true)
                .limit(to: 10)
            
            if let lastDocument = lastDocuments[table] {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            lastDocuments[table] = snapshot.documents.last
            
            let datas = try snapshot.documents
                .filter { $0.documentID == id }
                .compactMap { document in
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
            try await db.collection(table).document(dataId).delete()
            return .success(())
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
}
