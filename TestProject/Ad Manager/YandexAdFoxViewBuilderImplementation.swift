//
//  YandexAdFoxViewManager.swift
//  TestProject.ru
//
//  Created by Ildar Zalyalov on 08.11.2017.
//  Copyright © 2017 test.ru. All rights reserved.
//

import Foundation
import YandexMobileAds
import YandexMobileMetrica
import YandexMobileAds.YandexMobileNativeAds

/// Менеджер по работе с рекламой AdFox
class YandexAdFoxViewManager: NSObject, YMANativeAdLoaderDelegate, YMANativeAdDelegate, AdManager, YMANativeAdImageLoadingObserver {
    
    /// Ключ для метрики яндекса
    fileprivate let apiKey = "b0a8a309-bcea-4b76-84eb-d62aa536ca06"
    
    /// Уникальный id для рекламы
    fileprivate let blockId = "R-M-252144-2"
    
    /// UIView в который встраивается YMAAdView с рекламой
    fileprivate weak var parentContentView: UIView!
    
    /// Текущий контроллер для яндекса
    fileprivate weak var currentController: UIViewController!
    
    /// Загрузчик нативной рекламы
    fileprivate var adLoader: YMANativeAdLoader!
    
    /// Вьюха для отображения нативной рекламы
    fileprivate var nativeImageAdView: YMANativeImageAdView!
    
    
    /// Параметры для запроса в рекламу AdFox-а.
   /// Доставались из личного кабинета Adfox-а "код для вставки"
   lazy var requestParams: [String : String] = {
        
        var parameters = [String : String]()
        parameters["adf_ownerid"] = "255877"
        parameters["adf_p1"] = "byoax"
        parameters["adf_p2"] = "fksh"
        parameters["adf_pt"] = "b"
        
        return parameters
    }()
    
    func configure(with viewForAd: UIView, and webBrowserPresentingController: UIViewController) {
        
        YMMYandexMetrica.activate(withApiKey: apiKey)
        
        currentController = webBrowserPresentingController
        parentContentView = viewForAd
    }
    
    func loadAd() {
        
        let configuration = YMANativeAdLoaderConfiguration(blockID: blockId, loadImagesAutomatically: true)
        
        adLoader = YMANativeAdLoader(configuration: configuration)
        adLoader.delegate = self
        adLoader.loadAd(with: YMAAdRequest(location: nil, contextQuery: nil, contextTags: nil, parameters: requestParams))
    }
    
    //MARK: - Helpers
    
    func didLoadAd(_ ad: YMANativeGenericAd) {
        
        if let nativeImageAd = ad as? YMANativeImageAd {

            let nativeImageView = UIImageView(frame: parentContentView.frame)
            nativeImageAdView = YMANativeImageAdView(frame: parentContentView.frame)
            nativeImageAdView.imageView = nativeImageView
            
            do {
                try nativeImageAd.bindImageAd(to: nativeImageAdView, delegate: self)
            }
            catch let error {
                print("Error binding: \(error.localizedDescription)")
            }
            
            parentContentView.addSubview(nativeImageAdView)
            setupAdViewConstraints(with: parentContentView, adView: nativeImageAdView)
            
            nativeImageAdView.ad?.loadImages()
            nativeImageAdView.ad?.add(self)
        }
    }
    
    //MARK: - YMANativeAdImageLoadingObserver
    func nativeAdDidFinishLoadingImages(_ ad: YMANativeGenericAd) {
        
        print("Finish loading with result: \(ad)")
    }
    
    //MARK: - YMANativeAdDelegate
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return currentController
    }
    
    //MARK: - YMANativeAdLoaderDelegate
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeImageAd) {
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        let nsError = error as NSError
        
        print("Ошибка загрузки рекламы: \(nsError)")
    }
    
    func setupAdViewConstraints(with parentView: UIView, adView: UIView) {
        
        adView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addConstraint(NSLayoutConstraint(item: adView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0))
        
        parentView.addConstraint(NSLayoutConstraint(item: adView, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0))
        
        parentView.addConstraint(NSLayoutConstraint(item: adView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: 0))
        
        parentView.addConstraint(NSLayoutConstraint(item: adView, attribute: .right, relatedBy: .equal, toItem: parentView, attribute: .right, multiplier: 1, constant: 0))
    }
}
