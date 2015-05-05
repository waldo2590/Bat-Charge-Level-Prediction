function miscPlotWithDifLineStyles(simulationStats, originalStats)
%{
This function plots each row of the input matrix with a different line
style

Input:
- simulationStats: The stats (mean or standard deviation) of simulations. 
It is a matrix of n by t where n is the number of time granularities and 
t is the number of intervals for which simulation has taken place.
- originalStats: The stats (mean or standard deviation) of original data 
records. It is a matrix of n by t where n is the number of time
granularities and t is the number of intervals for which simulation has
taken place.

Output:
(void) Plot
%}

%% Function code starts here

lineStyles = {'-', '--', '-.', '+', '*', 'x', '^', 'o^', 'd', 'v', ':', 'd^'};


plot(1:size(simulationStats, 2), simulationStats(1, :), lineStyles{1});
hold on
for i=2:size(simulationStats, 1)
   plot(1:size(simulationStats, 2), simulationStats(i, :), lineStyles{i});
end

plot(1:size(originalStats, 2), originalStats(1, :), lineStyles{i + 1});
tempIndex = i + 1;
for i=2:size(originalStats, 1)
   plot(1:size(originalStats, 2), originalStats(i, :), lineStyles{tempIndex + i - 2});
end
hold off

end