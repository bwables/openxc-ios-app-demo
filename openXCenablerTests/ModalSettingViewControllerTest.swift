//
//  ModalSettingViewControllerTest.swift
//  openXCenablerTests
//
//  Created by Ranjan, Kumar sahu (K.) on 19/01/18.
//  Copyright © 2018 Ford Motor Company. All rights reserved.
//

import XCTest
@testable import openXCenabler
import openXCiOSFramework
class ModalSettingViewControllerTest: XCTestCase {
    
    var settingVC : modalSettingsView?
    var valueIs : Bool = false
     var Ip : String = "0.0.0.0:50001"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        settingVC = modalSettingsView()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //Test case for socket connection
    func testNetworkConnection()  {
      NetworkData.sharedInstance.connect(ip:"0.0.0.0", portvalue: 50001, completionHandler: { (success) in
        
        self.valueIs = success
      })
       
        XCTAssert(valueIs)
    }
    
    func testNetworkIpAdress(){
        if (Ip != ""){
            
            var myStringArr = Ip.components(separatedBy: ":")
            let ip = myStringArr[0] //"0.0.0.0"
            let port = Int(myStringArr[1]) //50001
            
            XCTAssert(ip == "0.0.0.0")
            XCTAssert(port == 50001)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
