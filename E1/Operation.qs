namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Test () : ()
    {
        body
        {
            mutable bs = new Int[5];
            for (i in 0 .. 4) {
                set bs[i] = RandomInt(2);
            }

            let res = Solve(5, D1(_, _, bs));

            Message($"{bs}, {res}");
        }
    }

    operation D1 (x : Qubit[], y : Qubit, b : Int[]) : ()
    {
        body
        {
            for (i in 0..Length(x) - 1) {
                if (b[i] == 1) {
                    CNOT(x[i], y);
                }
            }
        }
    }

    operation Solve (N : Int, Uf : ((Qubit[], Qubit) => ())) : Int[]
    {
        body
        {
            mutable result = new Int[N];
            using(qs = Qubit[N + 1]) {
                let xs = qs[0 .. N - 1];
                let y = qs[N];

                X(y);

                for (i in 0 .. N) {
                    H(qs[i]);
                }

                Uf(xs, y);

                for (i in 0 .. N - 1) {
                    H(xs[i]);

                    if (M(xs[i]) == Zero) {
                        set result[i] = 0;
                    } else {
                        set result[i] = 1;
                    }
                }

                ResetAll(qs);
            }

            return result;
        }
    }
}