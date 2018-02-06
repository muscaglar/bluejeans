function [ IV ] = FET_IV(CapID)
    

%%Working beautifully -> Outputting IV curves to origin with only a CapID
%%input.

DB = DBConnection;
E = Experiments(DB);
string = ['Capillary = ' num2str(CapID) ' AND FileType = 5 AND Suppressed = 0']; %Filetype 5 for FETs
E.SELECT(string);
Experiment_IDs = arrayfun(@(e)e, E.ResultSetIDs().toArray() );
%res_conc = E.getReservoirConc();

cap_conc = E.getCapillaryConc();
            i=0;
for e = Experiment_IDs'
    i=i+1;
    E.SELECT(e);
    res_conc(i) = E.getReservoirConc;
    %E.NextResult();
    [ IV{i}, FileName, PathName] = LoadIVByNo(e);

end
%Discard final 6 cols of IV

%Take unique set from 4th cols instead.

    
    %%  This is a terrible way to do this. Trying to find where the linear region is for the polyfit 
    max_el = max(abs(IV{1}(:,1)));
    max_loc = find(abs(abs(IV{1}(:,1)) - max_el) < 0.001);
    
    if max_loc(1) < 2
        locations(2) = 2;
        locations(3) = 3;
    else
        locations(2) = max_loc(1) - 1;
        locations(3) = max_loc(1) - 2;
    end
    locations(1) = max_loc(1);
    locations = sort(locations);
    %locations(3) = locations(2)+1;
    %% 
    %Ids vs Vds
    ORG = Matlab2OriginPlot;
    
    
    IV_cells = size(IV);
    IV_cells = IV_cells(2);
for z = 1:IV_cells
    
    IV_Size = size(IV{z});
    rows = IV_Size(1);
    IV{z} = IV{z}(:,1:IV_Size(2)-6);
    IV_Size = size(IV{z});
    sets = IV_Size(2)/4;
    n=1;

    figure;
    hold on;
    ORG.HoldOff;
    for x = 1:sets
        
        plot(IV{z}(:,n+1),IV{z}(:,n));
        ORG.PlotLine(IV{z}(:,n+1)',IV{z}(:,n)',[num2str(CapID) 'Res' num2str(res_conc(z)) 'M']);
        ORG.yComment(['bias' num2str(IV{z}(1,n+3))]);
         ORG.xlabel('Vds','mV');
         ORG.ylabel('Ids','nA');
        ORG.HideActiveWkBk();
        
        ORG.HoldOn;
        n=n+4;
    end
    ORG.yAxisAtZero(1);
    ORG.xAxisAtZero(1);
    ORG.title([num2str(CapID) 'Reservoir Concentration ' num2str(res_conc(z)) 'M']);
    title([num2str(CapID) 'Reservoir Concentration ' num2str(res_conc(z)) 'M']);
    hold off;
end
    ORG.Disconnect;
    
end