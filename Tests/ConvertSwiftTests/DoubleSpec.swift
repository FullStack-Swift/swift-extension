import Foundation
import Nimble
import Quick
import ConvertSwift

class DoubleSpec: QuickSpec {
    
    override func spec() {
        
        describe("Double To String") {
            
            it("Double To String success") {
                let double: Double = 3.14
                let string: String = "3.14"
                expect(double.toString()).to(equal(string))
            }

        }

        it("Double To Int") {
            let double: Double = 3.14
            let int: Int = 3
            expect(double.toInt()).to(equal(int))
        }
    }
    
}
