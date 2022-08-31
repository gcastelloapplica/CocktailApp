//
//  CocktailTests.swift
//  CocktailAppTests
//
//  Created by Gaspar on 29/08/2022.
//

import XCTest
@testable import CocktailApp

class CocktailTests: XCTestCase {
    
    var sut: URLSession!
    let networkMonitor = NetworkMonitor.shared
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }
    
    func testRandomApiCallCompletes() throws {
        try XCTSkipUnless(
            networkMonitor.isConnected,
            "Network connectivity needed for this test.")
        // given
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/random.php"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
}
