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
                print("Success.")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func showResult(result: String) {
        let alert = UIAlertController(title: "Result", message: result, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

        }))

        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SessionManager.shared.planets[indexPath.row].hash = SessionManager.shared.planets[indexPath.row].name.sha256()

        print("Buying \(SessionManager.shared.planets[indexPath.row].name) (\(SessionManager.shared.planets[indexPath.row].hash!))...")

        SessionManager.shared.postHash(hash: SessionManager.shared.planets[indexPath.row].hash!, completionHandler: { [weak self] (error) in
            if let error = error {
                print(error.localizedDescription)
                self?.showResult(result: error.localizedDescription)
            } else {
                print("Success.")
                self?.showResult(result: "Success.")

                tableView.reloadData()
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

        let planet = SessionManager.shared.planets[indexPath.row]
        cell.textLabel?.text = planet.name

        guard let hash = planet.hash else {
            cell.detailTextLabel?.text = ""
            return cell
        }

        cell.detailTextLabel?.text = hash

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
