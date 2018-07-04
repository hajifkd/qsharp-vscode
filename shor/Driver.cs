using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace shor
{
    class Driver
    {
        static void Main(string[] args)
        {
            using (var sim = new QuantumSimulator())
            {
                var res = Factor.Run(sim, 15).Result;
                System.Console.WriteLine($"Result:{res}");
            }
        }
    }
}