//
//  SessionManager.swift
//  ChainpointPOC
//
//  Created by Ghislain Leblanc on 2018-07-11.
//  Copyright © 2018 Leblanc, Ghislain. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

enum SessionManagerErrors: Error {
    case invalidNode
}

extension SessionManagerErrors: LocalizedError {
    public var localizedDescription: String? {
        switch self {
        case .invalidNode:
            return "Error finding random node."
        }
    }
}

struct Constants {
    static let randomNodesURL = "https://a.chainpoint.org/nodes/random"
    static let hashesURL = "/hashes"
}

class SessionManager {
    static let shared = SessionManager()

    var randomNodes: [Node]?

    func getRandomNodes(completionHandler: ((Error?) -> ())?) {
        Alamofire.request(Constants.randomNodesURL, method: .get).responseArray { [weak self] (response: DataResponse<[Node]>) in
            print(response.debugDescription)
            
            self?.randomNodes = response.result.value
            
            completionHandler?(nil)
        }
    }

    func postHash(hash: String, completionHandler: ((Error?) -> ())?) {
        guard let count = randomNodes?.count else {
            completionHandler?(SessionManagerErrors.invalidNode)
            return
        }

        let randomNodeIndex = Int(arc4random_uniform(UInt32(count)))

        guard let nodeURL = randomNodes?[randomNodeIndex].publicUri else {
            completionHandler?(SessionManagerErrors.invalidNode)
            return
        }

        let parameters: [String: Any] = [
            "hashes": [hash]
        ]

        Alamofire.request("\(nodeURL)\(Constants.hashesURL)", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            print(response.debugDescription)
            if let error = response.error {
                completionHandler?(error)
            } else {
                completionHandler?(nil)
            }
        }
    }
}
