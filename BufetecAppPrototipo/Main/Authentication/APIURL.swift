//
//  APIURL.swift
//  BufetecAppPrototipo
//
//  Created by Ramiro Uziel Rodriguez Pineda on 08/10/24.
//

import Foundation

enum APIURL {
    // Fetch the API key from 'Secrets.plist'
    static var `default`: String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist")
        else {
            fatalError("Couldn't find file 'Secrets.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "API_URL") as? String else {
            fatalError("Couldn't find key 'API_URL' in 'Secrets.plist'.")
        }
        if value.starts(with: "_") {
            fatalError("Please define an API URL in Secrets.plist")
        }
        return value
    }
}
