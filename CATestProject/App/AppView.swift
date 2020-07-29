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
  @State var selectedTab = 0
  
  var body: some View {
    TabView(selection: $selectedTab) {
      CategoriesView(store: store.scope(state: { $0.partners }, action: AppAction.partners))
        .tabItem {
          Image(systemName: "1.circle")
          Text("Партнеры")
      }.tag(0)
      Text("Что-то еще")
        .tabItem {
          Image(systemName: "2.circle")
          Text("Что-то еще")
      }.tag(1)
    }
  }
}
