//
//  Bundle+AppIcon.swift
//  BarTab
//
//  Created by Johan Forsell on 2022-03-01.
//

import Foundation
import UIKit

extension Bundle {
  
  var icon: UIImage? {
    
    if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
       let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
       let files = primary["CFBundleIconFiles"] as? [String],
       let icon = files.last
    {
      return UIImage(named: icon)
    }
    
    return nil
  }
}
