function [th,m_fmeasure] = th_opt_hillclimb(original, forgery, correlation,startpoint)

    [~,~,~,N] = size(original);
    
    temp_max_sum_fmeasure = 0;
    temp_th = startpoint;
    best_th = temp_th;
    
    while temp_th <= 1
        
        temp_sum_fmeasure = 0;
    
        for i=1:N
            classification = correlation(:,:,i) < temp_th;
            temp_sum_fmeasure = temp_sum_fmeasure + f_measure(original(:,:,:,i),forgery(:,:,:,i),classification);
        end
        
        if temp_sum_fmeasure >= temp_max_sum_fmeasure
            best_th = temp_th;
            temp_max_sum_fmeasure = temp_sum_fmeasure;
            temp_th = temp_th+0.001;
        else
            break;
        end
    end
    
    th = best_th;
    m_fmeasure = temp_max_sum_fmeasure/N;
end

