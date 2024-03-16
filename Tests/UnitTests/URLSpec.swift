import Foundation
import Nimble
import Quick
import Transform

class URLSpec: QuickSpec {
  
  override func spec() {
    let string = "https://www.google.com/"
    let url = URL(string: string)
    
    it("Test URL") {
      expect(url?.toString()).to(equal(string))
    }
  }
}
