

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
  return commaList(numOperands: numOperands) { "TOperand\($0-1)" }
}

func argFieldList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "operand\($0-1): Field<TOperand\($0-1)>" }
}

func argIdList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "operand\($0-1)Id: FieldID" }
}

func argPassList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "operand\($0-1)Id: operand\($0-1).id" }
}

func argPassFieldList(numOperands: Int) -> String {
  return commaList(numOperands: numOperands) { "operand\($0-1): operand\($0-1)Field" }
}

func properties(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "    let operand\($0-1)Id: FieldID" }
}

func initProperties(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "        self.operand\($0-1)Id = operand\($0-1)Id" }
}

func getField(numOperands: Int) -> String {
  return newLineList(numOperands: numOperands) { "            let operand\($0-1)Field = network.getField(id: operand\($0-1)Id) as? Field<TOperand\($0-1)>," }
}

func calcFactory(numOperands: Int) -> String {
  return """
  public class Calculator\(numOperands)OpFactory<TTarget: Equatable, \(typeList(numOperands: numOperands))>: AnyCalculatorFactory {

      let targetId: FieldID
  \(properties(numOperands: numOperands))
      public typealias CalcFn = Calculator\(numOperands)Op<TTarget, \(typeList(numOperands: numOperands))>.CalcFn
      let calcFn: CalcFn

      init(targetId: FieldID, \(argIdList(numOperands: numOperands)), calcFn: @escaping CalcFn) {
          self.targetId = targetId
  \(initProperties(numOperands: numOperands))
          self.calcFn = calcFn
          super.init()
      }

      public static func registerFactory(target: Field<TTarget>, \(argFieldList(numOperands: numOperands)), calcFn: @escaping CalcFn) {
          _ = Calculator\(numOperands)OpFactory(targetId: target.id, \(argPassList(numOperands: numOperands)), calcFn: calcFn)
      }

      override func makeOrphanCalculator(network: BicycleNetwork) -> AnyCalculator? {
          guard
  \(getField(numOperands: numOperands))
              let targetField = network.getField(id: targetId) as? Field<TTarget>
          else { return nil }

          return Calculator\(numOperands)Op<TTarget, \(typeList(numOperands: numOperands))>(network: network, target: targetField, \(argPassFieldList(numOperands: numOperands)), calcFn: calcFn)
      }

  }
  """
}

print("// Code under this comment generated with gen-calc-factory.swift. Do not edit.\n")
for i in 1...6 {
  print(calcFactory(numOperands: i))  
}
