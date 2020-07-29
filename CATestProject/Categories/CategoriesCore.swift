//
//  PartnersCore.swift
//  CATestProject
//
//  Created by Сергей Гаврилко on 21.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import ComposableArchitecture

struct CategoriesState: Equatable {
  var currentCategory: Category?
  var categories: [Category] = []
}

enum CategoriesAction: Equatable {
  case loadTriggered
  case response(Result<[Category], PartnersClient.Failure>)
  case categoryTriggered(Category?)
}

struct CategoriesEnvironment {
  var partnersClient: PartnersClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let categoriesReducer = Reducer<CategoriesState, CategoriesAction, CategoriesEnvironment> { state, action, environment in
  switch action {
  case .loadTriggered:
    struct CategoryId: Hashable {}
    return environment.partnersClient
      .categories()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(CategoriesAction.response)
      .cancellable(id: CategoryId(), cancelInFlight: true)

  case .response(.success(let response)):
    state.categories = response
    return .none

  case .response(.failure):
    return .none
  case .categoryTriggered(.some(let category)):
    state.currentCategory = category
    return .none
  case .categoryTriggered(.none):
    state.currentCategory = nil
    return .none
  }
}
