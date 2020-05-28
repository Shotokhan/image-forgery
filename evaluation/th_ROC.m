function [th,m_fmeasure] = th_ROC(original, forgery, correlation, startpoint, step)

    [~,~,~,N] = size(original);
    
    temp_max_sum_fmeasure = 0;
    temp_th = startpoint;
    best_th = temp_th;
    space_x = startpoint:step:1;
    space_y = zeros(size(space_x));
    j = 1;
    
    while temp_th <= 1
        
        temp_sum_fmeasure = 0;
    
        for i=1:N
            classification = correlation(:,:,i) < temp_th;
            temp_sum_fmeasure = temp_sum_fmeasure + f_measure(original(:,:,:,i),forgery(:,:,:,i),classification);
        end
        
        space_y(j) = temp_sum_fmeasure / N;
        
        if temp_sum_fmeasure >= temp_max_sum_fmeasure
            best_th = temp_th;
            temp_max_sum_fmeasure = temp_sum_fmeasure;
        end
        temp_th = temp_th+step;
        j = j + 1;
    end
    
    figure();
    plot(space_x, space_y);
    
    th = best_th;
    m_fmeasure = temp_max_sum_fmeasure/N;
end


