%{
TODOs:

- genHMM.m:
    expType == 2: Learn model type 1, but the difference is the observation is
    GMM instead of one Normal distribution
    expType == 3: Learn a model for each user
    expType == 4: Learn a model for each user dependent on time of day or
    battery charge level
    expType == 4: Learn model type 3, with observation of GMM
    expType == 5: Learn a model dependent on time of day
    expType == 6: expType 5 + Learn a model dependent on battery charge lvl

- miscPlotResults.m:
    Plot time consistent simulation result
    Plot the mean and variance in one plot

- miscPlotWithSameTimeGranularity.m
    (Done) Interpolate simulation results of all time granularities within
    the smallest time granularity to ease plotting their means and standard
    deviations in one elaborative graph

- Missing value problem:
    Fill the missing values with learned model
%}