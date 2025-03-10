%--------------------------------------------------------------------------
% Electric Eel Foraging Ooptimization (EEFO) for 23 functions              %
% EEFO code v1.0.                                                          %
%--------------------------------------------------------------------------%                       
% The code is based on the following paper:                                %
% W. Zhao, L. Wang, Z. Zhang, H. Fan, J. Zhang, S. Mirjalili, N. Khodadadi,%
% Q. Cao, Electric eel foraging optimization: A new bio-inspired optimizer %
% for engineering applications,Expert Systems With Applications, 238,      %
% (2024),122200, https://doi.org/10.1016/j.eswa.2023.122200.               %
%--------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BestX:The best solution                  %
% BestF:The best fitness                   %
% HisBestF:History of the best fitness     %
% FunIndex:Index of functions              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;

MaxIteration=500;
PopSize=50;

FunIndex=1;
[BestX,BestF,HisBestF]=EEFO(FunIndex,MaxIteration,PopSize);
display(['The best fitness of F',num2str(FunIndex),' is: ', num2str(BestF)]);
%display(['The best solution is: ', num2str(BestX)]);

if BestF>0
    semilogy(HisBestF,'r','LineWidth',2);
else
    plot(HisBestF,'r','LineWidth',2);
end

xlabel('Iterations');
ylabel('Fitness');
title(['F',num2str(FunIndex)]);



