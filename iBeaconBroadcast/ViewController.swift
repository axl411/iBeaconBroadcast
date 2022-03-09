//
//  ViewController.swift
//  iBeaconBroadcast
//
//  Created by Chao Gu on 2022/03/09.
//

import UIKit
import CoreLocation
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    lazy var peripheral: CBPeripheralManager = {
        CBPeripheralManager(delegate: self, queue: nil)
    }()

    let data: [String: Any] = {
        let uuid = UUID(uuidString:"fda50693-a4e2-4fb1-afcf-c6eb07647825")
        let major : CLBeaconMajorValue = 0
        let minor : CLBeaconMinorValue = 0
        let beaconID = "com.example.myDeviceRegion"

        let region = CLBeaconRegion(uuid: uuid!, major: major, minor: minor, identifier: beaconID)
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        return ((peripheralData as NSDictionary) as! [String : Any])
    }()

    private func alert(title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = peripheral

        let startButton = UIButton(primaryAction: UIAction(title: "Start Advertising", handler: { action in
            self.present(self.alert(title: "starting advertising"), animated: true, completion: nil)
            self.peripheral.startAdvertising(self.data)
        }))
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: startButton.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: startButton.centerYAnchor, constant: 40)
        ])

        let stopButton = UIButton(primaryAction: UIAction(title: "Stop Advertising", handler: { action in
            self.present(self.alert(title: "stopping advertising"), animated: true, completion: nil)
            self.peripheral.stopAdvertising()
        }))
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopButton)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: stopButton.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor, constant: -40)
        ])
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("unknown default")
        }
    }
}

