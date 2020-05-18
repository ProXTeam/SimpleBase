//
//  Result.swift
//  movietrailer
//
//  Created by Le Hoang Do on 1/22/19.
//  Copyright © 2019 Lee. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
