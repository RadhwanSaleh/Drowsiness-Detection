function [Best_score,Best_pos,ABC_cg_curve] = DFSABC_ds(SearchAgents_no,Max_iter,lb,ub,dim)
load('initialization.mat')
FES=0;
UB=ones(1,dim)*ub; %/*lower bounds of the parameters. */
LB=ones(1,dim)*(lb);%/*upper bound of the parameters.*/
D=dim;
FoodNumber = SearchAgents_no/2;
%Initialize the positions of search agents
Positions=initialization(FoodNumber,dim,ub,lb);
    p = 0.1*FoodNumber;
for i=1:FoodNumber*0.1
    original=fix(rand*FoodNumber)+1;
    Positions(original,:) = GlobalParams2;
end
ABC_cg_curve=zeros(1,Max_iter);
limit=100; %/*A food source which could not be improved through "limit" trials is abandoned by its employed bee*/
uptrial=zeros(1,FoodNumber);
for i=1:FoodNumber
    net = setwb(net,Positions(i,:));
    ObjVal(i)=fobj3(net);
    Fitness(i)=calculateFitness(ObjVal(i));
    FES=FES+1;
end
% DFSABC/ds initialization
BestInd=find(ObjVal==min(ObjVal));
BestInd=BestInd(end);
GlobalMin=ObjVal(BestInd);
GlobalParams=Positions(BestInd,:);
trial=zeros(1,FoodNumber);
for GenIndex = 1 : Max_iter
%%%%%%%%% EMPLOYED BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%% 
        [~,sortInd] = sort(ObjVal);
        elite = Positions(sortInd(1:p),:);

      %%  %%%%%%%%% EMPLOYED BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%%
        eflag = 1;
        for s=1:(FoodNumber)
            if eflag==1
                % select a random solution from the population
                i=fix(rand*(FoodNumber))+1;
                sol = Positions(i,:);
            end

            %/*The parameter to be changed is determined randomly*/
            j=fix(rand*D)+1;

            %/*A randomly chosen solution is used in producing a mutant solution of the solution i*/
            k=fix(rand*(FoodNumber))+1;
            %/*Randomly selected solution must be different from the solution i*/
            while(k==i)
                k=fix(rand*(FoodNumber))+1;
            end

            % Randomly selected elite solution is used producing a mutant solution of the solution i
            e=fix(rand*(p))+1;
            %/*Randomly selected elite solution must be different from the solution i and k*/
            while(e==i || e==k)
                e=fix(rand*(p))+1;
            end

            sol(j)= elite(e,j)+(elite(e,j)-Positions(k,j))*(rand-0.5)*2;
            %  /*if generated parameter value is out of boundaries, it is shifted onto the boundaries*/
        ind=find(sol<LB);
        sol(ind)=LB(ind);
        ind=find(sol>UB);
        sol(ind)=UB(ind);

            %evaluate new solution
            net = setwb(net,sol);
            ObjValSol=fobj3(net);
            FES=FES+1;

            % /*a greedy selection is applied between the current solution i and its mutant*/
            if (ObjValSol<=ObjVal(i)) %/*If the mutant solution is better than the current solution i, replace the solution with the mutant and reset the trial counter of solution i*/
                Positions(i,:)=sol;
%                 Fitness(i)=FitnessSol;
                ObjVal(i)=ObjValSol;
                trial(i)=0;
                eflag=0;
                uptrial(i) = uptrial(i)+1;
            else
                trial(i)=trial(i)+1; %/*if the solution i can not be improved, increase its trial counter*/
                eflag=1;
            end

        end


        
     %%   %%%%%%%%%%%%%%%%%%%%%%%% ONLOOKER BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %         [~,sortInd] = sort(Fitness,'descend');
        %         sol_temp = Foods(sortInd(1:p),:);
        oflag=1;
        for i=1:FoodNumber
            
            if oflag==1
                % select a random solution from the elite
                e = ceil(rand*(p));
                sol = Positions(e,:);
            end

            %/*The parameter to be changed is determined randomly*/
            j = fix(rand*D)+1;

            %/*A randomly chosen solution is used in producing a mutant solution of the solution i*/
            k = fix(rand*(FoodNumber))+1;

            %/*Randomly selected solution must be different from the elite solution e*/
            while(k==e)
                k = fix(rand*(FoodNumber))+1;
            end


            sol(j)=0.5*(elite(e,j)+elite(1,j))+(elite(1,j)-Positions(k,j))*(rand-0.5)*2;
            %  /*if generated parameter value is out of boundaries, it is shifted onto the boundaries*/
        ind=find(sol<LB);
        sol(ind)=LB(ind);
        ind=find(sol>UB);
        sol(ind)=UB(ind);

            %evaluate new solution
            %ObjValSol=feval(objfun,sol);
            net = setwb(net,sol);
            ObjValSol=fobj3(net);
            FES=FES+1;

            % /*a greedy selection is applied between the current elite solution e and its mutant*/
            if (ObjValSol<=ObjVal(e)) %/*If the mutant solution is better than the current elite solution e, replace the solution with the mutant and reset the trial counter of solution e*/
                Positions(e,:)=sol;
%                 Fitness(e)=FitnessSol;
                ObjVal(e)=ObjValSol;
                trial(e)=0;
                oflag=0;
                uptrial(i) = uptrial(i)+1;
            else
                trial(e)= trial(e)+1; %/*if the solution e can not be improved, increase its trial counter*/
                oflag = 1;
            end
        end
         
         
%%%%%%%%%%%% SCOUT BEE PHASE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%/*determine the food sources whose trial counter exceeds the "limit" value. 
%In Basic ABC, only one scout is allowed to occur in each cycle*/

ind=find(trial==max(trial));
ind=ind(end);
ind1=find(uptrial==max(uptrial));
ind1=ind1(1);
if (trial(ind)>limit)
    uptrial(ind1) = 0;
    trial(ind)=0;
    m=(GlobalMin+Positions(ind1,:))/2;
    s=abs(GlobalMin-Positions(ind1,:));
    sol=m+randn*s;
    net = setwb(net,sol);
    val_sol=fobj3(net);
    solGOBL = (max(Positions)+min(Positions))*rand-Positions(ind,:);
    ind2=find(solGOBL<LB);
    solGOBL(ind2)=LB(ind2);
    ind2=find(solGOBL>UB);
    solGOBL(ind2)=UB(ind2);
    net = setwb(net,solGOBL);
    val_solGOBL=fobj3(net);
    if val_solGOBL<val_sol
        Positions(ind,:) = solGOBL;
        ObjVal(ind) =val_solGOBL;
        Fitness(ind)=calculateFitness(ObjVal(ind));
    else
        Positions(ind,:) = sol;
        ObjVal(ind) =val_sol;
        Fitness(ind)=calculateFitness(ObjVal(ind));
    end
    FES=FES+2;
end
%/*The best food source is memorized*/
         ind=find(ObjVal==min(ObjVal));
         ind=ind(end);
         if (ObjVal(ind)<GlobalMin)
         GlobalMin=ObjVal(ind);
         GlobalParams=Positions(ind,:);
         end
ABC_cg_curve(1,GenIndex)=GlobalMin;
end
%/*The best food source is memorized*/
         ind=find(ObjVal==min(ObjVal));
         ind=ind(end);
         Best_score=ObjVal(ind);
         Best_pos=Positions(ind,:);


