//
//  PartnersCore.swift
//  CATestProject
//
//  Created by Сергей Гаврилко on 21.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import ComposableArchitecture

struct PartnersState: Equatable {
  var currentCategory: Category?
  var partners: [Partner] = []
}

enum PartnersAction {
  case loadTriggered
  case response(Result<[Partner], PartnersClient.Failure>)
  case viewDisappeared
}

struct PartnersEnvironment {
  var partnersClient: PartnersClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let partnersReducer = Reducer<PartnersState, PartnersAction, PartnersEnvironment> { state, action, environment in
  switch action {
  case .loadTriggered:
    struct PartnerId: Hashable {}
    return environment.partnersClient
      .partners(state.currentCategory?.title ?? "")
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(PartnersAction.response)
      .cancellable(id: PartnerId(), cancelInFlight: true)

  case .response(.success(let response)):
    state.partners = response
    return .none

  case .response(.failure):
    return .none
    
  case .viewDisappeared:
    state.partners = []
    return .none
  }
}
