function model = genHMM(dataRecord, timeGranularity, expType)

%{
This function generates a model to be used for simulation porpuses later

Inputs:

- dataRecord: An m by n matrix where m is the number of time-granulated 
records for time series data and n is the number of attributes for each
record
- timeGranularity: The time granularity of the data record
- expType: Determines the model to be learned over the input data record

    If the expType is:
        - One(1): The model learned in this experience type (expType)
        is a simple hidden Markod model (HMM) with 12 pre-defined states
        and the set of parameters learned via Maximum Likelihood Estimate (MLE)

%}

%% The code section for generating a model
if(expType == 1) %First model (a simple HMM with 12 states)
    %{
    Discharge states:
        (1) Shutdown: When the discharge rate (9th column of the users data
        set) is 0 - This is a very naive assumption because in many times 
        the charge level is 0 but the battery charge level is higher than 
        0 and the phone has not been died out. In a more complex model if 
        the hidden variable is dependent on charge level we can assume that
        when the charge level is between 0 and the discharge rate is 0
        also, then the phone has been died out definately.
        (2) Idle: When the discharge rate is > 0 & <= 0.35/(10/granularity)
        (3) Low: When the discharge rate is > 0.35/(10/granularity) & <= 0.99/(10/granularity)
        (4) Med-Low: When the discharge rate is > 0.99/(10/granularity) & < 2/(10/granularity)
        (5) Med: When the discharge rate is >= 2/(10/granularity) & < 4/(10/granularity)
        (6) Med-High: When the discharge rate is >= 4/(10/granularity) & <= 6.5/(10/granularity)
        (7) High: When the discharge rate is > 6.5/(10/granularity) & <= 9.3/(10/granularity)
        (8) Intense When the discharge rate is > 9.3/(10/granularity)
    
    Recharge states:
        (9) Idle/Fully Charged: When the recharge rate is >-0.5/(10/granularity)
        (10) Early recharge state/getting fully charged: When the rescharge rate is <= -0.5/(10/granularity) & >= -3/(10/granularity)
        (11) About to get fully charged: When the recharge rate is < -3/(10/granularity) & >= -6.5/(10/granularity)
        (12) About to get fully charged: When the recharge rate is < -6.5/(10/granularity)
    %}
    
    [labeledDataRecord, usersIndex] = labelDataForHMM(dataRecord, timeGranularity, expType);
    
    transitionMatrix = zeros(12, 12);
    emission = cell(1, 12);
    initialDist = zeros(1, 12);
    
    for i=1:12
       tempChargeRates = labeledDataRecord(labeledDataRecord(:, 10) == i, 9);
       emission{1, i} = [mean(tempChargeRates), std(tempChargeRates)];
    end
    
    for i=1:length(usersIndex) - 1
        singleUserData = labeledDataRecord(usersIndex(i) + 1:usersIndex(i + 1), :);
        labels = double(singleUserData(:, end));
        
        initialDist(labels(1)) = initialDist(labels(1)) + 1;
        
        for j=1:size(labels, 1) - 1
            transitionMatrix(labels(j), labels(j + 1)) = transitionMatrix(labels(j), labels(j + 1)) + 1;
        end

    end
    
    initialDist = initialDist / sum(initialDist);
    
    for i=1:size(transitionMatrix, 1)
       transitionMatrix(i, :) = transitionMatrix(i, :) / sum(transitionMatrix(i, :)); 
    end
    
    model{1, 1} = transitionMatrix;
    model{1, 2} = emission;
    model{1, 3} = initialDist;
    
    fprintf('Learning model for experience type ''%d'' (A simple HMM with the parameters learned through MLE) for the data with time-granularity of %d has been done successfully', expType, timeGranularity);

end