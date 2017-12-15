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

proc genValues(iteration: Iteration) : Iteration =
    let genA  = (iteration.a * factorA).int mod divisor
    let genB  = (iteration.b * factorB).int mod divisor
    let binA  = toBin(genA, 32)[16..31]
    let binB  = toBin(genB, 32)[16..31]
    let match = if binA == binB: true else: false
    result = Iteration(a: genA, b: genB, r: match)

var total = 0
var i : Iteration
for x in 0..40_000_000:
    if x == 0:
        i.a = startA
        i.b = startB
    i = genValues(i)
    if i.r: inc total

echo total

