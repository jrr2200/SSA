function [T, SF, sem] = survivalFunction(numFrames,exptime,count)

% SURVIVIALFUNCTION finds the survival function (complement of the
% cumulative distribution) for the residence time information.
% 
% INPUT:
%   - OBJ - FSMIA object.
%   - EXPTIME - exposure time of each frame + interval time between frames
%   - COUNT - output of RESIDENCETIMESTAT.
% OUTPUT:
%   - T - time vector used to create survival function.
%   - SF - survival function. SF(t) = P(t >= T(t)) with correction for
%   finite video length.

% Frame = obj.Frame;
% numFrames = length(Frame);
maxT = exptime*(numFrames);
deltaT = exptime;
% count = count(1:end-1)';
T = deltaT:deltaT:maxT;

c = 1./((heaviside(maxT-[0,T]).*(1-([0,T]/maxT)))).^2;
% c = [1,ones(1,length(T))];
c = c(1:end-1);
if length(c) ~= length(count)
    n = padarray(count,[0 abs(length(c) - length(count))],0,'post');
    SF = abs(1-cumsum(n.*c/sum(n.*c)));
    %sem = 0.68.*SF;%n.*c/sum(n.*c);
    sem = sqrt(SF);
else
    SF = abs(1-cumsum(count.*c/sum(count.*c)));
    %sem = 0.68.*SF;%count.*c/sum(count.*c);
    sem = sqrt(SF);
end
end