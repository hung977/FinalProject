import Foundation

public struct ProductResponse: Codable {

        public var items : [Product]
        public var totalItems : Int
        public var totalPages : Int
        public var pageSize : Int
        public var pageIndex : Int
        
}
public struct Product: Codable {

    public var name: String
    public var price: Double
    public var amount: Int
    public var image: String
    public var id: String
        
}
