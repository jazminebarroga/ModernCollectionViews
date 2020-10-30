//
//  KDrama.swift
//  moderncollectionviews
//
//  Created by Jazmine Paola Barroga on 10/29/20.
//  Copyright © 2020 jazminebarroga. All rights reserved.
//

import Foundation

struct KDrama: Hashable {
    let title: String
    let subtitle: String
    let image: String?
    let detail: [KDramaDetail]?
    let identifier = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: KDrama, rhs: KDrama) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct KDramaDetail: Hashable {
    let title: String
    let value: String
    let identifier = UUID()
}
