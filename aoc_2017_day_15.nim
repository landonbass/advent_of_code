import strUtils

const factorA = 16807
const factorB = 48271
const divisor = 2147483647
const startA  = 722
const startB  = 354

type Iteration = object
    a : int
    b : int
    r : bool

proc genNextValue(p, f, m: int): int =
    result = low int
    var dp = (p * f).int mod divisor
    while dp mod m != 0:
        dp = (dp * f).int mod divisor
        
    result = dp

proc genValues(iteration: Iteration) : Iteration =
    let genA  = genNextValue(iteration.a, factorA, 4)
    let genB  = genNextValue(iteration.b, factorB, 8)
    let binA  = toBin(genA, 32)[16..31]
    let binB  = toBin(genB, 32)[16..31]
    let match = if binA == binB: true else: false
    result = Iteration(a: genA, b: genB, r: match)

var total = 0
var i : Iteration
for x in 0..5_000_000:
    if x == 0:
        i.a = startA
        i.b = startB
    i = genValues i
    if i.r: inc total

echo total

