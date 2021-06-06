function log_msg = get_timeleft(p_current, p_end, t1, t2)
% Estimate time left for the calculation

time_cost=etime(t2, t1);
time_left=time_cost/(p_current-1)*(p_end-p_current+1);
if time_left>3600
    log_msg = sprintf('%f hours',time_left/3600);
elseif time_left>60
    log_msg = sprintf('%f mininuts',time_left/60);
else
    log_msg = sprintf('%f seconds',time_left);
end

end
