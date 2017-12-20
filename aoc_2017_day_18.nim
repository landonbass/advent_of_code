import strutils

const input_train = """set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2"""

const input = """set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 464
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19"""

type
    Register = object
        name : string
        value: int64

var instructions     = splitLines(input)
var registers        = newSeq[Register]()
var freqs            = newSeq[int64]()
var rcv      : int64 = 0
var position : int64 = 0

proc getRegisterValue(r: string): int64 =
    if not isAlphaAscii(r):
        result = cast[int64](parseInt(r))
    else:   
        result = 0
        for i in 0..registers.len - 1:
            if registers[i].name == r: result = registers[i].value 
var x = -1
while x < 10_000:
    inc x
    let instruction = instructions[position.int]
    let atoms       = split(instruction, " ")
    let intr        = atoms[0]
    #echo "p: $# i: $# r: $#" % [$position, intr, $registers]
    case intr:
        of "snd":
            freqs.add getRegisterValue(atoms[1])
        of "set":
            let x = atoms[1]; let y = getRegisterValue(atoms[2]); var found = false
            for r in 0..registers.len - 1:
                if registers[r].name == x: registers[r].value = y; found = true
            if not found: registers.add Register(name: x, value: y)
        of "add":
            let x = atoms[1]; let y = getRegisterValue(atoms[2]); var found = false
            for r in 0..registers.len - 1:
                if registers[r].name == x: registers[r].value += y; found = true
            if not found: registers.add Register(name: x, value: y)
        of "mul":
            let x = atoms[1]; let y = getRegisterValue(atoms[2]); var found = false
            for r in 0..registers.len - 1:
                if registers[r].name == x: registers[r].value *= y; found = true
            if not found: registers.add Register(name: x, value: 0)
        of "mod":
            let x = atoms[1]; let y = getRegisterValue(atoms[2]);var found = false
            for r in 0..registers.len - 1:
                if registers[r].name == x: registers[r].value = registers[r].value mod y; found = true
            if not found: registers.add Register(name: x, value: y)
        of "rcv":
            let x = getRegisterValue(atoms[1])
            if x != 0: rcv = freqs[freqs.len - 1]
        of "jgz":
            let x = getRegisterValue(atoms[1])
            let y = getRegisterValue(atoms[2])
            if x > 0: position = position - 1 + y
    if cast[int](position) < 0 or cast[int](position) >= instructions.len - 1: break
    inc position
    
echo rcv