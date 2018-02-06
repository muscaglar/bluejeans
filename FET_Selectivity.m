function [ result ] = FET_Selectivity( CapID, CapExp, Plot, varargin)

%The variable input is for biases

all_bias = 0;

%This is a mess.

% I need to input the expeirment ids (sometimes) and specify a bias
% (sometimes)
% If no bias is provided, the code will calcualte all selectvies across all
% biases. So the resultant graph is selectivity vs bias.

%Doesnt work on Tecella Data?

   variables =  size(varargin);
   variables = variables(2); %number of variables. 

if (CapExp == 'Cap')
    if(variables == 1) %ie if there is an input
     bias = varargin{1};
    else
    all_bias = 1;
   end
end

if (CapExp == 'Exp')
   if(variables == 1)
    Experiment_IDs = varargin{1};
    all_bias = 1;
   else
    bias = varargin{1};
    Experiment_IDs = varargin{2};
   end
end


i=0;
if(all_bias)
    for bias= -200:40:200
        i = i+1; %crashes at i=5
        Xrange = [0.001 0.01 0.1 1 4];
        if (CapExp == 'Exp')
              result = FET_AnalyseByCapillary(CapID, bias, Experiment_IDs);
        else
              result = FET_AnalyseByCapillary(CapID, bias);
        end
        [ current_Selectivity, CurrentGradient] = FET_SelectivityFromValues(result(:,5),result(:,6), result(:,1), result(:,2), Xrange, CapID, bias, 0 );
        if ( current_Selectivity == 0)
            i=i-1;
        else
        Selectivity(i) = current_Selectivity(1);
        Selectivity_error(i) = current_Selectivity(2);
        Biases(i) = bias;
        Selective_current(i)=CurrentGradient(1);
        Selective_current_error(i)=CurrentGradient(2);
        end
    end
    close all;
    scatter(Biases, Selectivity);
else
    Xrange = [0.001 0.01 0.1 1 4];
    result = FET_AnalyseByCapillary(CapID, bias);
    FET_SelectivityFromValues(result(:,5),result(:,6), result(:,1), result(:,2), Xrange, CapID, bias,1);
end

if(Plot == 'Origin')
    
    ORG = Matlab2OriginPlot();
    %Plot the points for offset
    ORG.Figure('SelectivityVsBias');
    ORG.HoldOn;
    ORG.PlotScatterError(Biases, Selectivity, Selectivity_error, ['_VMeanStd'],'red');
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Voltage Offset','mV');
    ORG.HideActiveWkBk()
    
    ORG.HoldOff;

    ORG.Figure('CurrentVsBias');
    ORG.HoldOn;
    ORG.PlotScatterError(Biases, Selective_current, Selective_current_error, ['_VMeanStd'],'red');
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Voltage Offset','mV');
    ORG.HideActiveWkBk()
    
    ORG.HoldOff;
    ORG.Disconnect();
end

end