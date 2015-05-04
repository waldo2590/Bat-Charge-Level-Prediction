function miscPlotSimulationResults(simulationResult, timeGranulatedDataRecord, timeGranularity, initChargeLvl, succinct, numOfDays)

%{
Plots the simulation results

Input: 
- simulationResult: It is either a matrix of n x m where n is the number of
simulations and m is the number of intervals (dependent on time granularity
 selected for the simulation).
- timeGranularity: A single quantity or a vector of time granularities
- succinct: Takes the values 0 or 1. Determines whether the plots should be succinct or not
- userData: Contains mean and standard deviation of selected (based on
expType) users' battery charge levels started from an initial charge level
- numOfDays: A posotive, preferably integer, quantity that specifies the 
number of days for which the simulation will run


Note: The simulation could be a cell of h x 2 cell where h corresponds to
number of time-granularities for which simulation is done and the second
column stores the time-granularity associated with the simulation result
%}

[originMeans, originStds] = procExtractUsersBatteryChargeLevelStats(timeGranulatedDataRecord, initChargeLvl, 0, 1, numOfDays);
% load('tempStats.mat');
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
    if(nargin == 5)
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
    elseif(nargin == 6)
        if(succinct == 1)
            intervalConsistentSimulationResult = procGenerateIntervalConsistentDataRecord(simulationResult, timeGranularity, numOfDays);
            means = zeros(size(intervalConsistentSimulationResult, 1), size(intervalConsistentSimulationResult{1, 1}, 2));
            stds = zeros(size(intervalConsistentSimulationResult, 1), size(intervalConsistentSimulationResult{1, 1}, 2));
            for i=1:size(intervalConsistentSimulationResult, 1)
                means(i, :) = mean(intervalConsistentSimulationResult{i, 1});
                stds(i, :) = std(intervalConsistentSimulationResult{i, 1});
            end
%             figure; subplot(2, 2, [1, 2])
            figure; plot(1:size(means, 2), means);
            title(sprintf('Means of simulations with time granularities %s minutes shown', strcat(strcat('[', num2str(timeGranularity')), ']')))
            xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity(1)));
            ylabel('Charge Level');
            ylim([0 100])
%             subplot(2, 2, [3, 4])
            figure; plot(1:size(stds, 2), stds);
            title(sprintf('Standard Deviations of simulations with time granularities %s minutes shown', strcat(strcat('[', num2str(timeGranularity')), ']')))
            xlabel(sprintf('Time intervals (each interval represents %d minutes)', timeGranularity(1)));
            ylabel('Charge Level');
            ylim([0 45])
            
%             %Dynamic Legend
%             temp = strcat(horzcat('''Predicted Mean of ', num2str(timeGranularity(1))), '''');
%             for i=2:length(timeGranularity)
%             temp = strcat(strcat(temp, strcat(', ''', horzcat('Predicted Mean of ' ,num2str(timeGranularity(i))))), '''');
%             end
        else
            miscPlotSimulationResults(simulationResult, timeGranulatedDataRecord, timeGranularity, initChargeLvl, numOfDays);
        end
        
    else
        error('The number of input arguments is less than the number expected');
    end
end

end