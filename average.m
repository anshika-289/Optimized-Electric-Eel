% Parameters
selectedFunction = 1;    % Set the function index you want to run 30 times (e.g., 5)
numRuns = 30;            % Number of times to run the selected function
% dim = 10;                % Dimensionality of the problem (e.g., 10, 30, etc.)
popSize = 50;            % Population size (example value)
maxIter = 500;           % Maximum number of iterations

% Preallocate array to store the results of each run
runResults = zeros(numRuns, 1);

% Run the selected function multiple times
for run = 1:numRuns
    % Define lower and upper bounds for search space (example values)
    % lb = -100 * ones(1, dim);
    % ub = 100 * ones(1, dim);
    
    % Call your optimization algorithm here
    % Assuming "EEFO" is the optimization algorithm function
    % Use @(x) cec17_func(x, selectedFunction) as the function handle
    [~, bestFitness] = EEFO(selectedFunction, maxIter, popSize);
    
    % Store the best fitness result for this run
    runResults(run) = bestFitness;
    
    % Print the fitness result for this run
    fprintf('Run %d: Best Fitness = %.4f\n', run, bestFitness);
end

% Compute the average result over all runs for the selected function
averageFitness = mean(runResults);

% Display the average result for the selected function
fprintf('Function %d: Average Fitness over %d runs = %.4f\n', selectedFunction, numRuns, averageFitness);



