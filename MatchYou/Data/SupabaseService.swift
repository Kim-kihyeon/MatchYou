//
//  SupabaseService.swift
//  MatchYou
//
//  Created by 김견 on 3/12/25.
//

import Foundation
import Supabase

final class SupabaseService {
    static let shared = SupabaseService()
    
    let client: SupabaseClient
    let supabaseURL: URL = URL(string: Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String ?? "") ?? URL(string: "")!
    let supabaseKey: String = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String ?? ""
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
}
