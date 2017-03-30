//
//  TestRingUITests.swift
//  TestRingUITests
//
//  Created by David Trivian S on 3/30/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import XCTest

class TestRingUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCUIDevice.shared().orientation = .portrait
        
        let app = XCUIApplication()
        let collectionViewsQuery2 = app.collectionViews
        let cellsQuery = collectionViewsQuery2.cells
        let trumpSignsHisEnergyIndependenceExecutiveOrderElementsQuery = cellsQuery.otherElements.containing(.staticText, identifier:"Trump Signs his Energy Independence Executive Order")
        trumpSignsHisEnergyIndependenceExecutiveOrderElementsQuery.buttons["Save Gallery"].tap()
        app.alerts["“TestRing” Would Like to Access Your Photos"].buttons["OK"].tap()
        app.alerts["Saved!"].buttons["OK"].tap()
        trumpSignsHisEnergyIndependenceExecutiveOrderElementsQuery.children(matching: .other).element.children(matching: .button).element.tap()
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        cellsQuery.otherElements.containing(.staticText, identifier:"Trump Signs his Energy Independence Executive Order").element.swipeDown()
        
        let cell = collectionViewsQuery2.children(matching: .cell).element(boundBy: 1)
        cell.swipeUp()
        cellsQuery.otherElements.containing(.staticText, identifier:"Then and now").element.swipeUp()
        cell.swipeUp()
        cellsQuery.otherElements.containing(.staticText, identifier:"No hugs for dog").staticTexts["21 hours ago"].swipeUp()
        cellsQuery.otherElements.containing(.staticText, identifier:"IT - Official Teaser Trailer").element.swipeUp()
        cellsQuery.otherElements.containing(.staticText, identifier:"My friend decided to try playing Rugby").element.swipeUp()
        
        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery.staticTexts["‘Cards Against Humanity’ Creator Just Pledged To Buy and Publish Congress’s Browser History"].swipeUp()
        
        let button = cellsQuery.otherElements.containing(.staticText, identifier:"This sphere is coated in Vantablack, the darkest pigment ever, making it look 2 dimensional").children(matching: .other).element.children(matching: .button).element
        button.tap()
        button.tap()
        doneButton.tap()
        app.statusBars.otherElements["2:30 AM"].tap()
        
        let slingshOtStaticText = collectionViewsQuery.staticTexts["slingsh_ot"]
        slingshOtStaticText.swipeDown()
        slingshOtStaticText.swipeLeft()
        collectionViewsQuery.staticTexts["Trump Signs his Energy Independence Executive Order"].swipeLeft()
        
    }
    
    func TestLandscapeProtrait(){
    
    }
    
}
