//
//  TopListTests.swift
//  TopListTests
//
//  Created by Derek Tseng on 2020/10/13.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import XCTest
@testable import TopList

class MangaViewModelMock: MangaViewModel {

    override func fetchNextTopMangas() {
        guard let urlString = Bundle(for: type(of: self)).path(forResource: "TestFile", ofType: nil) else { return }

        let url = URL(fileURLWithPath: urlString)
        let decoder = JSONDecoder()
        let data = try! Data(contentsOf: url, options: Data.ReadingOptions())
        guard let mangaList = try? decoder.decode(TopMangas.self, from: data) else {
            return
        }

        handleIncomingMangaList(mangaList)
    }

}

class TopListTests: XCTestCase {

    var viewModel: MangaViewModelMock! = nil
    var viewController: MangaViewController! = nil

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = MangaViewModelMock(mainTypePath: "", subTypePath: "")
        self.viewController = MangaViewController(viewModel: viewModel)
        UIApplication.shared.windows.first?.rootViewController = viewController
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRowCounts() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "Loading manga list into table view")
        DispatchQueue.main.async {
            self.viewController.loadViewIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                XCTAssert(self.viewController.topTableView.numberOfRows(inSection: 0) == 50)
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 5) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }

    func testFirstCell() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "First cell display right contents")
        DispatchQueue.main.async {
            self.viewController.loadViewIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let indexPath = IndexPath(row: 0, section: 0)
                if let cell = self.viewController.tableView(self.viewController.topTableView, cellForRowAt: indexPath) as? MangaTableViewCell {
                    XCTAssert(cell.rankLabel.text == "1")
                    XCTAssert(cell.titleLabel.text == "Kimetsu no Yaiba Movie: Mugen Ressha-hen")
                    XCTAssert(cell.typeLabel.text == " Movie ")
                    XCTAssert(cell.startDate.text?.hasSuffix("Oct 2020") ?? false)
                    XCTAssert(cell.endDate.text?.hasSuffix("Oct 2020") ?? false)
                    XCTAssertNotNil(cell.photoView.image)
                } else {
                    XCTAssert(false, "cell is not MangaTableViewCell")
                }
                expect.fulfill()
            }
        }

        waitForExpectations(timeout: 5) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }

    func testAddFavorite() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "Mangas can be added to favorite and removed from favorite")
        DispatchQueue.main.async {
            self.viewController.loadViewIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.viewModel.addToFavorite(row: 0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let indexPath = IndexPath(row: 0, section: 0)
                    if let cell = self.viewController.tableView(self.viewController.topTableView, cellForRowAt: indexPath) as? MangaTableViewCell {
                        XCTAssert(cell.favoriteButton.isSelected)
                    } else {
                        XCTAssert(false, "cell is not MangaTableViewCell")
                    }
                    expect.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 10) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }

        let expectFavoriteList = expectation(description: "Favorite mangas can be displayed in favorite list")
        DispatchQueue.main.async {
            self.viewController.filterSegmentedControl.selectedSegmentIndex = 1
            self.viewController.filterSegmentedControlValueChanged(self.viewController.filterSegmentedControl)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let indexPath = IndexPath(row: 0, section: 0)
                if let cell = self.viewController.tableView(self.viewController.favoriteTableView, cellForRowAt: indexPath) as? MangaTableViewCell {
                    XCTAssert(cell.titleLabel.text == "Kimetsu no Yaiba Movie: Mugen Ressha-hen")
                    XCTAssert(cell.favoriteButton.isSelected)
                } else {
                    XCTAssert(false, "cell is not MangaTableViewCell")
                }
                expectFavoriteList.fulfill()
            }
        }

        waitForExpectations(timeout: 10) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }

        let expectRemoveFavorite = expectation(description: "Favorite mangas can be removed from favorite list")
        DispatchQueue.main.async {
        self.viewModel.removeFavorite(row: 0)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssert(self.viewController.favoriteTableView.numberOfRows(inSection: 0) == 0)

            self.viewController.filterSegmentedControl.selectedSegmentIndex = 0
            self.viewController.filterSegmentedControlValueChanged(self.viewController.filterSegmentedControl)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let indexPath = IndexPath(row: 0, section: 0)
                if let cell = self.viewController.tableView(self.viewController.favoriteTableView, cellForRowAt: indexPath) as? MangaTableViewCell {
                    XCTAssert(cell.titleLabel.text == "Kimetsu no Yaiba Movie: Mugen Ressha-hen")
                    XCTAssert(!cell.favoriteButton.isSelected)
                } else {
                    XCTAssert(false, "cell is not MangaTableViewCell")
                }
                expectRemoveFavorite.fulfill()
            }
           }
        }

        waitForExpectations(timeout: 10) { (error) in
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }

}
