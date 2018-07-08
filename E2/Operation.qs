namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (N : Int, Uf : ((Qubit[], Qubit) => ())) : Int[]
    {
        body
        {
            mutable result = new Int[N];
            using(qs = Qubit[N + 1]) {
                let xs = qs[0 .. N - 1];
                let y = qs[N];

                Uf(xs, y);

                let ym = M(y);

                for (i in 0 .. N - 1) {
                    set result[i] = 1;
                }

                if (ym == One) {
                    set result[0] = 0;
                }

                ResetAll(qs);
            }

            return result;
        }
    }
}