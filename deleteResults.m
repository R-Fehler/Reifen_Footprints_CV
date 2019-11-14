clearvars;
close all hidden;

dirpath=uigetdir('waehle den zu bearbeitenden Ordner aus');

cd(dirpath);

del_folder={'corrected' ;'cropped' ;'overlay'};

listofDirs=dir(dirpath);
j=1;
for ii = 1 : size(listofDirs,1)
    if(listofDirs(ii).isdir     && ~contains(listofDirs(ii).name,'.') && ~contains(listofDirs(ii).name ,'..'))
        MainListofDirs(j) = listofDirs(ii); %#ok<SAGROW> % bei Bedarf vor allocaten, aber im Moment egal
        j=j+1;
        
    end
    
end

for d=1:length(MainListofDirs)
    currentFolder=MainListofDirs(d);
    cd(fullfile(currentFolder.folder,currentFolder.name));
    delete *.pdf;
    delete *.txt;
    for ii=1:size(del_folder)
        del_cell=fullfile(currentFolder.folder,currentFolder.name, del_folder(ii));
        if(exist(del_cell{1},'dir'))
            rmdir(del_cell{1},'s');
        end
        
    end
end




