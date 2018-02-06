function [ V_Intercept, I_Intercept, R ] = FET_IVR_Analyse(Save, FileName, IV, PathName, id, bias)
    
    V_Intercept = VoltageIntercept(IV,0);
    [R, Rectification] = ResistanceAnalyse(IV,0);
    I_Intercept = CurrentIntercept(IV,0);
    

end