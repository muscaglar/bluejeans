function [ result ] = FET_Clean( result )

result = result(result(:,1) ~= 0 ,:);

result_size = size(result);
clean = [];
z=1;
for i = 1:result_size(1)
    if(result(i,1) > 50)
        clean(z) = i;
        z=z+1;
    else if (result(i,1)< -50)
        clean(z) = i;
        z=z+1;
        end
    end
end

%result(clean , : ) = [];


% sizes = size(result);
% rows = sizes(1);
% 
% for i=1:rows
%     if(result(i,1)==0)
%         result = vertcat(result([1:(i-1)],:) , result([(i+1):rows],:));
%     end
% end

end

