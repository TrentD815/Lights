//
//  ViewController.swift
//  Lights
//
//  Created by Trent Davis on 1/9/19.
//  Copyright © 2019 Trent Davis. All rights reserved.
//

import UIKit
import CoreBluetooth
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    let LeftButton = UIButton(frame: CGRect(x:0, y: 0, width: 0, height: 0))
    let MiddleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let RightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var centralManager : CBCentralManager!
    var raspberrypiPeripheral : CBPeripheral!
    var peripherals = Array<CBPeripheral>()
    var ServoCharacteristics = ["power" : "off", "direction" : "CCW"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Initialize CoreBluetooth Central Manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        
        view.addSubview(LeftButton)
        view.addSubview(MiddleButton)
        view.addSubview(RightButton)
        setupLayout()
        
        //Initial GPIO state
        led(state: "OFF")
        servomotor(state : "OFF", direction: "CCW")
        
    }
    //Test connection between database/app/raspberrypi
    func led(state: String){
        let ref = Database.database().reference()
        let post : [String : AnyObject] = ["state" : state as AnyObject]
        ref.child("led").setValue(post)
    }
    
    func servomotor(state: String, direction: String){
        let ref = Database.database().reference()
        let ref2 = Database.database().reference()
        let powerStatus : [String : AnyObject] = ["state" : state as AnyObject]
        let directionStatus : [String : AnyObject] = ["direction" : direction as AnyObject]
        ref.child("servomotor").setValue(powerStatus)
        ref2.child("servomotor").setValue(directionStatus)
        
    }
    
    private func setupLayout(){
        view.backgroundColor = .yellow
        
        //Left Light Switch
        
        LeftButton.backgroundColor = .blue
        LeftButton.setTitleColor(UIColor.white, for: .normal)
        LeftButton.setTitle("Left Light Switch", for: .normal)
        LeftButton.titleLabel?.font = .systemFont(ofSize : 36)
        LeftButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        LeftButton.translatesAutoresizingMaskIntoConstraints = false
        
        LeftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LeftButton.widthAnchor.constraint(equalToConstant: (view.bounds.size.height * 1)).isActive = true
        LeftButton.heightAnchor.constraint(equalToConstant: (view.bounds.size.height * (1/3))).isActive = true
        LeftButton.topAnchor.constraint(equalTo: view.topAnchor, constant : 0).isActive = true
        
        
        //Middle Light Switch
       
        MiddleButton.backgroundColor = .blue
        MiddleButton.layer.borderWidth = 4
        MiddleButton.layer.borderColor = UIColor.black.cgColor
        MiddleButton.setTitleColor(UIColor.white, for: .normal)
        MiddleButton.setTitle("Middle Light Switch", for: .normal)
        MiddleButton.titleLabel?.font = .systemFont(ofSize : 36)
        MiddleButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        MiddleButton.translatesAutoresizingMaskIntoConstraints = false
        
        MiddleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        MiddleButton.widthAnchor.constraint(equalToConstant: (view.bounds.size.height * 1)).isActive = true
        MiddleButton.heightAnchor.constraint(equalToConstant: (view.bounds.size.height * (1/3))).isActive = true
        MiddleButton.topAnchor.constraint(equalTo: LeftButton.bottomAnchor, constant : 0).isActive = true
        
        
        //Right Light Switch
        
        RightButton.backgroundColor = .blue
        RightButton.setTitle("Right Light Switch", for: .normal)
        RightButton.setTitleColor(UIColor.white, for: .normal)
        RightButton.titleLabel?.font = .systemFont(ofSize : 36)
        RightButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        RightButton.translatesAutoresizingMaskIntoConstraints = false
        
        RightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RightButton.widthAnchor.constraint(equalToConstant: (view.bounds.size.height * 1)).isActive = true
        RightButton.heightAnchor.constraint(equalToConstant: (view.bounds.size.height * (1/3))).isActive = true
        RightButton.topAnchor.constraint(equalTo: MiddleButton.bottomAnchor, constant : 0).isActive = true
    }
    
    
    @objc func buttonAction(sender: UIButton) {
        print("Button tapped")
        
        if LeftButton.backgroundColor == UIColor.blue {
            led(state: "ON")
            servomotor(state:"ON", direction: "CC")
            //servomotor(direction:"CW") //clockwise to turn on
            LeftButton.backgroundColor = UIColor.green
            
        }
        else {
            led(state: "OFF")
            servomotor(state: "OFF", direction : "CCW")
            //servomotor(direction: "CCW") //counter clockwise to turn off
            LeftButton.backgroundColor = UIColor.blue
        }
        //LeftButton.backgroundColor = .green
        //MiddleButton.backgroundColor = .green
        //RightButton.backgroundColor = .green
        sender.pulsate()
    }
}

extension ViewController : CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print(peripheral)
        print("hello2")
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            
            case .unknown:
                print("central.state is .unknown")
            case .resetting:
                print("central.state is .resetting")
            case .unsupported:
                print("central.state is .unsupported")
            case .unauthorized:
                print("central.state is .unauthorized")
            case .poweredOff:
                print("central.state is .poweredOff")
            case .poweredOn:
                print("central.state is .poweredOn")
                self.centralManager?.scanForPeripherals(withServices: nil, options : nil)
                print("hello")
        }
    }
}

