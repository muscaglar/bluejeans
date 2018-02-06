function [result] = FET_AnalyseByCapillary( CapID , varargin)

biased = 0;
By_experiment = 0;

if nargin >= 3
    bias = varargin{1};
    biased = 1;
    Experiment_IDs = varargin{2}';
    By_experiment = 1;
else if nargin >= 2
    bias = varargin{1};
    biased = 1;
    end
end

i=0;

DB = DBConnection;
E = Experiments(DB);
string = ['Capillary = ' num2str(CapID) ' AND FileType = 5 AND Suppressed = 0']; %Filetype 5 for FETs
E.SELECT(string);
if(By_experiment==0)
Experiment_IDs = arrayfun(@(e)e, E.ResultSetIDs().toArray() );
end
res_conc = E.getReservoirConc();
cap_conc = E.getCapillaryConc();
        if biased
            for e = Experiment_IDs'
            i=i+1;
            [ E, V_Intercepts, Bias, I_Intercepts, Resistances ] = FET_Analyse(e, bias); % [ E, V_Intercepts, Bias, I_Intercepts, Resistances ] 
            if isempty(V_Intercepts)
            else
            result(i,1) = V_Intercepts;
            result(i,2) = I_Intercepts;
            result(i,3) = Resistances;
            result(i,4) = Bias;
            result(i,5)= E.getReservoirConc();
            result(i,6)= E.getCapillaryConc();
            end
            end
        else
            for e = Experiment_IDs'
                i=i+1;
                [ E, V_Intercepts, Bias, I_Intercepts, Resistances ] = FET_Analyse(e);
                j = size(V_Intercepts); %number of data points
                iter = j(2);
                    if exist('result','var') == 1
                        result_size = size(result);
                        result_iter = result_size(1);
                    else
                        result_iter = 0;
                    end
                for z=1:(iter)
                    result(z+result_iter,1) = V_Intercepts(z);
                    result(z+result_iter,2) = I_Intercepts(z);
                    result(z+result_iter,3) = Resistances(z);
                    result(z+result_iter,4) = Bias(z);
                    result(z+result_iter,5)= E.getReservoirConc();
                    result(z+result_iter,6)= E.getCapillaryConc();
                end
            end
            
          if biased
          else
              result = sortrows(result,4);
%                result_size = size(result);  %Sorting by bias.
%                 for c = 1:result_size(2)
%                     %result{c} = sortrows(result{c},4);
%                 end
          end
%        end
        
        result = FET_Clean(result);
end
