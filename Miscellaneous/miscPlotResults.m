function miscPlotResults(simulationResult, timeGranularity)

%{
Plots the simulation results

Input: 
- simulationResult: It is either a matrix of n x m where n is the number of
simulations and m is the number of intervals (dependent on time granularity
 selected for the simulation).

Note: The simulation could be a cell of h x 2 cell where h corresponds to
number of time-granularities for which simulation is done and the second
column stores the time-granularity associated with the simulation result
%}

if(~iscell(simulationResult))
    subplot(2, 2, 1)
    plot(1:size(simulationResult(1, :), 2), simulationResult(1:5, :))
    title(sprintf('Five simulations shown for %d-minute time granularity', timeGranularity))
    xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity));
    ylabel('Charge Level');
    ylim([0 100])
    subplot(2, 2, 2)
    plot(std(simulationResult))
    ylim([0, 45])
    title(sprintf('Standard Deviation of simulations shown for %d-minute time granularity', timeGranularity))
    xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity));
    ylabel('Charge Level');
    subplot(2, 2, [3, 4])
    plot(mean(simulationResult))
    title(sprintf('Mean of simulations shown for %d-minute time granularity', timeGranularity))
    xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity));
    ylabel('Charge Level');
    ylim([0 100])
else %If the simulations are stored in a cell of h x 2
    for i=1:size(simulationResult, 1)
        figure; subplot(2, 2, 1)
        plot(1:size(simulationResult{i, 1}(1, :), 2), simulationResult{i, 1}(1:5, :))
        title(sprintf('Five simulations shown for %d-minute time granularity', timeGranularity(i)))
        xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity(i)));
        ylabel('Charge Level');
        ylim([0 100])
        subplot(2, 2, 2)
        plot(std(simulationResult{i, 1}))
        ylim([0, 45])
        title(sprintf('Standard Deviation of simulations for %d-minute time granularity', timeGranularity(i)))
        xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity(i)));
        ylabel('Charge Level');
        subplot(2, 2, [3, 4])
        plot(mean(simulationResult{i, 1}))
        title(sprintf('Mean of simulations for %d-minute time granularity', timeGranularity(i)))
        xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity(i)));
        ylabel('Charge Level');
        ylim([0 100])
    end
end

end