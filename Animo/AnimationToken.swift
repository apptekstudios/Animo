//
//  AnimationToken.swift
//  Animo-iOS
//
//  Created by ApptekStudios on 22/9/18.
//  Copyright © 2018 ApptekStudios. All rights reserved.
//

import Foundation
import QuartzCore

public final class AnimationToken {
  let animationKey: String
  private weak var animationLayer: CALayer?

  internal var onCompletion: (()->Void)?

  init(key: String, animationLayer: CALayer, onCompletion: (()->Void)? = nil) {
    self.animationKey = key
    self.animationLayer = animationLayer
    self.onCompletion = onCompletion
  }
  func cancelAnimation(ignoringCompletionBlock ignoreCompletion: Bool = false) {
    if ignoreCompletion {
      onCompletion = nil
    }
    animationLayer?.removeAnimation(forKey: animationKey)
  }
}
