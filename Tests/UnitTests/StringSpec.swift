import Foundation
import Nimble
import Quick
import Transform

class StringSpec: QuickSpec {
  
  override func spec() {
    
    describe("String to Int") {
      
      it("String to Int success") {
        let string: String = "10"
        let int: Int = 10
        expect(string.toInt()).to(equal(int))
      }
      
      it("String to Int Fail") {
        let string: String = "swift"
        expect(string.toInt()).to(beNil())
      }
      
      it("String to Int Fail") {
        let string: String = "3.14"
        expect(string.toInt()).to(beNil())
      }
      
      
      it("String to Int Fail") {
        let string = "1,0"
        expect(string.toInt()).to(beNil())
      }
      
      it("String to Int Fail") {
        let string = "1.0"
        expect(string.toInt()).to(beNil())
      }
    }
    
    describe("String to Double") {
      it("String to Double Success") {
        let string: String = "3.14"
        let double: Double = 3.14
        expect(string.toDouble()).to(equal(double))
      }
      
      it("String to Double Success") {
        let string: String = "3"
        let double: Double = 3
        expect(string.toDouble()).to(equal(double))
      }
      
      it("String to Double Fail") {
        let string: String = "3."
        expect(string.toDouble()).toNot(beNil())
      }
      
      it("String to Double Fail") {
        let string: String = "3.m"
        expect(string.toDouble()).to(beNil())
      }
    }
  }
}
