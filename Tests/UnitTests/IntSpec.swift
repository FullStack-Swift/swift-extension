import Foundation
import Quick
import Nimble
import Transform

class IntSpec: QuickSpec {
  
  override func spec() {
    describe("Test Int") {
      
      beforeEach {
        
      }
      
      it("Int to String") {
        let int: Int = 100
        let string = "100"
        expect(int.toString()).to(equal(string))
      }
      
      it("Int to TimeInterval") {
        let int: Int = 100
        let timeInterval: TimeInterval = 100.0
        expect(int.toTimeInterval()).to(equal(timeInterval))
      }
      
      it("Int to Double") {
        let int: Int = 100
        let double: Double = 100.0
        expect(int.toDouble()).to(equal(double))
      }
      
    }
  }
}
