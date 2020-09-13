%**************************************************************************************************
%Reference:  1) J. Brest, S. Greiner, B. Boskovic, M. Mernik, and V. Zumer, “Self-adapting
%                     control parameters in differential evolution: A comparative study on numerical
%                     benchmark problems,” IEEE Trans. Evolut. Comput., vol. 10, no. 6,
%                     pp. 646–657, Dec. 2006.
%                     2) J. Zhang and A. C. Sanderson, “JADE: adaptive differential evolution
%                     with optional external archive,” IEEE Trans. Evolut. Comput., vol. 13,
%                     no. 5, pp. 945-958, 2009.
%
% Note: We obtained the MATLAB source code from Dr. J. Zhang, and did some
%           minor revisions in order to solve the 25 benchmark test functions,
%           however, the main body was not changed.
%**************************************************************************************************

clc;
clear all;
tic;
warning off
format long;
format compact;

'DE'


   % Define the dimension of the problem
    n = 30;
  meanValue=zeros(30,100*n);
  avg=zeros(30);
  standard=zeros(30);
% Choose the problems to be tested. Please note that for test functions F7
% and F25, the global optima are out of the initialization range. For these
% two test functions, we do not need to judge whether the variable violates
% the boundaries during the evolution after the initialization.

   % The total number of runs
    totalTime = 30;

problemSet = 1:30;
for problemIndex =1:15

    problem = problemSet(problemIndex)

    popsize = 100;

    tau1 = 0.1;
    tau2 = 0.1;

    F = 0.7* ones(popsize, 1);
    CR = 0.5 * ones(popsize, 1);

     f_bias=100*problem;
     ubounds=100;
     lbounds=-100; 
     
    outcome = [];  % record the best results

    %Main body which was provided by Dr. J. Zhang

    time = 1;
    
    genbest=zeros(totalTime,100*n);
    succUpdate=zeros(totalTime,100*n);
    popUnupdate=zeros(totalTime,100*n);
    baseUnupdate=zeros(totalTime,100*n);
    
    while time <= totalTime

        rand('seed', sum(100 * clock));

        % Initialize the main population
%         popold = repmat(lu(1, :), popsize, 1) + rand(popsize, n) .* (repmat(lu(2, :)-lu(1, :), popsize, 1));
        
        Vmin=repmat(lbounds,popsize,n);
        Vmax=repmat(ubounds,popsize,n);
        popold=Vmin+(Vmax-Vmin).*rand(popsize,n);
        
        
         temp= cec14_func(popold',problem)-f_bias;
        valParents = temp';
%         valParents = benchmark_func(popold, problem, o, A, M, a, alpha, b);

        [best,id]=min(valParents);
        unupdate_number=zeros(popsize,1);
        FES = 0;
        while FES < n * 10000

            pop = popold;      % the old population becomes the current population


%             Fold = F;
%             CRold = CR;
          
            r0 = [1:popsize];
            [r1, r2, r3] = gnR1R2R3(popsize, r0);

            %  == == == == == = Mutation == == == == == == == == =
           
            vi  = pop(r1, :) + F(:, ones(1, n)) .* (pop(r2, :) - pop(r3, :));
            
            %%
           
                    vi = boundConstraint(vi,ubounds,lbounds);  
      

            %% == == == == =  Crossover == == == == =

            mask = rand(popsize, n) > CR(:, ones(1, n));     % mask is used to indicate which elements of ui comes from the parent
            rows = (1:popsize)'; cols = floor(rand(popsize, 1) * n) + 1;  % choose one position where the element of ui doesn't come from the parent
            jrand = sub2ind([popsize n], rows, cols); mask(jrand) = false;
            ui = vi;  ui(mask) = pop(mask);

%             valOffspring = benchmark_func(ui, problem, o, A, M, a, alpha, b);
               temp= cec14_func(ui' ,problem)-f_bias;
               valOffspring= temp';
            
            FES = FES + popsize;

            %%  == == == == == = Selection == == == == == =
            % I == 1: the parent is better; I == 2: the offspring is better
            [valParents, I] = min([valParents, valOffspring], [], 2);
            popold = pop;
            if  sum(I == 2)>0
            popold(I == 2, :) = ui(I == 2, :);
            succUn=mean(unupdate_number(I==2));
            succUpdate(time,FES/100)= succUn;
            popun=mean(unupdate_number);
            popUnupdate(time,FES/100)=popun;
            baseun=mean(unupdate_number(r1(I==2)));
            baseUnupdate(time,FES/100)=baseun;
            end
            
            unupdate_number(I==2)=0;
            
            unupdate_number(I==1)=unupdate_number(I==1)+1;
            
            
            [best,id]=min(valParents);
            genbest(time,FES/100)=best;
        end

        outcome = [outcome min(valParents)];

        time = time + 1;

    end

    meanValue(problem,:)=mean(genbest,1);
    sort(outcome)
    avg(problem)=mean(outcome);
    standard(problem)=std(outcome);
    
end
toc;

% filename=['rand2014_runsValueF1_F15',num2str(n),'D'];
% save(['G:\GitHub_DE\stagnationDE\基于停滞次数的DE 改进算法\结果数据\cec2014\rand2014\',filename],'runsValue');

% filename=['rand2014_avgF1_F15',num2str(n),'D'];
% save(['G:\GitHub_DE\stagnationDE\基于停滞次数的DE 改进算法\结果数据\cec2014\rand2014\',filename],'avg');
% 
% 
% filename=['rand2014_ standardF1_15',num2str(n),'D'];
% save(['G:\GitHub_DE\stagnationDE\基于停滞次数的DE 改进算法\结果数据\cec2014\rand2014\',filename],'standard');

