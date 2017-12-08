
import memfiles, sequtils, strutils

type 
    Register = object 
        name  : string
        value : int
    Instruction = enum
        inc
        dec
    Comparison = enum
        lessThan
        lessThanOrEqual
        greaterThan
        greaterThanOrEqual
        equal
        notEqual
    Line = object 
        target          : string
        instruction     : Instruction
        source          : string
        comparison      : Comparison
        comparisonValue : int
        amount          : int
var source    = newSeq[string]()
var program   = newSeq[Line]()
var registers = newSeq[Register]()
for line in lines(memfiles.open("aoc_2017_day_08.dat")):
    source.add line

for line in source:
    let atoms    = split(line, " ")
    let register = atoms[0]
    if filter(registers, proc(r: Register): bool = r.name == register).len == 0:
        registers.add Register(name: register, value: 0)
    let instruction = if atoms[1].toLowerAscii == "dec": Instruction.dec else: Instruction.inc 
    let amount      = parseInt(atoms[2])
    let source      = atoms[4]
    var comparison : Comparison
    case atoms[5]:
        of "<" : comparison = Comparison.lessThan
        of "<=": comparison = Comparison.lessThanOrEqual
        of ">" : comparison = Comparison.greaterThan
        of ">=": comparison = Comparison.greaterThanOrEqual
        of "==": comparison = Comparison.equal
        of "!=": comparison = Comparison.notEqual
    let comparisonValue = parseInt(atoms[6])
    program.add Line(target: register, instruction: instruction, source: source, comparison: comparison, comparisonValue: comparisonValue, amount: amount)

for line in program:
    let source = filter(registers, proc(r: Register): bool = r.name == line.source)[0]
    let target = filter(registers, proc(r: Register): bool = r.name == line.target)[0]
    var conditionMet : bool = false
    case line.comparison:
        of lessThan           : conditionMet = source.value < line.comparisonValue
        of lessThanOrEqual    : conditionMet = source.value <= line.comparisonValue
        of greaterThan        : conditionMet = source.value > line.comparisonValue
        of greaterThanOrEqual : conditionMet = source.value >= line.comparisonValue
        of equal              : conditionMet = source.value == line.comparisonValue
        of notEqual           : conditionMet = source.value != line.comparisonValue

    if conditionMet:
        let sign : int = if line.instruction == dec: -1 else : 1
        for i in 0..registers.len - 1:
            if registers[i].name == target.name: registers[i].value += sign * line.amount


var max = low int 
var maxName : string
for register in registers:
    if register.value > max:
        max     = register.value
        maxName = register.name

echo maxName & " " & $max