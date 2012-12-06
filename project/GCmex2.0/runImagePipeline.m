function runImagePipeline()

%run_EveryThing([25 40 55 70],'People',{'entropyPenalty';'removedLog';'stdDevPenalty'},3,'People/Results/PeopleCtrs.mat',4,5);
run_EveryThing([25 40 55 70],'Cars',{'entropyPenalty';'removedLog';'stdDevPenalty'},3,'Cars/attPoints/CarsCtrs.mat',4,5);
%run_EveryThing([25 40 55 70],'Buses',{'entropyPenalty';'removedLog';'stdDevPenalty'},3,'Buses/Results/BusesCtrs.mat',4,5);
%run_EveryThing([25 40 55 70],'FarmAnims',{'entropyPenalty';'removedLog';'stdDevPenalty'},3,'FarmAnims/Results/FarmAnimsCtrs.mat',4,5);
%run_EveryThing([25 40 55 70],'HouseAnims',{'entropyPenalty';'removedLog';'stdDevPenalty'},3,'HouseAnims/Results/HouseAnimsCtrs.mat',4,5);
%run_EveryThing([25 40 55 70],'Monitors',{'entropyPenalty';'removedLog';'stdDevPenalty'},3,'Monitors/Results/MonitorsCtrs.mat',4,5);
% run_EveryThing(25,'People','entropyPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(25,'People','removedLog','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(40,'People','stdDevPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(40,'People','entropyPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(40,'People','removedLog','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(55,'People','stdDevPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(55,'People','entropyPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(55,'People','removedLog','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(70,'People','entropyPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(70,'People','stdDevPenalty','People/Results/PeopleCtrs.mat',4,5);
% run_EveryThing(70,'People','removedLog','People/Results/PeopleCtrs.mat',4,5);
% 
% run_EveryThing(25,'Buses','removedLog','Buses/Results/BusesCtrs.mat');
% run_EveryThing(25,'Buses','stdDevPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(25,'Buses','entropyPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(40,'Buses','removedLog','Buses/Results/BusesCtrs.mat');
% run_EveryThing(40,'Buses','stdDevPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(40,'Buses','entropyPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(55,'Buses','removedLog','Buses/Results/BusesCtrs.mat');
% run_EveryThing(55,'Buses','stdDevPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(55,'Buses','entropyPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(70,'Buses','removedLog','Buses/Results/BusesCtrs.mat');
% run_EveryThing(70,'Buses','stdDevPenalty','Buses/Results/BusesCtrs.mat');
% run_EveryThing(70,'Buses','entropyPenalty','Buses/Results/BusesCtrs.mat');
% 
% run_EveryThing(25,'FarmAnims','removedLog','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(25,'FarmAnims','stdDevPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(25,'FarmAnims','entropyPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(40,'FarmAnims','removedLog','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(40,'FarmAnims','stdDevPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(40,'FarmAnims','entropyPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(55,'FarmAnims','removedLog','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(55,'FarmAnims','stdDevPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(55,'FarmAnims','entropyPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(70,'FarmAnims','removedLog','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(70,'FarmAnims','stdDevPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% run_EveryThing(70,'FarmAnims','entropyPenalty','FarmAnims/Results/FarmAnimsCtrs.mat');
% 
% run_EveryThing(25,'HouseAnims','removedLog','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(25,'HouseAnims','stdDevPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(25,'HouseAnims','entropyPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(40,'HouseAnims','removedLog','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(40,'HouseAnims','stdDevPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(40,'HouseAnims','entropyPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(55,'HouseAnims','removedLog','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(55,'HouseAnims','stdDevPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(55,'HouseAnims','entropyPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(70,'HouseAnims','removedLog','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(70,'HouseAnims','stdDevPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% run_EveryThing(70,'HouseAnims','entropyPenalty','HouseAnims/Results/HouseAnimsCtrs.mat');
% 
% run_EveryThing(25,'Monitors','removedLog','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(25,'Monitors','stdDevPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(25,'Monitors','entropyPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(40,'Monitors','removedLog','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(40,'Monitors','stdDevPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(40,'Monitors','entropyPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(55,'Monitors','removedLog','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(55,'Monitors','stdDevPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(55,'Monitors','entropyPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(70,'Monitors','removedLog','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(70,'Monitors','stdDevPenalty','Monitors/Results/MonitorsCtrs.mat');
% run_EveryThing(70,'Monitors','entropyPenalty','Monitors/Results/MonitorsCtrs.mat');
% 
% run_EveryThing(25,'Planes','removedLog','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(25,'Planes','stdDevPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(25,'Planes','entropyPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(40,'Planes','removedLog','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(40,'Planes','stdDevPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(40,'Planes','entropyPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(55,'Planes','removedLog','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(55,'Planes','stdDevPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(55,'Planes','entropyPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(70,'Planes','removedLog','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(70,'Planes','stdDevPenalty','Planes/Results/PlanesCtrs.mat');
% run_EveryThing(70,'Planes','entropyPenalty','Planes/Results/PlanesCtrs.mat');

end