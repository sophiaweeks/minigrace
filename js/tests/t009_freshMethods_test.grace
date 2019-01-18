dialect "minitest"

import "util" as util
import "lexer" as lexer
import "parser" as parser
import "ast" as ast
import "identifierresolution" as identifierresolution

def input = ‹
method f0 {
    object {
        var x is public
    }
}

method ft0 {
    print "ft0 executed"
    f0
}

method f1(a) {
    object {
        var x is public
        method arg { a }
    }
}

method ft1(a) {
    print "ft1 executed"
    f1(a)
}
›.split "\n"

util.lines.clear
util.lines.addAll(input)
    // lexLines does this too, but then re-instates the old
    // input before returning.

def module = parser.parse ( lexer.lexLines (input) )
def decorated = identifierresolution.resolve(module)
def f0Method = decorated.body.first
def ft0Method = decorated.body.second
def f1Method = decorated.body.third
def ft1Method = decorated.body.fourth

//print "ft0 body = {ft0Method.body.last.pretty 1}"
//print ""
//print "ft1 body = {ft1Method.body.last.pretty 1}"

testSuite {
    test "f0 is fresh" by {
        assert (f0Method.nameString) shouldBe "f0"
        assert (f0Method.isFresh) description "method {f0Method.nameString} is not Fresh"
    }
    
    test "f0 returns Object" by {
        assert (f0Method.nameString) shouldBe "f0"
        assert (f0Method.returnsObject) description "method {f0Method.nameString} does not return an Object"
    }
    
    test "ft0 is fresh" by {
        assert (ft0Method.nameString) shouldBe "ft0"
//        assert (ft0Method.isFresh) description "method {ft0Method.nameString} is not Fresh\n{ft0Method.pretty 1}"
        assert (ft0Method.isFresh) description "method {ft0Method.nameString} is not Fresh"
    }

    test "f1 is fresh" by {
        assert (f1Method.nameString) shouldBe "f1(1)"
        assert (f1Method.isFresh) description "method {f1Method.nameString} is not Fresh\n{f1Method.pretty 1}"
    }
    
    test "f1 returns Object" by {
        assert (f1Method.nameString) shouldBe "f1(1)"
        assert (f1Method.returnsObject) description "method {f1Method.nameString} does not return an Object"
    }
    
    
    test "ft1 is fresh" by {
        assert (ft1Method.nameString) shouldBe "ft1(1)"
//        assert (ft1Method.isFresh) description "method {ft1Method.nameString} is not Fresh\n{ft1Method.pretty 1}"
        assert (ft1Method.isFresh) description "method {ft1Method.nameString} is not Fresh"
    }
}
