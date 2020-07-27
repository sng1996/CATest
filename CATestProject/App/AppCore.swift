//
//  AppCore.swift
//  CATestProject
//
//  Created by Сергей Гаврилко on 21.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
  var partners: PartnersFlowState = PartnersFlowState()
}

enum AppAction {
  case partners(PartnersFlowAction)
}

struct AppEnvironment {
  var networkClient: NetworkClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  partnersFlowReducer.pullback(
    state: \.partners,
    action: /AppAction.partners,
    environment: {
      PartnersFlowEnvironment(
        partnersClient: $0.networkClient.partnersClient,
        mainQueue: $0.mainQueue
      )
    }
  )
)

struct NetworkClient {
  let partnersClient: PartnersClient
}

extension NetworkClient {
  static let live = NetworkClient(
    partnersClient: PartnersClient.live
  )
}
