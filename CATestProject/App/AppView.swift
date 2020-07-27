//
//  AppView.swift
//  CATestProject
//
//  Created by Сергей Гаврилко on 21.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
  let store: Store<AppState, AppAction> = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(
      networkClient: NetworkClient.live,
      mainQueue: DispatchQueue.main.eraseToAnyScheduler()
  ))

  var body: some View {
    CategoriesView(store: store.scope(state: { $0.partners }, action: AppAction.partners))
  }
}
