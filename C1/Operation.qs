namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Math;

        open Microsoft.Quantum.Extensions.Diagnostics;


    operation Test () : () 
    {
        body
        {
            mutable c = 0;
            for (i in 0 .. 10000) {
                using(qs = Qubit[1]) {

                    mutable ex = 0;

                    if (i > 5000) {
                        set ex = 1;
                    }

                    if (ex == 1) {
                        H(qs[0]);
                    }

                    if (ex == Solve(qs[0])) {
                        set c = c + 1;
                    }

                    ResetAll(qs);
                }
            }

            Message($"{c} out of 10000");
        }
    }

    operation Solve (q : Qubit) : Int
    {
        body
        {
            Ry(1.0, q);
            DumpMachine("after");

            if (M(q) == Zero) {
                return 0;
            }

            return 1;
        }
    }
}