namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    open Microsoft.Quantum.Extensions.Math;

    open Microsoft.Quantum.Extensions.Diagnostics;

    operation Test() : () {
        body {
            using (qs = Qubit[2]) {
                X(qs[0]);
                H(qs[0]);
                H(qs[1]);
                RAll1(PI(), qs);
                DumpMachine("before");

                let r = Solve(qs);

                Message($"{r}");

                DumpMachine("after");
                ResetAll(qs);
            }
        }
    }

    operation Solve (qs : Qubit[]) : Int
    {
        body
        {
            RAll1(PI(), qs);
            H(qs[0]);
            H(qs[1]);

            if (M(qs[0]) == Zero) {
                if (M(qs[1]) == Zero) {
                    return 3;
                }
                return 1;
            }
            
            if (M(qs[1]) == Zero) {
                return 2;
            }

            return 0;
        }
    }
}