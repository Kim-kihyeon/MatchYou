//
//  NetworkManager.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation
import Supabase

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(table: String, id: String, page: Int, pageSize: Int) async -> Result<[T], NetworkError>
    func saveData<T: Encodable>(table: String, data: T) async -> Result<Void, NetworkError>
    func deleteData(table: String, dataId: String) async -> Result<Void, NetworkError>
}

public class NetworkManager: NetworkManagerProtocol {
    private let client = SupabaseService.shared.client
    
    func fetchData<T: Decodable>(table: String, id: String, page: Int, pageSize: Int) async -> Result<[T], NetworkError> {
        do {
            let from = page * pageSize
            let to = from + pageSize - 1
            
            let query = client
                .from(table)
                .select()
                .eq("id", value: id)
                .range(from: from, to: to)
            
            let response = try await query.execute()
            
            let datas = try JSONDecoder().decode([T].self, from: response.data)
            
            return .success(datas)
            
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
    
    func saveData<T>(table: String, data: T) async -> Result<Void, NetworkError> where T : Encodable {
        do {
            let _ = try await client
                .from(table)
                .insert(data)
                .execute()
            return .success(())
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
    
    func deleteData(table: String, dataId: String) async -> Result<Void, NetworkError> {
        do {
            let _ = try await client
                .from(table)
                .delete()
                .eq("id", value: dataId)
                .execute()
            return .success(())
        } catch {
            return .failure(.requestFailed(error.localizedDescription))
        }
    }
}
