//
//  Utils.swift
//  BookSeeker
//
//  Created by jiwoo.kang on 11/19/25.
//

import UIKit

func openURL(_ urlString: String?) {
    if let urlString, let url = URL(string: urlString),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    }
}
