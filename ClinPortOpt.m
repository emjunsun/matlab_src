classdef ClinPortOpt
    
    % Clinder cavity Ports Optimise.
    %
    
    properties
        % clinder radius, unit is mm
        clinR = 100;
        % clinder height, unit is mm
        clinH = 200;
        
        
    end
    
    methods
        function self = ClinPortOpt(clinR, clinH)
            self.clinR = clinR;
            self.clinH = clinH;
        end
        
        function mainCompute(self, num)
            self.clinR + 100*num
        end
        
    end
    
    methods (Static)
        
        
        function result_n = Fresult_name()
            date_var = date;
            result_n = ['result-',date_var];
            clock_tmp = clock;
            clock_h = num2str(clock_tmp(4));
            clock_m = num2str(clock_tmp(5));
            result_n = ['result/',result_n,'-',clock_h,'-',clock_m];
        end
        
        function out = TestSj(test1, test2)
            %             disp(test);
            out = test1+ test2;
        end
        
    end
    
end

