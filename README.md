# Optimized-Electric-Eel

This is a Nature Inspired Algorithm based on the hunting mechanism of Electric Eels. It includes 4 phases : 
1. Interacting
2. Resting
3. Hunting
4. Migrating

# Changes and Optimization

1. Introducing a Scaling Factor

   Scaling Factor = 1-(It/MaxIt)^0.5

   Here, a under root term was added to balance the change made and help is balancing exploration and exploitation.

2. Changing Alpha, Beta and Eta Parameters
   These parameters are used in updating the new position of the eel population.

    Alpha = 2*scaleFactor; %scaling factor         - resting and migrating
    Beta = 2*scaleFactor; %scaling factor          - hunting and migrating
    Eta = 2*scaleFactor; %curling factor           - hunting

# Results

1. Unimodal Functions
   A significant increase in best fitness is observed.
   
2. Multimodal Functions
   The fitness values remain more or less the same, as compared to the original algorithm.
   
3. Hybrid Functions
   The fitness can decrease in some cases.
