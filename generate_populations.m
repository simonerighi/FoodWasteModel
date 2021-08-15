
% INITIALIZATIONS
 
types_vct=zeros(N,NSim); 
O=zeros(N,NSim);
A=zeros(N,NSim);
CD=zeros(N,NSim);
   
% load files and set values containing the calibration
Op_huge = xlsread('Tables_for_calibration.xlsx','Opinion','B2:C4');
Op_serious = xlsread('Tables_for_calibration.xlsx','Opinion','B12:C15');
Op_worry = xlsread('Tables_for_calibration.xlsx','Opinion','B24:C27');

Op_huge_max=[1/3 2/3 1];
Op_other_max=[0.25 0.5 0.75 1];

FW_F = xlsread('Tables_for_calibration.xlsx','Action','B2:C6');
FW_Q = xlsread('Tables_for_calibration.xlsx','Action','B16:C21');
FW_V = xlsread('Tables_for_calibration.xlsx','Action','B32:C39');

FW_F_lims=[0.0714 0.1429 0.2857 0.5714 1];
FW_Q_lims=[0 0.0833 0.1667 0.3333 0.6667 1];
FW_V_lims=[0.0714 0.1429 0.2143 0.2857 0.4286 0.5714 0.7143 1];

 for nn=1:NSim 
     % Create types of agents
     types=zeros(N,1); % initalize number of agents for each type according to share_pop
     types(1:round(N*share_pop(1)))=1;
     types(round(N*share_pop(1))+1:end)=2;
     types_vct(:,nn)=types(randperm(N)); % shuffle the populations
     clear types
     
     for i=1:N % for each agent
         if types_vct(i,nn)==1; ncol=1; else ncol=2; end % take the right columns of the input tables of values according to type of the agent
         
         Mod_Op_huge=datasample(1:length(Op_huge_max),1,'Weights', Op_huge(:,ncol));
         O1=from_modality_to_level(Mod_Op_huge,Op_huge_max); % Opinion on hugeness
         Mod_Op_serious=datasample(1:length(Op_other_max),1,'Weights', Op_serious(:,ncol));
         O2=from_modality_to_level(Mod_Op_serious,Op_other_max); % Opinions on seriousness         
         Mod_Op_worry=datasample(1:length(Op_other_max),1,'Weights', Op_worry(:,ncol));
         O3=from_modality_to_level(Mod_Op_worry,Op_other_max); % Opinions on worrying about FW
         O(i,nn)=(O1+O2+O3)/3; %average of opinions
         
         Mod_FW_F=datasample(1:length(FW_F_lims),1,'Weights', FW_F(:,ncol));
         A1=from_modality_to_level(Mod_FW_F,FW_F_lims);  % action on FW Frequency         
         Mod_FW_Q=datasample(1:length(FW_Q_lims),1,'Weights', FW_Q(:,ncol));
         A2=from_modality_to_level(Mod_FW_Q,FW_Q_lims);  % action on FW Quantity 
         Mod_FW_V=datasample(1:length(FW_V_lims),1,'Weights', FW_V(:,ncol));
         A3=from_modality_to_level(Mod_FW_V,FW_V_lims); % action on FW value
         A(i,nn)=(A1+A2+A3)/3; %average of actions      
         
         CD(i,nn)=abs(O(i,nn)-A(i,nn));
         
         clear O1 O2 O3 A1 A2 A3 Mod_Op_huge Mod_Op_serious Mod_Op_worry Mod_FW_F Mod_FW_Q Mod_FW_V ncol
     end     
 end
 
types=types_vct;
clear types_vct