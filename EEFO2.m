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

    function [Xprey,BestF,HisBestF]=EEFO2(FunIndex,MaxIt,PopSize)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FunIndex: Index of function.                       %
    % MaxIt: Maximum number of iterations.               %
    % PopSize: Size of population.                       %
    % PopPos: Position of rabbit population.             %
    % PopFit: Fitness of population.                     %
    % Dim: Dimensionality of prloblem.                   %
    % Xprey: Best solution found so far.                 %
    % BestF: Best fitness corresponding to Xprey.        %
    % HisBestF: History best fitness over iterations.    %
    % Low: Low bound of search space.                    %
    % Up: Up bound of search space.                      %
    % E:Energy factor.                                   %
    % Alpha:scale of resting area.                       %
    % Beta: scale of hunting area.                       %
    % Eta: Curling factor.                               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [Low,Up,Dim]=FunRange(FunIndex);
    % [Low,Up,Dim, ~]=CEC2017(FunIndex);
    if length(Low)==1
        lb=Low*ones(1,Dim);
        ub=Up*ones(1,Dim);
    else
        lb=Low;
        ub=Up;
    end
    PopPos=zeros(PopSize,Dim);
    PopFit=zeros(1,PopSize);
    for i=1:PopSize
        PopPos(i,:)=rand(1,Dim).*(ub-lb)+lb;
        PopFit(i)=BenFunctions(PopPos(i,:),FunIndex);
        % PopFit(i)=cec17_func(PopPos(i,:),FunIndex);
    end
    BestF=PopFit(1,:);
    Xprey=PopPos(1,:);
    for i=2:PopSize
        if PopFit(i)<=BestF
            BestF=PopFit(i);
            Xprey=PopPos(i,:);
        end
    end
    HisBestF=zeros(MaxIt,1);

    for It=1:MaxIt
        DirectVector=zeros(PopSize,Dim);
        E0=4*sin(1-It/MaxIt);
        for i=1:PopSize
            E=E0*log(1/rand);% Eq.(30)

            %new addition to the code
            scaleFactor = 1-(It/MaxIt)^0.5;

            Alpha = 2*scaleFactor; %scaling factor - resting and migrating
            Beta = 2*scaleFactor; %scaling factor - hunting and migrating
            Eta = 2*scaleFactor; %curling factor - hunting

            if Dim==1
                DirectVector(i,:)=1;
            else
                RandNum=ceil((MaxIt-It)/MaxIt*rand*(Dim-2)+2);%Eq.(6)
                RandDim=randperm(Dim);
                DirectVector(i,RandDim(1:RandNum))=1;
            end
            if E>1
                K=[1:i-1 i+1:PopSize];
                j=K(randi(PopSize-1));
                %Eq.(7),interacting
                if PopFit(j)<PopFit(i)
                    if rand>0.5
                        newPopPos=PopPos(j,:)+randn*DirectVector(i,:).*( mean(PopPos)-PopPos(i,:));
                    else
                        xr=rand(1,Dim).*(ub-lb)+lb;
                        newPopPos=PopPos(j,:)+1*randn*DirectVector(i,:).*( xr-PopPos(i,:));
                    end
                else
                    if rand>0.5
                        newPopPos=PopPos(i,:)+randn*DirectVector(i,:).*(mean(PopPos)-PopPos(j,:));
                    else
                        xr=rand(1,Dim).*(ub-lb)+lb;
                        newPopPos=PopPos(i,:)+randn*DirectVector(i,:).*( xr-PopPos(j,:));
                    end
                end
            else
                if rand<1/3
                    % resting
                    % Alpha=2*(exp(1)-exp(It/MaxIt))*sin(2*pi*rand); % Eq.(15)
                    rn=randi(PopSize);
                    rd=randi(Dim);
                    if length(Low)~=1
                        z=(PopPos(rn,rd)-lb(rd))/(ub(rd)-lb(rd));% Eq.(13)
                        Z=lb+z*(ub-lb);% Eq.(12)
                    else
                        Z=PopPos(rn,rd)*ones(1,Dim);
                    end
                    Ri=Z+Alpha.*abs(Z-Xprey);% Eq.(14)
                    newPopPos=Ri+randn*(Ri-round(rand)*PopPos(i,:));% Eq.(16)
                elseif rand>2/3
                    % migrating
                    rn=randi(PopSize);
                    rd=randi(Dim);
                    if length(Low)~=1
                        z=(PopPos(rn,rd)-lb(rd))/(ub(rd)-lb(rd));
                        Z=lb+z*(ub-lb);
                    else
                        Z=PopPos(rn,rd)*ones(1,Dim);
                    end
                    % Alpha=2*(exp(1)-exp(It/MaxIt))*sin(2*pi*rand);
                    Ri=Z+Alpha.*abs(Z-Xprey); % resting area
                    % Beta=2*(exp(1)-exp(It/MaxIt))*sin(2*pi*rand);%Eq.(21)
                    Hr=Xprey+Beta*abs(mean(PopPos)-Xprey);%Eq.(25) hunting area
                    L=0.01*abs(levy(Dim)); %Eq.(26)
                    newPopPos=-rand*Ri+rand*Hr-L.*(Hr-PopPos(i,:));%Eq.(24)
                else
                    %Hunting
                    % Beta=2*(exp(1)-exp(It/MaxIt))*sin(2*pi*rand);%Eq.(21)
                    Hprey=Xprey+Beta*abs(mean(PopPos)-Xprey);% Eq.(20) hunting area
                    % r4=rand;
                    % Eta=exp(r4*(1-It)/MaxIt)*(cos(2*pi*r4)); %Eq.(23)
                    newPopPos=Hprey+Eta*(Hprey-round(rand)*PopPos(i,:));%Eq.(22) hunting
                end
            end
            newPopPos=SpaceBound(newPopPos,ub,lb);
            newPopFit =BenFunctions(newPopPos,FunIndex);
            % newPopFit =cec17_func(newPopPos,FunIndex);
            if newPopFit<PopFit(i)
                PopFit(i)=newPopFit;
                PopPos(i,:)=newPopPos;
                if PopFit(i)<=BestF
                    BestF=PopFit(i);
                    Xprey=PopPos(i,:);
                end
            end
        end
        HisBestF(It)=BestF;
    end