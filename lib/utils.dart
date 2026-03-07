import 'dart:math';

const List<String> possiblePValues = ['H', 'C', 'S', 'N', 'O', 'W', 'A'];
const List<String> possibleDValues = ['H', 'C', 'S', 'N', 'O', 'A'];
const List<String> possibleGValues = ['H', 'C', 'S', 'N', 'O'];

const List<String> inputValues12 = ['C', 'H', 'O', 'S', 'Q', 'W', 'A', 'V'];
const List<String> possiblePValues12 = ['C', 'H', 'O', 'S', 'A', 'V'];
const List<String> kaValues = ['A', 'V'];

const List<String> inputFields21 = ["Coal", "Oil", "Gas"];

const Map<String, String> units = {
  'H': '%',
  'C': '%',
  'S': '%',
  'N': '%',
  'O': '%',
  'W': '%',
  'A': '%',
  'V': 'мг/кг',
  'Q': 'MJ/kg',
  'Coal': 'т',
  'Oil': 'т',
  'Gas': 'м^3',
  'P': 'тис.грн',
  'o1': 'тис.грн',
  'o2': 'тис.грн',
  'Price': 'грн/МВт*год',
  'I': 'А',
  't': 'год',
  'T': 'год',
  'R': 'Ом',
  'X': 'Ом',
  'n': 'шт',
  'l': 'км',
  'Za': 'грн/кВт*год',
  'Zp': 'грн/кВт*год',
  'Pa': 'тис.грн',
};

String getUnit(String key) {
  return units[key] ?? '';
}

String getUnitChar(String value) {
  return value == 'V' ? 'мг/кг' : '%';
}

String getUnitString(String value) {
  switch (value) {
    case 'Coal':
    case 'Oil':
      return 'т';
    default:
      return 'м^3';
  }
}

