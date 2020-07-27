//
//  PartnersFlowCore.swift
//  CATestProject
//
//  Created by Сергей Гаврилко on 21.07.2020.
//  Copyright © 2020 Сергей Гаврилко. All rights reserved.
//

import ComposableArchitecture

struct PartnersFlowState: Equatable {
//  var currentCategory: Category?
  var categories: [Category] = []
  var partners: [Partner] = []
}

extension PartnersFlowState {
  var categoriesState: CategoriesState {
    get {
      CategoriesState(
//        currentCategory: currentCategory,
        categories: categories
      )
    }
    set {
//      currentCategory = newValue.currentCategory
      categories = newValue.categories
    }
  }
  
  var partnersState: PartnersState {
    get {
      PartnersState(
//        currentCategory: currentCategory,
        partners: partners
      )
    }
    set {
//      currentCategory = newValue.currentCategory
      partners = newValue.partners
    }
  }
}

enum PartnersFlowAction {
  case categories(CategoriesAction)
  case partners(PartnersAction)
}

struct PartnersFlowEnvironment {
  var partnersClient: PartnersClient
  var mainQueue: AnySchedulerOf<DispatchQueue>
}

let partnersFlowReducer = Reducer<PartnersFlowState, PartnersFlowAction, PartnersFlowEnvironment>.combine(
  categoriesReducer.pullback(
    state: \.categoriesState,
    action: /PartnersFlowAction.categories,
    environment: {
      CategoriesEnvironment(
        partnersClient: $0.partnersClient,
        mainQueue: $0.mainQueue
      )
    }
  ),
  partnersReducer.pullback(
    state: \.partnersState,
    action: /PartnersFlowAction.partners,
    environment: {
      PartnersEnvironment(
        partnersClient: $0.partnersClient,
        mainQueue: $0.mainQueue
      )
    }
  )
)
