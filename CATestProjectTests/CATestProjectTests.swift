//
//  CATestProjectTests.swift
//  CATestProjectTests
//
//  Created by Сергей Гаврилко on 20.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import Combine
import ComposableArchitecture
import XCTest
@testable import CATestProject

extension PartnersClient {
  static let mock = PartnersClient(
    categories: {
      Effect(value: [])
    },
    partners: { _ in
      Effect(value: [Partner(id: 1, name: "Связной", installmentMin: 3)])
    })
}

class CATestProjectTests: XCTestCase {
  
  func testCategoriesLoad() {
    let expected = [
      Category(id: "1", name: "Популярные", title: "popularpartners"),
    ]
    
    var mock = PartnersClient.mock
    mock.categories = { Effect(value: expected) }
    
    let store = TestStore(
      initialState: CategoriesState(),
      reducer: categoriesReducer,
      environment: CategoriesEnvironment(
        partnersClient: mock,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .send(.loadTriggered),
      .do {
        _ = XCTWaiter.wait(for: [self.expectation(description: "wait")], timeout: 0.1)
      },
      .receive(CategoriesAction.response(Result.success(expected))) {
        $0.categories = expected
      }
    )
  }
  
  func testCategoryTrigger() {
    let expected = Category(id: "1", name: "Популярные", title: "popularpartners")
    
    let store = TestStore(
      initialState: CategoriesState(),
      reducer: categoriesReducer,
      environment: CategoriesEnvironment(
        partnersClient: .mock,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .send(.categoryTriggered(expected)) {
        $0.currentCategory = expected
      }
    )
  }
  
  func testCategoryTriggerNil() {
    let store = TestStore(
      initialState: CategoriesState(),
      reducer: categoriesReducer,
      environment: CategoriesEnvironment(
        partnersClient: .mock,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
      )
    )
    
    store.assert(
      .send(.categoryTriggered(nil)) {
        $0.currentCategory = nil
      }
    )
  }
}
