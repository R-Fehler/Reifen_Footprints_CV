function [num,txt,raw] = customReadCells(filename)
%customReadCells - Description
%   reads CSV files like the xlsread() function. returns seperated arrays.
% Syntax: [num,txt,raw] = customReadCells(filename,filepath)
%
% Long description
opts = detectImportOptions(filename);
A=readtable(filename,opts);
raw=table2cell(A);
num=raw;
txt=raw;
num(cellfun(@ischar,num)) = {NaN};
num=cell2mat(num);
txt(cellfun(@isnumeric,txt))={''};
end