//
//  CommandsViewController.swift
//  openXCenabler
//
//  Created by Kanishka, Vedi (V.) on 27/04/17.
//  Copyright © 2017 Bug Labs. All rights reserved.
//

import UIKit
import openXCiOSFramework


class CommandsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // the VM
    var vm: VehicleManager!

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var responseLab: UILabel!
    
    @IBOutlet weak var busSeg: UISegmentedControl!
    @IBOutlet weak var enabSeg: UISegmentedControl!
    @IBOutlet weak var bypassSeg: UISegmentedControl!
    @IBOutlet weak var pFormatSeg: UISegmentedControl!
    
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var enabledLabel: UILabel!
    @IBOutlet weak var bypassLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    
    @IBOutlet weak var sendCmndButton: UIButton!

    @IBOutlet weak var acitivityInd: UIActivityIndicatorView!

    
    let commands = ["Version","Device Id","Passthrough CAN Mode","Acceptance Filter Bypass","Payload Format JSON"]
    
    var versionResp: String!
    var deviceIdResp: String!
    var passthroughResp: String!
    var accFilterBypassResp: String!
    var payloadFormatResp: String!

    var selectedRowInPicker: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        hideAll()
        
        acitivityInd.center = self.view.center
        acitivityInd.hidesWhenStopped = true
        acitivityInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        acitivityInd.isHidden = true
        
        // grab VM instance
        vm = VehicleManager.sharedInstance
        vm.setCommandDefaultTarget(self, action: CommandsViewController.handle_cmd_response)

        
        selectedRowInPicker = pickerView.selectedRow(inComponent: 0)
        print("selected row in picker...",selectedRowInPicker)
        populateCommandResponseLabel(rowNum: selectedRowInPicker)
        
        busSeg.addTarget(self, action: #selector(busSegmentedControlValueChanged), for: .valueChanged)
        enabSeg.addTarget(self, action: #selector(enabSegmentedControlValueChanged), for: .valueChanged)
        bypassSeg.addTarget(self, action: #selector(bypassSegmentedControlValueChanged), for: .valueChanged)
        pFormatSeg.addTarget(self, action: #selector(formatSegmentedControlValueChanged), for: .valueChanged)

    }
    
    // MARK: Commands Function

    @IBAction func sendCmnd() {
        let sRow = pickerView.selectedRow(inComponent: 0)
        print("selected row in picker...",sRow)
        
        switch sRow {
        case 0:
            responseLab.text = versionResp
            break
        case 1:
            responseLab.text = deviceIdResp
            break
        case 2:
            print("send passthrough command")

            let cm = VehicleCommandRequest()
            
            // look at segmented control for bus
            cm.bus = busSeg.selectedSegmentIndex + 1
            print("bus is ",cm.bus)
            
            
            if enabSeg.selectedSegmentIndex==0 {
                cm.enabled = true
            } else {
                cm.enabled = false
            }
            
            cm.command = .passthrough
            self.vm.sendCommand(cm)
            // activity indicator

            showActivityIndicator()
            
            break
        case 3:
            print("send filter bypass command")
            let cm = VehicleCommandRequest()
            
            // look at segmented control for bus
            cm.bus = busSeg.selectedSegmentIndex + 1
            print("bus is ",cm.bus)

            if bypassSeg.selectedSegmentIndex==0 {
                cm.bypass = true
            } else {
                cm.bypass = false
            }
            
            cm.command = .af_bypass
            self.vm.sendCommand(cm)
            showActivityIndicator()
            break
        case 4:
            print("send payload format command")
            let cm = VehicleCommandRequest()
            
            if pFormatSeg.selectedSegmentIndex==0 {
                cm.format = "json"
            } else {
                cm.format = "protobuf"
            }
            cm.command = .payload_format
            self.vm.sendCommand(cm)
            showActivityIndicator()
            break
        default:
            break
        }

    }
    
    // this function handles all command responses
    func handle_cmd_response(_ rsp:NSDictionary) {
        // extract the command response message
        let cr = rsp.object(forKey: "vehiclemessage") as! VehicleCommandResponse
        print("cmd response : \(cr.command_response)")
        
        // update the UI depending on the command type- version,device_id works for JSON mode, not in protobuf - TODO
        
        
        if cr.command_response.isEqual(to: "version") {
                versionResp = cr.message as String
        }
        if cr.command_response.isEqual(to: "device_id") {
                deviceIdResp = cr.message as String
        }
        
        if cr.command_response.isEqual(to: "passthrough") {
            passthroughResp = String(cr.status)
        }
        
        if cr.command_response.isEqual(to: "af_bypass") {
            accFilterBypassResp = String(cr.status)
        }
        
        if cr.command_response.isEqual(to: "payload_format") {
            payloadFormatResp = String(cr.status)
        }
        
        // update the label
        DispatchQueue.main.async {
            self.populateCommandResponseLabel(rowNum: self.selectedRowInPicker)
        }
    }
    
    // MARK: Segment Control Function
    
    func busSegmentedControlValueChanged() {
      
        print("bus segment value changed..")
        let selectedSegment = busSeg.selectedSegmentIndex
        print("selectedSegment..",selectedSegment)

    }

    func enabSegmentedControlValueChanged() {
        
        print("enab segment value changed..")
    }

    func bypassSegmentedControlValueChanged() {
        
        print("bypass segment value changed..")
    }
    
    func formatSegmentedControlValueChanged() {
        
        print("format segment value changed..")
    }
    
    // MARK: Picker Delgate Function

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return commands.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var rowTitle:NSAttributedString!
        
        rowTitle = NSAttributedString(string: commands[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print("selected row...",row)
        selectedRowInPicker = row
        populateCommandResponseLabel(rowNum: row)
        
    }
    
    // MARK: UI Function

    func populateCommandResponseLabel(rowNum: Int) {
        hideAll()
        hideActivityIndicator()

        switch rowNum {
        case 0:
            sendCmndButton.isHidden = true
            responseLab.text = versionResp
            break
        case 1:
            sendCmndButton.isHidden = true
            responseLab.text = deviceIdResp
            break
        case 2:
            sendCmndButton.isHidden = false
            responseLab.text = passthroughResp
            busLabel.isHidden = false
            busSeg.isHidden = false
            enabledLabel.isHidden = false
            enabSeg.isHidden = false
            break
        case 3:
            sendCmndButton.isHidden = false
            responseLab.text = accFilterBypassResp
            busLabel.isHidden = false
            busSeg.isHidden = false
            bypassLabel.isHidden = false
            bypassSeg.isHidden = false
            break
        case 4:
            sendCmndButton.isHidden = false
            responseLab.text = payloadFormatResp
            formatLabel.isHidden = false
            pFormatSeg.isHidden = false
            break
        default:
            sendCmndButton.isHidden = true
            responseLab.text = versionResp
        }
    }
    
    func hideAll() {
        busSeg.isHidden = true
        enabSeg.isHidden = true
        bypassSeg.isHidden = true
        pFormatSeg.isHidden = true
        busLabel.isHidden = true
        enabledLabel.isHidden = true
        bypassLabel.isHidden = true
        formatLabel.isHidden = true
    }
    
    func showActivityIndicator() {
        acitivityInd.startAnimating()
        self.view.alpha = 0.5
        self.view.isUserInteractionEnabled = false

    }
    func hideActivityIndicator() {
        acitivityInd.stopAnimating()
        self.view.alpha = 1.0
        self.view.isUserInteractionEnabled = true
        
    }
}