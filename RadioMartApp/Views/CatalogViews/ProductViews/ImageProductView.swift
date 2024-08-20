//
//  ImageProductView.swift
//  RadioMartApp
//
//  Created by Denis Lyamtsev on 02.10.2023.
//

import SwiftUI
import Kingfisher


struct ImageProductView: View {
    var productURL: URL

    init(_ productURL: URL) {
        self.productURL = productURL
    }
  
    var body: some View {
        
        KFImage.url(productURL)
            .resizable()
            .placeholder{
                ProgressView()
            }
            .requestModifier(PSServer.requestModifier)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .onProgress { receivedSize, totalSize in  }
            .onSuccess { result in
              //  print(productURL.absoluteString)
            }
            .onFailure { error in
            }
    
           
    }
}

//#Preview {
//    ImageProductView()
//}
