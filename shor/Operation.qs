namespace shor
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Math;

    // multに与えられたlittle endianのqubitをb^expo倍して、modで割ったあまりを返す
    operation ExpModMultOracle (b : Int, mod : Int, expo : Int, mult : Qubit[]) : () {
        body { 
            // ExpModしなくても良いが、modするとbitsizeが減る
            ModularMultiplyByConstantLE(
                ExpMod(b, expo, mod),
                mod,
                LittleEndian(mult)
            );
        }

        adjoint auto
        controlled auto
        adjoint controlled auto
    }

    operation Factor (num : Int) : (Int)
    {
        body
        {
            mutable fact = 2;

            if (num % 2 == 0) {
                return 2;
            }

            let numBit = BitSize(num);
            let q = BitSize(num * num) + 1;

            repeat {
                // random int b/w 2 .. num - 1
                let coprime = RandomInt(num - 3) + 2;
                // 部分適用してカリー化
                let oracle = DiscreteOracle(ExpModMultOracle(coprime, num, _, _));
                Message($"coprime candidate: {coprime}");
                if (IsCoprime(num, coprime)) {
                    mutable rPeriod = 1;
                    repeat {
                        using (moduloBits = Qubit[numBit]) {
                            let moduloBitsLE = LittleEndian(moduloBits);
                            // First, set modulobits to 1
                            InPlaceXorLE(1, moduloBitsLE);
                            using (exponentBits = Qubit[q]) {
                                let exponentBE = BigEndian(exponentBits);
                                QuantumPhaseEstimation(oracle, moduloBitsLE, exponentBE);

                                // moduloBitsに対するGiven unitary trのeigenvalueは
                                // numExpMod / 2^q
                                let numExpMod = MeasureIntegerBE(exponentBE);
                                let denom = 2^q;

                                Message($"phase E.S.: {numExpMod}, denom: {denom}");

                                if (numExpMod != 0) {
                                    let (nume, peri) = ContinuedFractionConvergent(
                                        Fraction(numExpMod, denom),
                                        num
                                    );

                                    set rPeriod = AbsI(peri);
                                    Message($"period candidate: {peri}");
                                }
                            }
    
                            ResetAll(moduloBits);
                        }
                    } until (ExpMod(coprime, rPeriod, num) == 1)
                    fixup {
                        Message("Wrong period. Try again");
                    }

                    Message("Correct period found.");

                    if (rPeriod % 2 == 0) {
                        let halfExp = coprime^(rPeriod / 2);

                        if (halfExp % num != num - 1) {
                            Message($"Correct num {halfExp} found.");
                            Message($"GCD({num}, {halfExp + 1}) is a factor of n");
                            set fact = GCD(num, halfExp + 1);
                        }
                    }
                } else {
                    set fact = GCD(num, coprime);
                }
            } until (num % fact == 0)
            fixup {
                Message("Trying again...");
            }

            return fact;
        }
    }
}
