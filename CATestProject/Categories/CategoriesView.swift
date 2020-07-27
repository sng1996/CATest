//
//  CategoriesView.swift
//  CATestProject
//
//  Created by Сергей Гаврилко on 21.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct CategoriesView: View {
  struct ViewState: Equatable {
    var categories: [Category] = []
//    var selectedCategory: Category?
  }
  
  enum ViewAction {
    case viewAppeared
    case categoryTapped(category: Category)
  }
  
  let store: Store<PartnersFlowState, PartnersFlowAction>
  let localStore: Store<CategoriesState, CategoriesAction>
  
  init(store: Store<PartnersFlowState, PartnersFlowAction>) {
    self.store = store
    self.localStore = store.scope(state: { $0.categoriesState }, action: PartnersFlowAction.categories)
  }

  var body: some View {
    WithViewStore(self.localStore.scope(state: { $0.viewState }, action: CategoriesAction.viewAction)) { viewStore in
      NavigationView {
        List {
          ForEach(viewStore.categories) { category in
            NavigationLink(
              destination: PartnersView(store: self.store)
//              tag: category,
//              selection: viewStore.binding(
//                get: { $0.selectedCategory },
//                send: ViewAction.categoryTapped(category: category)
//              )
            ) {
              HStack {
                Image(systemName: "person")
                Text(category.name)
              }
            }
          }
        }
        .navigationBarTitle("Партнеры")
      }
      .onAppear {
          viewStore.send(.viewAppeared)
      }
    }
  }
}

extension CategoriesState {
  var viewState: CategoriesView.ViewState {
    CategoriesView.ViewState(
      categories: categories
//      selectedCategory: currentCategory
    )
  }
}

extension CategoriesAction {
  static func viewAction(_ localAction: CategoriesView.ViewAction) -> Self {
    switch localAction {
    case .viewAppeared:
      return .loadTriggered
    case .categoryTapped(let category):
      return .categoryTriggered(category)
    }
  }
}
