//
//  ViewController.swift
//  ChainpointPOC
//
//  Created by Ghislain Leblanc on 2018-07-11.
//  Copyright © 2018 Leblanc, Ghislain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SessionManager.shared.getRandomNodes { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let randomNodes = SessionManager.shared.randomNodes else {
                    return
                }
                
                print(randomNodes)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var planet: String

        switch indexPath.row {
        case 0:
            planet = "Mercury"
        case 1:
            planet = "Earth"
        case 2:
            planet = "Venus"
        case 3:
            planet = "Uranus"
        case 4:
            planet = "Mars"
        default:
            planet = "N/A"
        }

        let planetHash = planet.sha256()

        print("Buying \(planet) (\(planetHash))...")

        SessionManager.shared.postHash(hash: planet.sha256(), completionHandler: { (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
               print("Success.")
            }
        })
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Mercury"
        case 1:
            cell.textLabel?.text = "Earth"
        case 2:
            cell.textLabel?.text = "Venus"
        case 3:
            cell.textLabel?.text = "Uranus"
        case 4:
            cell.textLabel?.text = "Mars"
        default:
            break
        }

        return cell
    }
}

extension String {
    func sha256() -> String{
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }

        return hexString
    }
}
