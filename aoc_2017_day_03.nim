
const input = 361527

var square    = 1
var halfWidth = 1
while square * square < input:
    inc halfWidth
    square += 2
let bottomRight = square * square

var mids = newSeq[int]()
for i in 0..square-2:
    mids.add (bottomRight - (i*square + halfWidth - (i + 1)))

var d = square
for mid in mids:
    if abs(input-mid) < d : d = abs(input-mid)

let distance = d+(halfWidth-1)

echo distance