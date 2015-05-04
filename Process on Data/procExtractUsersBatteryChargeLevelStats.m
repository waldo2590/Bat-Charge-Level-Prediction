function [means, stds] = procExtractUsersBatteryChargeLevelStats(timeGranulatedDataRecord, initChargeLvl, exactMatch, expType, numOfDays)
%{
This function extracts users charge levels and takes their mean and
standard deviations

Inputs:
- timeGranulatedDataRecord: A cell of n by 2 where each element in the 
first column contains a matrix of time granulated data record set and 
each element of the second column contains an associated time granularity
- initChargeLvl: The initial charge level from which the user battery 
charge level sequence extraction begins
- exactMatch: Takes on values of 1 or 0. If 1 the function select the 'start
charge levels' equal to initChargeLvl exactly. If not, the function selects
the 'start charge levels' with a boundary of initChargeLvl.
- expType: The experiment type
- numOfDays: A posotive, preferably integer, quantity that specifies the 
number of days for which the simulation will run

Outputs:
- means: Mean of extracted battery charge levels.
- stds: Standard deviations of extracted batery charge levels
%}

%% Function code starts her

if(expType == 1)
    usersChargeLvlSequences = cell(size(timeGranulatedDataRecord, 1), 2);
    boundary = 0.83; %Found this number emprically after trial and error to see how many number of rows gets collected for all time granularities. It turned out that this number yielded the 'closest' number of rows collected for all time granularities
    
    for i=1:size(timeGranulatedDataRecord, 1) %Over each data set records belonging to each time granularity
       originalDataRecordSets =  timeGranulatedDataRecord{i, 1};
       timeGranularity = timeGranulatedDataRecord{i, 2};
       exactNumOfRequiredRecords = numOfDays * (1440/timeGranularity);
       usersChargeLvlSequences{i, 1} = zeros(0, exactNumOfRequiredRecords);
       usersChargeLvlSequences{i, 2} = timeGranulatedDataRecord{i, 2};
       for j=1:size(originalDataRecordSets, 1) %Over each data record set for each user
           granulatedData = originalDataRecordSets{j, 2};
           chargeLvlRecordsForOneIndividual = zeros(0, exactNumOfRequiredRecords);
           if(exactMatch == 1)
              exactMatchIndices = (find(granulatedData(:, 6) == initChargeLvl));
              if(length(exactMatchIndices > 0))
                  startIndex = exactMatchIndices(1);
                  k = 2;
                   while(k <= length(exactMatchIndices))
                      if(exactMatchIndices(k) < startIndex + exactNumOfRequiredRecords - 1 && startIndex + exactNumOfRequiredRecords - 1 <= size(granulatedData, 1))
                          exactMatchIndices(k) = [];
                          k = k - 1;
                      elseif(exactMatchIndices(k) > startIndex + exactNumOfRequiredRecords - 1)
                          if(startIndex + exactNumOfRequiredRecords - 1 <= size(granulatedData, 1))
                              chargeLvlRecordsForOneIndividual = [chargeLvlRecordsForOneIndividual; granulatedData(startIndex:startIndex + exactNumOfRequiredRecords - 1, 6)'];
                              startIndex = exactMatchIndices(k);
                          else
                              exactMatchIndices(k - 1:end) = [];
                              break;
                          end
                      else
                          exactMatchIndices(k - 1:end) = [];
                          break;
                      end
                      k = k + 1;
                   end
              end
           elseif(exactMatch == 0) %If not looking for exact matches
               k = 1;
               while(k <= size(granulatedData, 1) - exactNumOfRequiredRecords)
                   if(granulatedData(k, 6) - boundary*(timeGranularity/10) < initChargeLvl && granulatedData(k, 6) + boundary*(timeGranularity/10) > initChargeLvl) %The 'starting charge level' must be within a bound of initChargeLvl
                       if(miscCheckIndexExceeding(k, exactNumOfRequiredRecords, 0, granulatedData))
                          chargeLvlRecordsForOneIndividual = [chargeLvlRecordsForOneIndividual; granulatedData(k:k + exactNumOfRequiredRecords - 1, 6)'];
                          k = k + exactNumOfRequiredRecords;
                       else
                           break;
                       end
                   else
                       k = k + 1;
                   end
               end
           end
           usersChargeLvlSequences{i, 1} = [usersChargeLvlSequences{i, 1}; chargeLvlRecordsForOneIndividual];
       end
       
    end
end

% Apply linear interpolation
timeGranularity = [];
for i=1:size(usersChargeLvlSequences, 1)
    timeGranularity = [timeGranularity; usersChargeLvlSequences{i, 2}];
end
interpolatedBatChargeLvlSequences = procGenerateIntervalConsistentDataRecord(usersChargeLvlSequences, timeGranularity, numOfDays);

means = zeros(size(interpolatedBatChargeLvlSequences, 1), size(interpolatedBatChargeLvlSequences{1, 1}, 2));
stds = zeros(size(interpolatedBatChargeLvlSequences, 1), size(interpolatedBatChargeLvlSequences{1, 1}, 2));

for i=1:size(interpolatedBatChargeLvlSequences)
   means(i, :) = mean(interpolatedBatChargeLvlSequences{i, 1});
   stds(i, :) = std(interpolatedBatChargeLvlSequences{i, 1});
end

end