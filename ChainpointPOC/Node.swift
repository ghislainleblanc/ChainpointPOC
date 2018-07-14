//
//  Node.swift
//  ChainpointPOC
//
//  Created by Ghislain Leblanc on 2018-07-11.
//  Copyright © 2018 Leblanc, Ghislain. All rights reserved.
//

import ObjectMapper

struct Node: Mappable {
    var publicUri: String?

    init?(map: Map) {
    }

    mutating func mapping(map: Map) {
        publicUri <- map["public_uri"]
    }
}
