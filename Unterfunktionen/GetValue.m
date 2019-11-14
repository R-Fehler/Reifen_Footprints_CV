function [AllPoints]=GetValue(AllPoints) 
dcm_obj=datacursormode;
info=getCursorInfo(dcm_obj);

if isempty(info)==0
    xVal=info.Position(1,1);
    yVal=info.Position(1,2);
   
  AllPoints=[AllPoints;xVal,yVal];
end

if size(AllPoints,1)>1
    hold on
    plot(AllPoints(:,1),AllPoints(:,2))
    hold off
end

datacursormode on