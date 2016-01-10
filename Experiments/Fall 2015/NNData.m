% Data structure to hold all the neural network data
classdef NNData
   properties
      net
      phi_test
      t_test
      numSamples
      seed
      numTest
      numTrain
      numFeatures
      numOfLayers
      numNodesInLayer
      numInputsToNeuronsInLayer
      numClasses
   end
end