String calculateResultsT11(Map<String, String> inputs) {
  final Map<String, double> pValues = {};
  inputs.forEach((key, value) {
    pValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double krs = 100 / (100 - pValues['W']!);
  final double krg = 100 / (100 - pValues['W']! - pValues['A']!);

  final Map<String, double> dValues = {};
  for (final key in possibleDValues) {
    dValues[key] = pValues[key]! * krs;
  }

  final Map<String, double> gValues = {};
  for (final key in possibleGValues) {
    gValues[key] = pValues[key]! * krg;
  }

  final double qr = 339 * pValues['C']! +
      1030 * pValues['H']! -
      108.8 * (pValues['O']! - pValues['S']!) -
      25 * pValues['W']!;
  final double qrMj = qr / 1000;
  final double qdMj =
      (qrMj + 0.025 * pValues['W']!) * 100 / (100 - pValues['W']!);
  final double qgMj = (qrMj + 0.025 * pValues['W']!) *
      100 /
      (100 - pValues['W']! - pValues['A']!);

  return '''
--- Results ---
Transition coeff (dry): ${krs.toStringAsFixed(2)}
Transition coeff (combustible): ${krg.toStringAsFixed(2)}

Dry composition:
${possibleDValues.map((key) => '$key=${dValues[key]!.toStringAsFixed(3)}').join('  ')}

Combustible composition:
${possibleGValues.map((key) => '$key=${gValues[key]!.toStringAsFixed(3)}').join('  ')}

Q (working): ${qrMj.toStringAsFixed(4)} MJ/kg
Q (dry): ${qdMj.toStringAsFixed(4)} MJ/kg
Q (combustible): ${qgMj.toStringAsFixed(4)} MJ/kg
''';
}

String calculateResultsT12(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double kaw = (100 - inputValues['W']! - inputValues['A']!) / 100;
  final double ka = (100 - inputValues['W']!) / 100;

  final Map<String, double> pValues = {};
  for (final key in possiblePValues12) {
    pValues[key] = kaValues.contains(key)
        ? inputValues[key]! * ka
        : inputValues[key]! * kaw;
  }

  final double qr =
      inputValues['Q']! * (100 - inputValues['W']! - pValues['A']!) / 100 -
          0.025 * inputValues['W']!;

  return '''
--- Results ---
Working composition:
${possiblePValues12.map((key) => '$key=${pValues[key]!.toStringAsFixed(3)}').join('  ')}

Q (working): ${qr.toStringAsFixed(4)} MJ/kg
''';
}

String calculateResultsT21(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double coalK =
      pow(10, 6) * 0.8 * 25.2 * (1 - 0.985) / (100 - 1.5) / 20.47;
  final double oilK = pow(10, 6) * 1 * 0.15 * (1 - 0.985) / (100 - 0) / 40.4;

  final double coalE = pow(10, -6) * coalK * 20.47 * inputValues["Coal"]!;
  final double oilE = pow(10, -6) * oilK * 40.4 * inputValues["Oil"]!;

  return '''
--- Results ---
Coal emission coef: ${coalK.toStringAsFixed(2)}g/GJ
Coal emission mass: ${coalE.toStringAsFixed(2)}t

Oil emission coef: ${oilK.toStringAsFixed(2)}g/GJ
Oil emission mass: ${oilE.toStringAsFixed(2)}t

Gas emission coef: 0.00g/GJ
Gas emission mass: 0.00t
''';
}

class CalculationResult {
  double o;
  double tr;
  double ka;
  double kp;
  double o2;
  double Ma;
  double Mp;
  double M;

  CalculationResult({
    required this.o,
    required this.tr,
    required this.ka,
    required this.kp,
    this.o2 = 0.0,
    this.Ma = 0.0,
    this.Mp = 0.0,
    this.M = 0.0,
  });
}

const Map<String, Map<String, double>> powerLines = {
  "ПЛ-110 кВ": {"o": 0.007, "tr": 10.0, "u": 0.167, "tc": 35.0},
  "ПЛ-35 кВ": {"o": 0.02, "tr": 8.0, "u": 0.167, "tc": 35.0},
  "ПЛ-10 кВ": {"o": 0.02, "tr": 10.0, "u": 0.167, "tc": 35.0},
  "КЛ-10 кВ (траншея)": {"o": 0.03, "tr": 44.0, "u": 1.0, "tc": 9.0},
  "КЛ-10 кВ (кабельний канал)": {"o": 0.005, "tr": 10.0, "u": 1.0, "tc": 9.0}
};

const Map<String, Map<String, double>> switches = {
  "В-110 кВ (елегазовий)": {"o": 0.01, "tr": 30.0, "u": 0.1, "tc": 30.0},
  "В-10 кВ (малооливний)": {"o": 0.02, "tr": 15.0, "u": 0.33, "tc": 15.0},
  "В-10 кВ (вакуумний)": {"o": 0.01, "tr": 15.0, "u": 0.33, "tc": 15.0}
};

const Map<String, Map<String, double>> transformers = {
  "Т-110 кВ": {"o": 0.015, "tr": 100.0, "u": 1.0, "tc": 43.0},
  "Т-35 кВ": {"o": 0.02, "tr": 80.0, "u": 1.0, "tc": 28.0},
  "Т-10 кВ (кабельна мережа)": {"o": 0.005, "tr": 60.0, "u": 0.5, "tc": 10.0},
  "Т-10 кВ (повітряна мережа)": {"o": 0.05, "tr": 60.0, "u": 0.5, "tc": 10.0}
};

const Map<String, double> bus = {"o": 0.03, "tr": 2.0, "u": 0.167, "tc": 5.0};

const Map<String, double> constants41 = {"U": 10, "C": 92};
const Map<String, double> constants42 = {"U": 10.5, "Uk": 10.5, "St": 6.3};
const Map<String, double> constants43 = {
  "U": 115.0,
  "Uk": 11.1,
  "Un": 11.0,
  "k": 0.009,
  "St": 6.3
};

double pd(double p, double pc, double o) {
  final double exponent = -1.0 * pow(p - pc, 2.0) / (2.0 * pow(o, 2.0));
  final double denominator = o * sqrt(2.0 * pi);
  return (1.0 / denominator) * exp(exponent);
}

double integrate(double Function(double) func, double a, double b,
    {int steps = 100000}) {
  final double h = (b - a) / steps;
  double sum = (func(a) + func(b)) / 2.0;
  for (int i = 1; i < steps; i++) {
    sum += func(a + i * h);
  }
  return sum * h;
}

double b(double p, double Pa, double o) {
  return exp(pow(p - Pa, 2.0) / (2 * pow(o, 2))) / (o * sqrt(2 * pi));
}

String calculateResultsT31(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double pc = inputValues['P']!;
  final double o1 = inputValues['o1']!;
  final double o2 = inputValues['o2']!;
  final double price = inputValues['Price']!;

  final double a = pc - pc * 0.05;
  final double b = pc + pc * 0.05;

  final double bW1 = integrate((p) => pd(p, pc, o1), a, b);
  final double income1 = pc * 24 * bW1 * price - pc * 24 * (1 - bW1) * price;

  final double bW2 = integrate((p) => pd(p, pc, o2), a, b);
  final double income2 = pc * 24 * bW2 * price - pc * 24 * (1 - bW2) * price;

  return '''
--- Results ---
Початковий прибуток: ${income1.toStringAsFixed(2)} тисяч гривень
Покращений прибуток: ${income2.toStringAsFixed(2)} тисяч гривень
''';
}

String calculateResultsT41(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double I = inputValues['S']! / (2 * sqrt(3.0) * constants41['U']!);

  final double j =
      inputValues['T']! < 3000 ? 1.6 : (inputValues['T']! < 5000 ? 1.4 : 1.2);

  final double S =
      (inputValues['I']! * 1000 * sqrt(inputValues['t']!)) / constants41['C']!;

  return '''
--- Results ---
I: ${I.toStringAsFixed(2)} A
Ipa: ${(I * 2).toStringAsFixed(2)} A
s: ${(I / j).toStringAsFixed(2)} мм^2
S: ${S.toStringAsFixed(2)} мм^2
''';
}

String calculateResultsT42(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double S = inputValues['S']!;
  final double U = constants42['U']!;

  final double Xc = U * U / S;
  final double Xt = constants42['Uk']! * U * U / 100 / constants42['St']!;
  final double X = Xc + Xt;
  final double I0 = U / sqrt(3.0) / X;

  return '''
--- Results ---
Xt: ${Xt.toStringAsFixed(2)} Ом
Xc: ${Xc.toStringAsFixed(2)} Ом
X: ${X.toStringAsFixed(2)}
I0: ${I0.toStringAsFixed(2)} кА
''';
}

String calculateResultsT43(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double Uk = constants43['Uk']!;
  final double U = constants43['U']!;
  final double St = constants43['St']!;
  final double k = constants43['k']!;
  final double Un = constants43['Un']!;

  final double R = inputValues['R']!;
  final double Xt = Uk * U * U / St / 100;
  final double X = inputValues['X']! + Xt;
  final double Rn = R * k;
  final double Xn = X * k;

  final double Z = sqrt(R * R + X * X);
  final double Zn = sqrt(Rn * Rn + Xn * Xn);

  final double I3 = U * 1000 / sqrt(3.0) / Z;
  final double I2 = I3 * sqrt(3.0) / 2;
  final double I3n = Un * 1000 / sqrt(3.0) / Zn;
  final double I2n = I3n * sqrt(3.0) / 2;

  return '''
--- Results ---
Xt: ${Xt.toStringAsFixed(2)} Ом
Значення приведені до напруги 110 кВ:
- X: ${X.toStringAsFixed(2)} Ом - R: ${R.toStringAsFixed(2)} Ом - Z: ${Z.toStringAsFixed(2)} Ом - I3: ${I3.toStringAsFixed(2)} А - I2: ${I2.toStringAsFixed(2)} А
Дійсні значення:
- X: ${Xn.toStringAsFixed(2)} Ом - R: ${Rn.toStringAsFixed(2)} Ом - Z: ${Zn.toStringAsFixed(2)} Ом - I3: ${I3n.toStringAsFixed(2)} А - I2: ${I2n.toStringAsFixed(2)} А
''';
}

CalculationResult calculate(List<Map<String, double>> objects) {
  final double totalO = objects.fold(0.0, (sum, obj) => sum + obj['o']!);
  final double weightedTrSum =
      objects.fold(0.0, (sum, obj) => sum + obj['o']! * obj['tr']!);
  final double averageTr = totalO != 0.0 ? weightedTrSum / totalO : 0.0;
  final double ka = (totalO * averageTr) / 8760.0;
  final double kmax = objects.map((obj) => obj['tc']!).reduce(max);
  final double kp = (1.2 * kmax) / 8760.0;

  return CalculationResult(
    o: totalO,
    tr: averageTr,
    ka: ka,
    kp: kp,
  );
}

String calculateResultsT51(
    Map<String, String> inputs, Map<String, String> selectValues) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final Map<String, double> lineData =
      Map.from(powerLines[selectValues['line']]!);
  final Map<String, double> transformerData =
      Map.from(transformers[selectValues['transformer']]!);
  final Map<String, double> switch1Data =
      Map.from(switches[selectValues['switch1']]!);
  final Map<String, double> switch2Data =
      Map.from(switches[selectValues['switch2']]!);
  final Map<String, double> sectionSwitchData =
      Map.from(switches[selectValues['sectionSwitch']]!);
  final Map<String, double> busData = Map.from(bus);

  final List<Map<String, double>> objects = [
    {...lineData, 'o': lineData['o']! * inputValues['l']!},
    transformerData,
    switch1Data,
    switch2Data,
    {...busData, 'o': busData['o']! * inputValues['n']!}
  ];

  final CalculationResult result = calculate(objects);
  result.o2 = 2 * result.o * (result.ka + result.kp) + sectionSwitchData['o']!;

  final CalculationResult transformerResult = calculate([transformerData]);
  result.Ma = transformerResult.ka * 5120.0 * 6451.0;
  result.Mp = transformerResult.kp * 5120.0 * 6451.0;
  result.M = result.Ma * inputValues['Za']! + result.Mp * inputValues['Zp']!;

  return '''
--- Results ---
o: ${result.o.toStringAsFixed(2)}
tr: ${result.tr.toStringAsFixed(2)}
ka: ${result.ka.toStringAsFixed(2)}
kp: ${result.kp.toStringAsFixed(2)}
o2: ${result.o2.toStringAsFixed(2)}
Ma: ${result.Ma.toStringAsFixed(2)}
Mp: ${result.Mp.toStringAsFixed(2)}
M: ${result.M.toStringAsFixed(2)}
''';
}

String calculateResultsT61(Map<String, String> inputs) {
  final Map<String, double> inputValues = {};
  inputs.forEach((key, value) {
    inputValues[key] = double.tryParse(value) ?? 0.0;
  });

  final double Pa = inputValues['Pa']!;
  final double o1 = inputValues['o1']!;
  final double o2 = inputValues['o2']!;
  final double C = inputValues['C']!;

  final double bW1 =
      integrate((p) => b(p, Pa, o1), Pa - Pa * 0.05, Pa + Pa * 0.05);
  final double W1 = Pa * 24 * bW1;
  final double I1 = W1 * C;
  final double W2 = Pa * 24 * (1 - bW1);
  final double B1 = W2 * C;
  final double bW2 =
      integrate((p) => b(p, Pa, o2), Pa - Pa * 0.05, Pa + Pa * 0.05);
  final double W3 = Pa * 24 * bW2;
  final double I2 = W3 * C;
  final double W4 = Pa * 24 * (1 - bW2);
  final double B2 = W4 * C;
  final double income1 = I1 - B1;
  final double income2 = I2 - B2;

  return '''
--- Results ---
Income1: ${income1.toStringAsFixed(2)}
Income2: ${income2.toStringAsFixed(2)}
''';
}
