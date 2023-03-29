import Foundation
import Nimble
import Quick
import Transform

class FloatSpec: QuickSpec {
    
    override func spec() {
        it("Float to Int") {
            let float: Float = 3.01
            let int: Int = 3
            expect(float.toInt()) == int
        }
        
        it("Float to Double") {
            let float: Float = 3.14
            let double: Double = 3.14
            expect(float.toDouble()).to(equal(double))
        }
        
        it("Float to String") {
            let float: Float = 3.14
            let string: String = "3.14"
            expect(float.toString()).to(equal(string))
        }
    }
    
}
