classdef ClinPortOpt < handle
    
    % Clinder cavity Ports Optimise.
    %
    
    properties
        % clinder radius, unit is mm
        clinR = 100;
        % clinder height, unit is mm
        clinH = 200;
        
        
        
        % results file name
        result_n;
        % COMSOL model
        model;
    end
    
    methods
        function self = ClinPortOpt()

            self.Fresult_name();
            self.buildModel();
            
        end
        
        function mainCompute(self)
%             model = self.comsolModel;
            self.TestSj(23,21)
            self.model.geom('geom1').run('blk1');
%             self.comsolModel = model;
            
        end
        
        function out = TestSj(~, test1, test2)
            %             disp(test);
            out = test1+ test2;
        end
        
        function Fresult_name(self)
            date_var = date;
            result_n_tmp = ['result-',date_var];
            clock_tmp = clock;
            clock_h = num2str(clock_tmp(4));
            clock_m = num2str(clock_tmp(5));
            self.result_n = ['result/',result_n_tmp,'-',clock_h,'-',clock_m];
        end
        
        function buildModel(self)
            import com.comsol.model.*
            import com.comsol.model.util.*
            
            self.model = ModelUtil.create('Model');
            
            self.model.modelPath('/media/sda6/opt/micro_opt/matlab_src/temp');
            
            self.model.modelNode.create('mod1');
            
            self.model.geom.create('geom1', 3);
            
            self.model.mesh.create('mesh1', 'geom1');
            
            self.model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
            
            self.model.study.create('std1');
            self.model.study('std1').feature.create('freq', 'Frequency');
            self.model.study('std1').feature('freq').activate('emw', true);
            
            self.model.geom('geom1').feature.create('cyl1', 'Cylinder');
            self.model.geom('geom1').run;
            self.model.geom('geom1').lengthUnit('mm');
            self.model.geom('geom1').feature('cyl1').set('r', '300');
            self.model.geom('geom1').feature('cyl1').set('h', '1000');
            self.model.geom('geom1').run('cyl1');
            
            self.model.param.set('port_l', '86.36');
            self.model.param.set('port_w', '43.18');
            
            self.model.geom('geom1').run('cyl1');
            self.model.geom('geom1').feature.create('blk1', 'Block');
            self.model.geom('geom1').feature('blk1').set('base', 'center');
            self.model.geom('geom1').feature('blk1').set('axistype', 'z');
            self.model.geom('geom1').feature('blk1').setIndex('size', '40', 2);
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 0);
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 1);
            self.model.geom('geom1').feature('blk1').setIndex('size', '1', 2);
            self.model.geom('geom1').run('blk1');
            
            self.model.view('view1').set('transparency', 'on');
            self.model.view('view1').set('renderwireframe', true);
            
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 2);
            self.model.geom('geom1').feature('blk1').setIndex('size', '1', 1);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('pos', '300', 0);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 1);
            self.model.geom('geom1').feature('blk1').setIndex('size', '1', 0);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_wport_l', 2);
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 2);
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 1);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 2);
            self.model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 1);
            self.model.geom('geom1').run('blk1');
            
            self.model.view('view1').set('renderwireframe', false);
            
            self.model.geom('geom1').feature('blk1').setIndex('size', '40', 0);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('pos', '1.8370e-14', 0);
            self.model.geom('geom1').feature('blk1').setIndex('pos', '300', 1);
            self.model.geom('geom1').run('blk1');
            
            self.model.view('view1').set('renderwireframe', true);
            self.model.view('view1').set('transparency', 'off');
            
            self.model.geom('geom1').feature('blk1').set('rot', '90');
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('pos', '-5.5109e-14', 0);
            self.model.geom('geom1').feature('blk1').setIndex('pos', '-300', 1);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').set('rot', '270');
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').setIndex('pos', '-5.5109e-14', 1);
            self.model.geom('geom1').feature('blk1').setIndex('pos', '-300', 0);
            self.model.geom('geom1').run('blk1');
            self.model.geom('geom1').feature('blk1').set('rot', '180');
            self.model.geom('geom1').run('blk1');

        end
    end
    
end

