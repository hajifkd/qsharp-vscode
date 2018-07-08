namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    operation Solve (q : Qubit) : Int
    {
        body
        {
            if (RandomInt(2) == 1) {
                H(q);
                if (M(q) == One) {
                    return 0;
                }
            } else {
                if (M(q) == One) {
                    return 1;
                }
            }

            return -1;
            // your code here
        }
    }
}