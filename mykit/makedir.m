function makedir( folder )
%MAKEDIR Summary of this function goes here
%   Detailed explanation goes here
if ~exist(folder, 'dir')
    mkdir(folder);
end

end
