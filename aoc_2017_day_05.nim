import memfiles, strutils


var data = newSeq[int]()
for line in lines(memfiles.open("aoc_2017_day_05.dat")):
    if line != "": data.add parseInt(line)

var x = 0
var y = 0
while x < data.len:
    let dX = data[x]
    if dX >= 3: dec data[x] else: inc data[x]
    x = x + dX
    inc y

echo "steps part 2: " & $y