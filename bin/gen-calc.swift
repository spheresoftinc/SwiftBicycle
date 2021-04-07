

func commaList(numOperands: Int, arg: (Int) -> String) -> String {
  var result: String = ""
  for i in 1...numOperands {
    if i > 1 {
      result += ", "
    }
    result += arg(i)
  }
  return result
}

func newLineList(numOperands: Int, arg: (Int) -> String) -> String { 
  var result: String = ""
  for i in 1...numOperands {
    result += arg(i) + "\n"
  }
  return result 
}

func typeList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "TOperand\($0)" }
}

func argList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "operand\($0): Field<TOperand\($0)>" }
}

func valueList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "self.operand\($0).value()" }
}

func properties(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "      var operand\($0): Field<TOperand\($0)>" }
}

func initProperties(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "          self.operand\($0) = operand\($0)" }
}

func addDependent(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "          operand\($0).addDependent(calculator: self)" }
}

func hash(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "          operand\($0).id.hash(into: &hasher)" }
}

func assertNotClear(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "          assert(!operand\($0).code.isEmpty())" }
}

func addSourceField(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "          r.addSourceField(fieldID: operand\($0).id)" }
}

func isReady(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { 
    """
              guard !operand\($0).code.isEmpty() else {
                  return false
              }
    """
  }
}

func calc(numOperands: Int) -> String {
  return """
    public class Calculator\(numOperands)Op<TTarget: Equatable, \(typeList(numOperands: numOperands))>: Calculator<TTarget> {

  \(properties(numOperands: numOperands))
        public typealias CalcFn = (\(typeList(numOperands: numOperands))) -> TTarget
        public typealias ReadyFn = (\(typeList(numOperands: numOperands))) -> Bool
        var calcFn: CalcFn
        var readyFn: ReadyFn?

        public init(network: BicycleNetwork, target: Field<TTarget>, \(argList(numOperands: numOperands)), calcFn: @escaping CalcFn, readyFn: ReadyFn? = nil) {
  \(initProperties(numOperands: numOperands))
            self.calcFn = calcFn
            self.readyFn = readyFn
            super.init(network: network, target: target)
  \(addDependent(numOperands: numOperands))
        }

        public override func hash(into hasher: inout Hasher) {
            super.hash(into: &hasher)
  \(hash(numOperands: numOperands))
        }

        override func isReady() -> Bool {
  \(isReady(numOperands: numOperands))
            return self.readyFn?(\(valueList(numOperands: numOperands))) ?? true
        }

        internal override func calcTarget() -> TTarget? {
  \(assertNotClear(numOperands: numOperands))
            return self.calcFn(\(valueList(numOperands: numOperands)))
        }

        override func makeRelationship() -> Relationship {
            let r = super.makeRelationship()
  \(addSourceField(numOperands: numOperands))
            return r
        }

    }

  """
}

print("// Code under this comment generated with gen-calc.swift. Do not edit.\n")
for i in 1...6 {
  print(calc(numOperands: i))  
}
