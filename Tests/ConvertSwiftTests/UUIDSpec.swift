import Foundation
import Nimble
import Quick
import ConvertSwift

class UUIDSpec: QuickSpec {
    
    var uuid = UUID()
    
    override func spec() {
        describe("UUID") {
            
            beforeEach {
                
            }
            
            
            it("Test UUID convert to String") {
                let uuid = UUID()
             
                expect(uuid).toNot(beNil())
                expect(uuid.toString()) == uuid.uuidString
            }
            
            it("Test UUID convert to String") {
                let uuidString = "37C83AF1-CB75-487C-92DD-5DDF378A7E6F"
                let uuid = UUID(uuidString: uuidString)!
                expect(uuid).toNot(beNil())
                expect(uuid.toString()) == uuidString
            }

        }
    }
}
