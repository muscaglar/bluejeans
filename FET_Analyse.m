function [ E, V_Intercepts, Bias, I_Intercepts, Resistances, I_ds, V_ds, I_gs, V_gs, IV ] = FET_Analyse(ID, varargin)

save = 0;
VoltageZeroOffset = 0;
biased = 0;

if nargin >= 2
    bias = varargin{1};
    biased = 1;
end

% Within each file:
        % Use VIntercept -> These also clean the points
% Plot within file IVs - for different bias shown in legend. 
        % Seperate out into 4s etc..
% Plot Voltage offset, resistance and current offset -> Vint vs Gate, IIn
% vs Gate and R vs Gate. 
            % Populating VInt and GVs vectors.
% Need retrun of gate oltage, voltage offset, current offset, resistance, exp object = FETAnalyse(Exp_ID) 

% E is the exp. object.

[ E, No, id, Date ] = GetExperimentDetails(ID) ;
[ IV, FileName, PathName] = LoadIVByNo(ID);
% IV contains the full set of data.

%Discard final 6 cols of IV
IV_Size = size(IV);
rows = IV_Size(1);
cols = IV_Size(2)-6;
sets = cols/4;
n=1;

V_Intercepts = [];
Bias = [];
I_Intercepts = [];
Resistances = [];
I_ds = [];
V_ds = [];
I_gs = [];
V_gs = [];

lower_range = 0.95;
upper_range = 1.05;

%% 
%   Ids(nA)	  Vds	  Igs	    Vgs


%%

fudge = 0;%0.5;

if (biased)
  while n<=sets
     add = n*4;
     Ids = add - 3;
     Vds = add - 2;
     Igs = add - 1;
     Vgs = add;
     IV(:,Ids) = IV(:,Ids)- fudge ; %Fudge the IV data here.
     current_bias = round(mean(IV(:,add)));
     ratio = current_bias/bias;
     I_ds = [I_ds IV(:,Ids)];
     V_ds = [V_ds IV(:,Vds)];
     I_gs = [I_gs IV(:,Igs)];
     V_gs = [V_gs IV(:,Vgs)];
    if(bias == 0 && current_bias <10 && current_bias > -10)
        current_IV = [IV(:,add-3) IV(:,add-2)-VoltageZeroOffset];
        [V_Intercept, I_Intercept, R ] = FET_IVR_Analyse(save, FileName, current_IV, PathName, VoltageZeroOffset, current_bias);
        V_Intercepts = [V_Intercepts V_Intercept];
        Bias = [Bias current_bias];
        I_Intercepts = [I_Intercepts I_Intercept];
        Resistances = [Resistances R];
    elseif( ratio < upper_range && ratio > lower_range)  %0.9 - 1.1
        current_IV = [IV(:,add-3) IV(:,add-2)-VoltageZeroOffset];
        [V_Intercept, I_Intercept, R ] = FET_IVR_Analyse(save, FileName, current_IV, PathName, VoltageZeroOffset, current_bias);
        V_Intercepts = [V_Intercepts V_Intercept];
        Bias = [Bias current_bias];
        I_Intercepts = [I_Intercepts I_Intercept];
        Resistances = [Resistances R];
     end
     
     n=n+1;
  end
  
else 
    
  while n<=sets
     add = n*4;
     Ids = add - 3;
     Vds = add - 2;
     Igs = add - 1;
     Vgs = add;
     IV(:,Ids) = IV(:,Ids) - fudge; %Fudge the IV data here.
     current_bias = round(mean(IV(:,add))); 
     current_IV = [IV(:,add-3) IV(:,add-2)-VoltageZeroOffset];
         [V_Intercept, I_Intercept, R ] = FET_IVR_Analyse(save, FileName, current_IV, PathName, VoltageZeroOffset, current_bias);
             V_Intercepts = [V_Intercepts V_Intercept];
             Bias = [Bias current_bias];
             I_Intercepts = [I_Intercepts I_Intercept];
             Resistances = [Resistances R];
     I_ds = [I_ds IV(:,Ids)];
     V_ds = [V_ds IV(:,Vds)];
     I_gs = [I_gs IV(:,Igs)];
     V_gs = [V_gs IV(:,Vgs)];
     n=n+1;
  end
  
end

%V_intercept(bias < 1.05 && bias > 0.95) array indexing. 
% Keep whole data and filter for bias afterwards. 


%Data 6, VInt Data 7, IInt

end


