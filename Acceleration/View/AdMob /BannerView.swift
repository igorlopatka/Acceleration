//
//  BannerView.swift
//  Acceleration
//
//  Created by Igor Łopatka on 07/03/2023.
//

import Foundation
import GoogleMobileAds
import UIKit
import SwiftUI

struct BannerView: UIViewControllerRepresentable {
  @State private var viewWidth: CGFloat = .zero
  private let bannerView = GADBannerView()
  private let adUnitID = "ca-app-pub-3940256099942544/2934735716"

  func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = BannerViewController()
    bannerView.adUnitID = adUnitID
    bannerView.rootViewController = bannerViewController
    bannerView.delegate = context.coordinator
    bannerViewController.view.addSubview(bannerView)
    bannerViewController.delegate = context.coordinator

    return bannerViewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    guard viewWidth != .zero else { return }

    bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    bannerView.load(GADRequest())
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

    class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate
  {
    let parent: BannerView

    init(_ parent: BannerView) {
      self.parent = parent
    }

    // MARK: - BannerViewControllerWidthDelegate methods
    func bannerViewController(
      _ bannerViewController: BannerViewController, didUpdate width: CGFloat
    ) {
      parent.viewWidth = width
    }

    // MARK: - GADBannerViewDelegate methods
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("DID RECEIVE AD")
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("DID NOT RECEIVE AD: \(error.localizedDescription)")
    }
  }
}
