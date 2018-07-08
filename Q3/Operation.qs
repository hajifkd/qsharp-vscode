namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    open Microsoft.Quantum.Extensions.Diagnostics;

    operation Test() : () {
        body {
            using (qs = Qubit[3]) {
                DumpMachine("before");

                Solve(qs, [true;false;false], [true;true;false]);

                DumpMachine("after");
                ResetAll(qs);
            }
        }
    }

    operation Solve (qs : Qubit[], bits0 : Bool[], bits1 : Bool[]) : ()
    {
        body
        {
            mutable firstInd = -1;
            for (i in 0 .. Length(qs) - 1) {
                if (firstInd < 0) {
                    if (bits0[i] != bits1[i]) {
                        H(qs[i]);
                        set firstInd = i;
                    } elif (bits0[i]) {
                        X(qs[i]);
                    }
                } else {
                    if (bits0[i]) {
                        X(qs[i]);
                    }

                    if (bits0[i] != bits1[i]) {
                        CNOT(qs[firstInd], qs[i]);
                    }
                }
            }

            if (bits0[firstInd]) {
                X(qs[firstInd]);
            }
        }
    }
}