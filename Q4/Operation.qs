namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;



    operation Solve (qs : Qubit[]) : ()
    {
        body
        {
            let len = Length(qs);

            if (len == 1) {
                if (M(qs[0]) == Zero) {
                    X(qs[0]);
                }

                return ();
            }
            
            mutable targInd = 1;

            repeat {
                let offset = 2^(targInd - 1);
                Z(qs[0]);
                H(qs[0]);

                if (targInd != 1) {
                    X(qs[(2^targInd) - 1]);
                }

                for (i in 0 .. (2^(targInd - 1)) - 1) {
                    X(qs[i]);
                    CNOT(qs[i], qs[(2^targInd) - 1]);
                    X(qs[i]);
                }

                for (i in 1 .. (2^(targInd - 1)) - 1) {
                    CCNOT(qs[0], qs[i], qs[2^targInd - 1]);
                }

                if (targInd != 1) {
                    Z(qs[2^targInd - 1]);
                }

                for (i in 1 .. (2^(targInd - 1)) - 1) {
                    CCNOT(qs[0], qs[i], qs[i + offset - 1]);
                    CNOT(qs[i + offset - 1], qs[0]);
                    CNOT(qs[i + offset - 1], qs[i]);
                }

                set targInd = targInd + 1;
            } until (2^targInd > len)
            fixup {
            }

            return ();
        }
    }
}