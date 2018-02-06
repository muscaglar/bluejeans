function [ IV ] = FET_InterceptPlot(CapID)

colourWheel = {'Black', 'Red','Green','Blue','Cyan','Magenta','Yellow','Dark Yellow','Navy','Purple','Wine','Olive','Dark Cyan','Royal','Orange','Violet','Pink','White','LT Gray','Gray','LT Yellow','LT Cyan','LT Magenta','Dark Gray'};

DB = DBConnection;
E = Experiments(DB);
string = ['Capillary = ' num2str(CapID) ' AND FileType = 5 AND Suppressed = 0']; %Filetype 5 for FETs
E.SELECT(string);
Experiment_IDs = arrayfun(@(e)e, E.ResultSetIDs().toArray() );
res_conc = E.getReservoirConc();
cap_conc = E.getCapillaryConc();

    ORG = Matlab2OriginPlot();  
    %Plot the points for offset
   
    V_name = ORG.Figure('Voltage Intercepts');
    I_name = ORG.Figure('Current Intercepts');
    R_name = ORG.Figure('Voltage Offset vs Resistance');

    ORG.HoldOn;
                  I_ds_all = [];
                  V_ds_all = [];
                  I_gs_all = [];
                  V_gs_all = [];
    i=0;
    colour = 1;
           for e = Experiment_IDs'
                i=i+1;
                [ E, V_Intercepts, Bias, I_Intercepts, Resistances, I_ds, V_ds, I_gs, V_gs ] = FET_Analyse(e);
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
                    conc = E.getReservoirConc();
                    result(z+result_iter,5) = conc;
                    result(z+result_iter,6)= E.getCapillaryConc();
                    test = I_ds;
                end

                ORG.PlotScatter(Bias, V_Intercepts,V_name,colourWheel{colour});
                ORG.yComment(num2str(conc));

                ORG.PlotScatter(Bias, I_Intercepts,I_name,colourWheel{colour});
                ORG.yComment(num2str(conc));

                  I_ds_all = [I_ds_all; I_ds];
                  V_ds_all = [V_ds_all; V_ds];
                  I_gs_all = [I_gs_all; I_gs];
                  V_gs_all = [V_gs_all; V_gs];                        
                colour = colour +1;
           end
           
           sorted_results = sortrows(result,4);
           biases = unique(sorted_results(:,4));
           
           ORG.ActivatePage(I_name)
           ORG.ylabel('Current Intercept','nA');
           ORG.xlabel('Voltage Bias','mV');
           
           ORG.ActivatePage(V_name)
           ORG.ylabel('Voltage Intercept','mV');
           ORG.xlabel('Voltage Bias','mV');

%            ORG.ActivatePage(Igs_Vds)
%            ORG.ylabel('Igs','nA');
%            ORG.xlabel('Vds','mV');
%            
%            ORG.ActivatePage(Ids_Vds)
%            ORG.ylabel('Ids','nA');
%            ORG.xlabel('Vds','mV');
           
%            ORG.PlotScatter(Resistances, V_Intercepts,R_name,colourWheel{colour});
%            ORG.yComment(num2str(conc));           
%            ORG.ActivatePage(R_name)
%            ORG.ylabel('Resistance','');
%            ORG.xlabel('Voltage Bias','mV');
%     x=1;


%     number_of_biases = size(biases);
%     number_of_biases = number_of_biases(1);
%     Igs_Vds = ORG.Figure('Igs_Vds');
%     Ids_Vds = ORG.Figure('Ids_Vds');
%     Igs_Vgs = ORG.Figure('Igs_Vgs');
%     I_V = ORG.Figure('I_V');
%     I_V2 = ORG.Figure('I_V2'); 
%     
%     for i = 1:1:number_of_biases
%          ORG.PlotScatter(V_ds_all(:,i)', I_ds_all(:,i)' ,I_V ,colourWheel{i});
%          ORG.PlotScatter(V_gs_all(:,i)', I_gs_all(:,i)' ,I_V2 ,colourWheel{i});
%     end
           
    ORG.HoldOff;
  
    ORG.Disconnect();


end