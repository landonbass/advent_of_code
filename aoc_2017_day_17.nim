const steps  = 304
var spinlock = newSeq[int]()
var location = 0
spinlock.add 0
for i in 1..2017:
    location = (location + steps) mod i + 1
    spinlock.insert(i, location)

echo spinlock[location + 1]

