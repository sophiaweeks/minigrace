
def e = 2


    
method fib(n : Number) -> Number {
    match (n)
        case { 0 -> 0 }
        case { 0 -> 1 }
        else { fib(n-1) + fib(n-2) }
}

fib 0