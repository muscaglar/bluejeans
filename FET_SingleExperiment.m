function [ output_args ] = FET_SingleExperiment( CapID, varargin)

    DB = DBConnection;
    E = Experiments(DB);
    string = ['Capillary = ' num2str(CapID) ' AND FileType = 5 AND Suppressed = 0']; %Filetype 5 for FETs
    E.SELECT(string);
    Experiment_IDs = arrayfun(@(e)e, E.ResultSetIDs().toArray());
    figure;
        
    colourWheel = {'Black', 'Red','Green','Blue','Cyan','Magenta','Yellow','Dark Yellow','Navy','Purple','Wine','Olive','Dark Cyan','Royal','Orange','Violet','Pink','White','LT Gray','Gray','LT Yellow','LT Cyan','LT Magenta','Dark Gray'};
 
    ORG = Matlab2OriginPlot();  
    %Plot the points for offset
    
    V_ds_I_gs = [];
    
    colour = 1;
    ORG.cd_TopLevel();

% Make a new dir called NewDir

% Move to the new dir
    
    ORG.mkdir_cd('Gate');
    Gate_name = ORG.Figure('Gate');
    
    ORG.cd_TopLevel();
    ORG.mkdir_cd('Drain');
    Drain_name = ORG.Figure('Drain');
    
    ORG.cd_TopLevel();
    ORG.mkdir_cd('Drain_Gate');
    Vds_Igs_name = ORG.Figure('Applied Drain, Sensed Gate');
    ORG.HoldOn;
                       
           for e = Experiment_IDs'     
                [ E, V_Intercepts, Bias, I_Intercepts, Resistances, I_ds, V_ds, I_gs, V_gs, IV ] = FET_Analyse(e);
                    x = Bias;
                    y = V_Intercepts;
                    fit = polyfit(x,y,1);
                    %scatter(x, y,'DisplayName',sprintf(''));
                    res_conc = E.getReservoirConc();
                    cap_conc = E.getCapillaryConc();
               %     plot(x,polyval(fit,x),'DisplayName',sprintf('exp: %s, grad:%f, resconc: %s, capconc: %s',num2str(e),fit(1),num2str(res_conc),num2str(cap_conc)));
                    hold on;
               %     scatter(x,y);  
                    legend('off'); legend('show');
                    
                    num2str(res_conc)
                    iter =1;

                    for x = V_gs(1,:)
                        V_ds_I_gs = [V_ds_I_gs V_ds(:,iter) I_gs(:,iter)];
                        iter = iter + 1;
                    end
                    
                   first_run = 0;
                    ORG.cd_TopLevel();       
                    ORG.cd('Drain');
                    ORG.PlotScatter(V_ds(:,colour)', I_ds(:,colour)', Drain_name,colourWheel{colour});
                    ORG.xlabel('Drain Source Voltage','mV');
                    ORG.ylabel('Drain Source Current ','nA');
                    ORG.yComment(num2str(res_conc));
                    ORG.HideActiveWkBk();
                    ORG.cd_TopLevel();
                    ORG.cd('Gate');
                    ORG.PlotScatter(V_gs(:,colour)', I_gs(:,colour)',Gate_name,colourWheel{colour});
                    ORG.xlabel('Gate Source Voltage','mV');
                    ORG.ylabel('Gate Source Current','nA');
                    ORG.yComment(num2str(res_conc));
                    ORG.HideActiveWkBk();
                    colour = colour + 1;
           end
           
           sized_IV = size(V_ds_I_gs);
           sized_IV = sized_IV(2);
           first_run = 1; 
           
           index = iter-1;
           
           iter =1;
           ORG.cd_TopLevel();
           ORG.cd('Drain_Gate');
           for x = 1:2:sized_IV
                ORG.PlotScatter(V_ds_I_gs(:,x)',V_ds_I_gs(:,x+1)', Vds_Igs_name, colourWheel{iter});
                ORG.xlabel('Drain Source Voltage','mV');
                ORG.ylabel('Gate Source Current','nA');
                 
                if(first_run == 1)
                        ORG.yComment(num2str(V_gs(1,iter)));
                        else
                        ORG.delete_yComment();
                 end
                  
                      if ( mod(iter,index) == 0)
                         iter = 1;
                         first_run = 0;
                      else
                          iter = iter + 1;
                      end    
                      
                ORG.HideActiveWkBk();
           end
           
            title('VOffset vs Bias ');
     
    xlabel('Bias');
    ylabel('VOffset');
 
            ORG.Disconnect();
end

