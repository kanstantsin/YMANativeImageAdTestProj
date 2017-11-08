//
//  AdManager.swift
//  Test.ru
//
//  Created by Ildar Zalyalov on 30.10.2017.
//  Copyright © 2017 test.ru. All rights reserved.
//

import Foundation
import UIKit

/// Протокол мэнэджера, который умеет работать с рекламой и подгружать ее во вьюху
protocol AdManager {
    
    /// Сконфигурировать менеджер с помощью вьюхи, на которой будет отображаться реклама
    ///
    /// - Parameter viewForAd: вьюха для отображения рекламы
    func configure(with viewForAd: UIView, and webBrowserPresentingController: UIViewController)
    
    /// Подгрузить рекламу
    func loadAd()
}
