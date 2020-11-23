import XCTest
@testable import DescriptiveFunctor

final class DescriptiveFunctorTests: XCTestCase {
    
    
    func testExample() {
        
        //declare a couple of function headers
        
        let foo : Header<Int, Int> = "foo"
        let bar : Header<Int, Double> = "bar"
        let qux : Header<Double, String> = "qux"
        let gna : Header<String, String> = "gna"
        
        let comp : Header<Int, String> = "comp"
        
        //time to create the compiler/interpreter!
        
        var functor = CompilerFunctor<String>()
        
        //write some code for the headers - except "comp"
        
        functor.implement(key: foo){$0 + 2}
        functor.implement(key: bar){Double($0)}
        functor.implement(key: qux){String($0)}
        functor.implement(key: gna){"Hello, World! The answer is: \($0)"}
        
        //write a program
        
        let program = Program {
            foo
            bar
            qux
            gna
        }
        
        //make sure the program compiles and can be assignes to "comp"
        
        XCTAssertNoThrow(try functor.implement(key: comp,
                                              program: program))
        
        //do the same calculation using the compiled program "program", the compiled program "comp" and with the interpreter
        
        guard
            let compiled = (try? functor.compile(program)).map({$0(40)}),
            let compiled2 = (try? functor.compile(comp)).map({$0(40)}),
            let interpResult = try? functor.run(program, input: 40) else {
            //if any of the calculations fails, the test fails
            return XCTFail()
        }
        
        //make sure the interpreter result equals the expectation
        XCTAssertEqual(interpResult, "Hello, World! The answer is: 42.0")
        
        //make sure the other results equal the interpreter result
        XCTAssertEqual(compiled, interpResult)
        XCTAssertEqual(compiled2, interpResult)
        
        //write a program with an unknown identifier
        let nextProgram = program / "fail" / gna
        
        //make sure the compiler throws an error 
        XCTAssertThrowsError(try functor.compile(nextProgram))
        
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
