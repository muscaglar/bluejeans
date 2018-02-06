function [ result ] = FET_AnalyseOverCapillaries( CapIDs, varargin )

biased = 0;
result{1} = 0;

if nargin >= 2
    bias = varargin{1};
    biased = 1;
end

    for idx = 1:numel(CapIDs)
        Cap = CapIDs(idx)
        if(biased)
            result{idx} = FET_AnalyseByCapillary(Cap, bias);
        else
            result{idx} =  FET_AnalyseByCapillary(Cap);
        end
    end

     fh=findall(0,'type','figure');
        for i=1:length(fh)
            clo(fh(i));
        end

%Within each file:
        % Use VIntercept -> These also clean the points
% Plot within file IVs - for different bias shown in legend. 
        % Seperate out into 4s etc..
% Plot Voltage offset, resistance and current offset -> Vint vs Gate, IIn
% vs Gate and R vs Gate. 
            % Populating VInt and GVs vectors.
% Need retrun of gate oltage, voltage offset, current offset, resistance, exp object = FETAnalyse(Exp_ID) 

% 
% VInt (1) vs Bias (4)
% IIn (2) vs Bias (4)
% Resistances vs Bias(4)


% E is the exp. object.

end