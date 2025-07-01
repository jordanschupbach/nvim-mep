
Numeric.GSL.SimulatedAnnealing



main :: IO () do
  let initialTemp = 1000.0
      finalTemp = 1.0
      coolingRate = 0.95
      maxIterations = 10000

  -- Define the objective function to minimize
  let objectiveFunction x = (x - 3) ^ 2 + 2

  -- Run the simulated annealing algorithm
  let result = Numeric.GSL.SimulatedAnnealing.simulatedAnnealing
                objectiveFunction initialTemp finalTemp coolingRate maxIterations

  -- Print the result
  putStrLn $ "Optimal value found: " ++ show result



