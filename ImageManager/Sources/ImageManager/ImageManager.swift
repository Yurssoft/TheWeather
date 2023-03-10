import SwiftUI
import Kingfisher

public struct ImageManager {
    
}

public struct CachedImage: View {
    public init(urlString: String) {
        self.urlString = urlString
    }
    
    public let urlString: String
    public var body: some View {
        KFImage(URL(string: urlString)!)
            .fade(duration: 0.25)
    }
}
