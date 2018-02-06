
%%Fix this%%


% Why is the input result and not CapID? Write a wrapper?
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

function [ output_args ] = FET_Plot( result )

            tf = iscell(result);
            if(tf)
                result{1} = FET_Clean(result{1}); %Needed here still?
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

%function [ V_Intercept, I_Intercept, R ] = FET_IVAnalyse(Save, FileName, IV, PathName, id, bias)
    
figure;
subplot(2,2,1);
scatter(Bias, V_Intercepts);
subplot(2,2,2);
scatter(Bias, Resistances);
subplot(2,2,3);
scatter(Bias, I_Intercepts);

   % [ date, no] = FileNameInterpret( FileName );
    figure(1);
    subplot(2,2,1)
    plot(result(:,4), result(:,1));
    %V_Intercept = VoltageIntercept(IV);  num2str(no) num2str(V_Intercept)
    title({['V Intercept ' num2str(date) ],[', File: '  ' Intercept: ' 'mV']})

    subplot(2,2,2)
    [R, Rectification] = ResistanceAnalyse(IV);
    G = 1/R;
     title({['Resistance Calculation: R = ' num2str(R)], [', G = ' num2str(G) ', IV1 = ' num2str(Rectification(1)) ],[', IV2 = ' num2str(Rectification(2)) ', Ratio = ' num2str(Rectification(3)) ]});

    subplot(2,2,3) ;
    I_Intercept = CurrentIntercept(IV);
    title({['I Intercept: ' num2str(I_Intercept) 'nA']});
    

    %GHK Permeability Analysis
    %need the pH for this file.
    subplot(2,2,4) 
    [ ExptData , E ] = ReturnExperimentalDetails( date, no );
    if(E.getid() > 0)
        pHRes = ExptData{3};
        pHCap = ExptData{2};
        size = GetCapSize(ExptData{4});
        [ P, N, O ] = GHK_FitPermeabilityMonoCharge( IV, double(E.getCapillaryConc), double(E.getReservoirConc),V_Intercept); 
    else
        % Need to close subplot
        disp('No DB entry for this file so no Conc information');
        hold off;
        plot(0,0);
        P = 0;
        N = 0 ;
        O = 0;
        pHRes = 0;
        size = 0;
        pHCap = 1;
        
        %Could create an entry here  - but suppress the analysis until I
        %link it to a capillary
        
    end
    
   
    %Save the plot out.
    switch(Save)
        case 0
            disp('Don''t save');        
        case 1
            if exist([PathName '/Analysis'],'dir') == 0
                mkdir(PathName,'Analysis') 
            end
            if exist([PathName '/Analysis/Plots'],'dir') == 0
                mkdir([PathName '/Analysis'],'Plots') 
            end
            print([PathName '/Analysis/Plots/' num2str(date) '_' num2str(no) '_' num2str(bias) '.jpg'],'-djpeg');
        otherwise 
    end
end




