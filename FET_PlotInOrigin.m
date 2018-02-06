%   To add flexibility. So use in call:
        
        % function [result] = FET_AnalyseByCapillary( CapID , varargin)
            % biased = 0;
            % By_experiment = 0;
            % 
            % if nargin >= 3
            %     bias = varargin{1};
            %     biased = 1;
            %     Experiment_IDs = varargin{2}';
            %     By_experiment = 1;
            % else if nargin >= 2
            %     bias = varargin{1};
            %     biased = 1;
            %     end
            % end

function [ ] = FET_PlotInOrigin( result) %Capillary, bias )

% CapillaryIDs = Capillary;
%     MembraneName = '';
%     PlotName = ['C' num2str(CapillaryIDs(1))];
% 
%  %       [ ~, ~, ~, ~, ResConcs,CapConcs, VoltageOffsets, CurrentOffsets, No ] = Selectivity( CapillaryIDs );
%  
% 
%     result = FET_AnalyseByCapillary(Capillary, bias);
       %     result{1} = FET_Clean(result{1});
       
tf = iscell(result);
            if(tf)
                V_Intercepts  =  result{1}(:,1);
                I_Intercepts  =  result{1}(:,2);
                Resistances   =  result{1}(:,3);
                Bias          =  result{1}(:,4);
                ReservoirConc =  result{1}(:,5);
                CapillaryConc =  result{1}(:,6);
            else
                V_Intercepts  =  result(:,1);
                I_Intercepts  =  result(:,2);
                Resistances   =  result(:,3);
                Bias          =  result(:,4);
                ReservoirConc =  result(:,5);
                CapillaryConc =  result(:,6);
            end
            
            XValues = unique(ReservoirConc);
  
 %% Problems 
 PlotName = 'Test';
 MembraneName = 'Test';
% VOffsetFitted isn't defined
            

%% Plotting here %%
unique_bias= unique(Bias);
figure;
for i = 1:size(unique_bias)
    current = unique_bias(i);
    id = find(Bias(:,1) == current);
    x = ReservoirConc(id);
    y = V_Intercepts(id);
    fit = polyfit(log10(x),y,1);
    %scatter(x, y,'DisplayName',sprintf(''));
    %semilogx(x,polyval(fit,log10(x)),'DisplayName',sprintf('bias:%d, grad:%f',Bias(i),fit(1)));
    if(fit(1)>100)
    else
    scatter(current,fit(1));
    end
    hold on;
end

legend('off'); legend('show');

figure;
for i = 1:size(unique_bias)
    current = unique_bias(i);
    id = find(Bias(:,1) == current);
    x = ReservoirConc(id);
    y = I_Intercepts(id);
    fit = polyfit(log10(x),y,1);
    %scatter(x, y,'DisplayName',sprintf(''));
    %semilogx(x,polyval(fit,log10(x)),'DisplayName',sprintf('bias:%d, grad:%f',Bias(i),fit(1)));
    scatter(current,fit(1));
    hold on;
end

legend('off'); legend('show');
            
    %Plot in Origin
    ORG = Matlab2OriginPlot();
    
    %Plot the points for offset
    ORG.Figure([PlotName 'VoltageOffsets']);
    ORG.HoldOn;
    ORG.PlotScatter(ReservoirConc', V_Intercepts',[PlotName '_VPoints'],'LT Magenta');
    ORG.logXScale
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Voltage Offset','mV');
    ORG.yComment(MembraneName);
    ORG.title([PlotName '_VoltageOffsets']);
    ORG.AddText('Created using MikesOriginPlot library');
    ORG.HideActiveWkBk()
    
    %Plot the fit to the points
    ORG.HoldOn;
    ORG.PlotLine(XValues,VOffsetFitted,[PlotName '_VFit'],'red');
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Voltage Offset','mV');
    ORG.AddText(['Gradient is ' num2str(TotalVGrad(1)) '+/- ' num2str(StdVErrors(1))]);
    ORG.yComment(['Fit to' MembraneName 'Grad:' num2str(TotalVGrad(1),3) '+/- ' num2str(StdVErrors(1),3)]);
    ORG.HideActiveWkBk()
    
    %Plot the Mean and Error at each pH - note might want to transfer all
    %values, as it also have info on distribution
    ORG.PlotScatterError(XV(:,1)',XV(:,2)',XV(:,3)', [PlotName '_VMeanStd'],'red');
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Voltage Offset','mV');
    ORG.yComment(MembraneName);
    ORG.HideActiveWkBk()
    
    %ORG.HoldOff;
    %------------------------------------------
    %Now plot the current data
    
    %Plot the points for offset
    ORG.Figure([PlotName 'CurrentOffsets']);
    ORG.PlotScatter(ReservoirConc', I_Intercepts',[PlotName '_IPoints'],'LT Cyan');
    ORG.logXScale
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Current','nA');
    ORG.yComment(MembraneName);
    ORG.title([PlotName '_CurrentOffsets']);
    ORG.AddText('Created using MikesOriginPlot library');
    ORG.HideActiveWkBk()
    
    %Plot the fit to the points
    ORG.HoldOn;
    ORG.PlotLine(XValues,IOffsetFitted,[PlotName '_IFit'],'blue');
    ORG.AddText(['Gradient is ' num2str(TotalIGrad(1)) '+/- ' num2str(StdIErrors(1))]);
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Current','nA');
    ORG.yComment(['Fit to' MembraneName 'Grad:' num2str(TotalIGrad(1),3) '+/- ' num2str(StdIErrors(1),3)]);
    ORG.HideActiveWkBk()
    
    %Plot the Mean and Error at each pH - note might want to transfer all
    %values, as it also have info on distribution
    ORG.PlotScatterError(XI(:,1)',XI(:,2)',XI(:,3)', [PlotName '_IMeanStd'],'blue')
    ORG.xlabel('Concentration','M');
    ORG.ylabel('Current','nA');
    ORG.yComment(MembraneName);
    ORG.HideActiveWkBk()
    
    %ORG.HoldOff;
    ORG.Disconnect();

end


