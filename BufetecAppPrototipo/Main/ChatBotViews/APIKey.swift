//
//  APIKey.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/9/24.
//

import Foundation

enum APIKey {
    // Fetch the API key from 'Secrets.plist'
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")
        else {
            fatalError("Couldn't find file 'Secrets.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "GM_API_KEY") as? String else {
            fatalError("Couldn't find key 'GM_API_KEY' in 'Secrets.plist'.")
        }
        if value.starts(with: "_") {
            fatalError("Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
}
