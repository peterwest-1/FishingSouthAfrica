//
//  LoadingState.swift
//  FishingSouthAfrica
//
//  Created by Pete West on 2022/04/03.
//

import Foundation

enum LoadingState<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}


