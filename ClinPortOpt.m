classdef ClinPortOpt < handle
    
    % Clinder cavity Ports Optimise.
    %
    
    properties
        % clinder radius, unit is mm
        clinR;
        % clinder height, unit is mm
        clinH;
        
        % port size in cross section,unit is mm
        portA;
        portB;
        % port length
        portL;
        
        % determine ports location for port No.1 and No.2
        % degree in oC
        degree1;
        degree2;
        % height of ports (center point), unit is mm
        h1;
        h2;
        % port orthogonality flag, 0 for no, 1 for yes
        orthFlag1;
        orthFlag2;
        
        
        % results file name
        result_n;
        % COMSOL model
        model;
        
        % GA parameter
        GAPara;
    end
    
    methods
        function self = ClinPortOpt()
            
            self.Fresult_name();
            self.buildModel();
            self.setGAPara();
            
        end
        
        function mainCompute(self)
            
            %             Ret = self.Code(self.GAPara.LenChrom,self.GAPara.CodeFcn,self.GAPara.Bound)
            %             self.Decode(self.GAPara.LenChrom,self.GAPara.Bound,Ret,self.GAPara.CodeFcn)
            self.model.param.set('z1', '-200');
            self.model.param.set('z2', '-250');
            self.model.geom('geom1').run;
            self.model.sol('sol1').runAll;
        end
        
        
        
        function Fresult_name(self)
            date_var = date;
            result_n_tmp = ['result-',date_var];
            clock_tmp = clock;
            clock_h = num2str(clock_tmp(4));
            clock_m = num2str(clock_tmp(5));
            self.result_n = ['result/',result_n_tmp,'-',clock_h,'-',clock_m];
        end
        
        function setGAPara(self)
            port_ort_bnd = [0 2];
            port_cen_bnd = [self.portB/2 self.clinH-self.portB/2];
            port_degree_bnd = [0 360];
            
            self.GAPara.MaxGen   =20;         % maximum generation
            
            self.GAPara.SizePop  =20;         % size of population
            
            self.GAPara.StrAimFcn='aimOptPorts';    % this is function of counting fitness
            
            self.GAPara.CodeFcn  ='binary';    % method of coding, you can choose 'float';'grey';'binary'
            
            self.GAPara.SelectFcn='roulette'; % method of select  you can choose 'tournament';'roulette'
            
            self.GAPara.CrossFcn ='uniform';   % method of crossover, 'simple' and 'uniform'
            
            self.GAPara.PCross   =[0.75];       % probablity of crossover,between 0 and 1
            
            self.GAPara.MutationFcn='simple';  % method of mutation
            
            self.GAPara.PMutation=[0.01];      % probability of mutation,between 0 and 1
            
            %GAPara.LenChrom =[1];     % length of bit of every varible, for float code is 1
            self.GAPara.LenChrom = [3 7 7];
            self.GAPara.LenChrom = [self.GAPara.LenChrom self.GAPara.LenChrom];
            
            %GAPara.Bound    =[lb ub]; % bounary of every variable
            self.GAPara.Bound    =[port_ort_bnd; port_cen_bnd; port_degree_bnd];
            self.GAPara.Bound = [self.GAPara.Bound; self.GAPara.Bound];
            
        end
        
        function aimOptPorts(self)
            
        end
        
        function radian = degree2Radian(self,degree)
            radian = degree/180 * pi
            [x, y] = pol2cart(radian, self.clinR)
        end
        
        function buildModel(self)
            import com.comsol.model.*
            import com.comsol.model.util.*
            
            self.model = ModelUtil.create('Model');
            
            ModelUtil.showProgress(true);
            self.model.hist.disable            
            
            self.model.param.set('clinR', '200');
            self.model.param.set('clinH', '790');
            self.model.param.set('portA', '96');
            self.model.param.set('portB', '55');
            self.model.param.set('portL', '70');
            self.model.param.set('theta1', '90');
            self.model.param.set('theta2', '30');
            self.model.param.set('z1', '50');
            self.model.param.set('z2', '200');
            self.model.param.set('water_mat', '65-20*j');
            self.model.param.set('mist_mat', '5-5*j');
            
            self.model.modelNode.create('mod1');
            
            self.model.geom.create('geom1', 3);
            self.model.geom('geom1').lengthUnit('mm');
            self.model.geom('geom1').feature.create('cyl1', 'Cylinder');
            self.model.geom('geom1').feature.create('sph1', 'Sphere');
            self.model.geom('geom1').feature.create('cyl2', 'Cylinder');
            self.model.geom('geom1').feature.create('int1', 'Intersection');
            self.model.geom('geom1').feature.create('mir1', 'Mirror');
            self.model.geom('geom1').feature.create('cyl3', 'Cylinder');
            self.model.geom('geom1').feature.create('cone1', 'Cone');
            self.model.geom('geom1').feature.create('rev1', 'Revolve');
            self.model.geom('geom1').feature.create('ext1', 'Extrude');
            self.model.geom('geom1').feature.create('uni1', 'Union');
            self.model.geom('geom1').feature.create('cyl4', 'Cylinder');
            self.model.geom('geom1').feature.create('cyl5', 'Cylinder');
            self.model.geom('geom1').feature.create('rot1', 'Rotate');
            self.model.geom('geom1').feature.create('cyl6', 'Cylinder');
            self.model.geom('geom1').feature.create('cone2', 'Cone');
            self.model.geom('geom1').feature.create('dif1', 'Difference');
            self.model.geom('geom1').feature.create('del2', 'Delete');
            self.model.geom('geom1').feature.create('uni3', 'Union');
            self.model.geom('geom1').feature.create('int2', 'Intersection');
            self.model.geom('geom1').feature.create('del1', 'Delete');
            self.model.geom('geom1').feature.create('blk1', 'Block');
            self.model.geom('geom1').feature.create('blk2', 'Block');
            self.model.geom('geom1').feature.create('uni2', 'Union');
            self.model.geom('geom1').feature.create('blk3', 'Block');
            self.model.geom('geom1').feature.create('blk4', 'Block');
            self.model.geom('geom1').feature('cyl1').set('pos', {'0' '0' '-clinH/2'});
            self.model.geom('geom1').feature('cyl1').set('h', 'clinH');
            self.model.geom('geom1').feature('cyl1').set('r', 'clinR');
            self.model.geom('geom1').feature('sph1').set('r', '250');
            self.model.geom('geom1').feature('sph1').set('pos', {'0' '0' 'clinH/2-150'});
            self.model.geom('geom1').feature('cyl2').set('pos', {'0' '0' 'clinH/2'});
            self.model.geom('geom1').feature('cyl2').set('h', 'clinH/2');
            self.model.geom('geom1').feature('cyl2').set('r', 'clinR');
            self.model.geom('geom1').feature('int1').set('face', 'all');
            self.model.geom('geom1').feature('int1').set('intbnd', false);
            self.model.geom('geom1').feature('int1').selection('input').set({'cyl2' 'sph1'});
            self.model.geom('geom1').feature('mir1').set('keep', true);
            self.model.geom('geom1').feature('mir1').selection('input').set({'int1'});
            self.model.geom('geom1').feature('cyl3').set('h', '38.57');
            self.model.geom('geom1').feature('cyl3').set('r', '14.05/2');
            self.model.geom('geom1').feature('cone1').set('pos', {'0' '0' '38.57'});
            self.model.geom('geom1').feature('cone1').set('h', '15.026');
            self.model.geom('geom1').feature('cone1').set('rtop', '25/2');
            self.model.geom('geom1').feature('cone1').set('r', '14.05/2');
            self.model.geom('geom1').feature('cone1').set('specifytop', 'radius');
            self.model.geom('geom1').feature('rev1').set('angle2', '90');
            self.model.geom('geom1').feature('rev1').set('polres', '100');
            self.model.geom('geom1').feature('rev1').set('axis3', {'0' '-1' '0'});
            self.model.geom('geom1').feature('rev1').set('axistype', '3d');
            self.model.geom('geom1').feature('rev1').set('pos3', {'-38' '0' '15.026+38.57'});
            self.model.geom('geom1').feature('rev1').selection('inputface').set('cone1(1)', [3]);
            self.model.geom('geom1').feature('ext1').setIndex('distance', '175', 0);
            self.model.geom('geom1').feature('ext1').selection('inputface').set('rev1(1)', [1]);
            self.model.geom('geom1').feature('uni1').set('face', 'all');
            self.model.geom('geom1').feature('uni1').set('intbnd', false);
            self.model.geom('geom1').feature('uni1').selection('input').set({'cyl3' 'ext1'});
            self.model.geom('geom1').feature('cyl4').set('pos', {'0' '0' '500-15'});
            self.model.geom('geom1').feature('cyl4').set('h', '30');
            self.model.geom('geom1').feature('cyl4').set('r', '20/2');
            self.model.geom('geom1').feature('cyl5').set('axis', {'0' '0' '1'});
            self.model.geom('geom1').feature('cyl5').set('pos', {'-clinR/2' '0' 'clinH/2+100/2+10'});
            self.model.geom('geom1').feature('cyl5').set('h', '40');
            self.model.geom('geom1').feature('cyl5').set('r', '8/2');
            self.model.geom('geom1').feature('rot1').set('pos', {'-clinR/2' '0' 'clinH/2+100/2+10+20'});
            self.model.geom('geom1').feature('rot1').set('axis', {'0' '1' '0'});
            self.model.geom('geom1').feature('rot1').set('rot', '-33');
            self.model.geom('geom1').feature('rot1').selection('input').set({'cyl5'});
            self.model.geom('geom1').feature('cyl6').set('pos', {'0' '0' '-500-15'});
            self.model.geom('geom1').feature('cyl6').set('h', '30');
            self.model.geom('geom1').feature('cyl6').set('r', '104/2');
            self.model.geom('geom1').feature('cone2').set('pos', {'0' '0' '-500-15'});
            self.model.geom('geom1').feature('cone2').set('h', '500+15');
            self.model.geom('geom1').feature('cone2').set('rtop', '0');
            self.model.geom('geom1').feature('cone2').set('r', '600');
            self.model.geom('geom1').feature('cone2').set('specifytop', 'radius');
            self.model.geom('geom1').feature('dif1').set('face', 'all');
            self.model.geom('geom1').feature('dif1').set('intbnd', false);
            self.model.geom('geom1').feature('dif1').set('keep', true);
            self.model.geom('geom1').feature('dif1').selection('input').set({'cyl4'});
            self.model.geom('geom1').feature('dif1').selection('input2').set({'int1'});
            self.model.geom('geom1').feature('del2').selection('input').init;
            self.model.geom('geom1').feature('del2').selection('input').set({'cyl4'});
            self.model.geom('geom1').feature('uni3').set('face', 'all');
            self.model.geom('geom1').feature('uni3').set('intbnd', false);
            self.model.geom('geom1').feature('uni3').selection('input').set({'cyl1' 'cyl6' 'int1' 'mir1'});
            self.model.geom('geom1').feature('int2').set('face', 'all');
            self.model.geom('geom1').feature('int2').set('intbnd', false);
            self.model.geom('geom1').feature('int2').set('keep', true);
            self.model.geom('geom1').feature('int2').selection('input').set({'cone2' 'uni3'});
            self.model.geom('geom1').feature('del1').selection('input').init;
            self.model.geom('geom1').feature('del1').selection('input').set({'cone2'});
            self.model.geom('geom1').feature('blk1').set('size', {'portL' 'portA' 'portB'});
            self.model.geom('geom1').feature('blk1').set('base', 'center');
            self.model.geom('geom1').feature('blk1').set('pos', {'clinR*cos(theta1/180*pi)' 'clinR*sin(theta1/180*pi)' 'z1'});
            self.model.geom('geom1').feature('blk1').set('rot', 'theta1');
            self.model.geom('geom1').feature('blk2').set('size', {'portL' 'portA' 'portB'});
            self.model.geom('geom1').feature('blk2').set('base', 'center');
            self.model.geom('geom1').feature('blk2').set('pos', {'clinR*cos(theta2/180*pi)' 'clinR*sin(theta2/180*pi)' 'z2'});
            self.model.geom('geom1').feature('blk2').set('rot', 'theta2');
            self.model.geom('geom1').feature('uni2').set('face', 'all');
            self.model.geom('geom1').feature('uni2').set('intbnd', false);
            self.model.geom('geom1').feature('uni2').selection('input').set({'blk1' 'blk2' 'uni3'});
            self.model.geom('geom1').feature('blk3').set('size', {'15' 'portA' 'portB'});
            self.model.geom('geom1').feature('blk3').set('base', 'center');
            self.model.geom('geom1').feature('blk3').set('pos', {'(clinR+22-10)*cos(theta1/180*pi)' '(clinR+22-10)*sin(theta1/180*pi)' 'z1'});
            self.model.geom('geom1').feature('blk3').set('rot', 'theta1');
            self.model.geom('geom1').feature('blk4').set('size', {'15' 'portA' 'portB'});
            self.model.geom('geom1').feature('blk4').set('base', 'center');
            self.model.geom('geom1').feature('blk4').set('pos', {'(clinR+22-10)*cos(theta2/180*pi)' '(clinR+22-10)*sin(theta2/180*pi)' 'z2'});
            self.model.geom('geom1').feature('blk4').set('rot', 'theta2');
            self.model.geom('geom1').run;
            
            self.model.selection.create('sel1', 'Explicit');
            self.model.selection('sel1').geom('geom1', 2);
            self.model.selection('sel1').set([48]);
            self.model.selection.create('sel2', 'Explicit');
            self.model.selection('sel2').geom('geom1', 2);
            self.model.selection('sel2').set([97]);
            self.model.selection('sel1').name('port1');
            self.model.selection('sel1').name('Explicit 1');
            self.model.selection('sel2').name('port2');
            self.model.selection('sel2').name('Explicit 2');
            
            self.model.material.create('mat1');
            self.model.material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
            self.model.material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
            self.model.material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
            self.model.material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
            self.model.material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
            self.model.material.create('mat2');
            self.model.material('mat2').propertyGroup('def').func.create('eta', 'Piecewise');
            self.model.material('mat2').propertyGroup('def').func.create('Cp', 'Piecewise');
            self.model.material('mat2').propertyGroup('def').func.create('rho', 'Piecewise');
            self.model.material('mat2').propertyGroup('def').func.create('k', 'Piecewise');
            self.model.material('mat2').propertyGroup('def').func.create('cs', 'Interpolation');
            self.model.material('mat2').selection.set([1 4]);
            self.model.material.create('mat3');
            self.model.material('mat3').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
            self.model.material('mat3').propertyGroup.create('RefractiveIndex', 'Refractive index');
            self.model.material('mat3').selection.set([7 10]);
            self.model.material.create('mat4');
            self.model.material('mat4').propertyGroup('def').func.create('eta', 'Piecewise');
            self.model.material('mat4').propertyGroup('def').func.create('Cp', 'Piecewise');
            self.model.material('mat4').propertyGroup('def').func.create('rho', 'Piecewise');
            self.model.material('mat4').propertyGroup('def').func.create('k', 'Piecewise');
            self.model.material('mat4').propertyGroup('def').func.create('cs', 'Interpolation');
            self.model.material('mat4').selection.set([2]);
            
            self.model.physics.create('emw', 'ElectromagneticWaves', 'geom1');
            self.model.physics('emw').feature.create('port1', 'Port', 2);
            self.model.physics('emw').feature('port1').selection.named('sel1');
            self.model.physics('emw').feature.create('port2', 'Port', 2);
            self.model.physics('emw').feature('port2').selection.named('sel2');
            self.model.physics('emw').feature.create('pec2', 'PerfectElectricConductor', 2);
            self.model.physics('emw').feature('pec2').selection.set([16 17 18 19 28 30 31 32 49 50 51 52 53 54 60 61 69 72 75 76]);
            self.model.physics('emw').feature.create('sctr1', 'Scattering', 2);
            self.model.physics('emw').feature('sctr1').selection.set([1 22 36 59]);
            
            self.model.mesh.create('mesh1', 'geom1');
            self.model.mesh('mesh1').feature.create('ftet1', 'FreeTet');
            self.model.mesh('mesh1').feature.create('ftet2', 'FreeTet');
            self.model.mesh('mesh1').feature.create('ftet3', 'FreeTet');
            self.model.mesh('mesh1').feature.create('ftet4', 'FreeTet');
            self.model.mesh('mesh1').feature('ftet1').selection.geom('geom1', 3);
            self.model.mesh('mesh1').feature('ftet1').selection.set([2]);
            self.model.mesh('mesh1').feature('ftet1').feature.create('size1', 'Size');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').selection.geom('geom1');
            self.model.mesh('mesh1').feature('ftet2').selection.geom('geom1', 3);
            self.model.mesh('mesh1').feature('ftet2').selection.set([1 4 5 6 9]);
            self.model.mesh('mesh1').feature('ftet2').feature.create('size1', 'Size');
            self.model.mesh('mesh1').feature('ftet2').feature('size1').selection.geom('geom1');
            self.model.mesh('mesh1').feature('ftet3').selection.geom('geom1', 3);
            self.model.mesh('mesh1').feature('ftet3').selection.set([7 10]);
            self.model.mesh('mesh1').feature('ftet3').feature.create('size1', 'Size');
            self.model.mesh('mesh1').feature('ftet3').feature('size1').selection.geom('geom1');
            
            self.model.view('view1').set('transparency', 'on');
            
            self.model.material('mat1').name('Air');
            self.model.material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
            self.model.material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
            self.model.material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
            self.model.material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
            self.model.material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
            self.model.material('mat1').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
            self.model.material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
            self.model.material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
            self.model.material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
            self.model.material('mat1').propertyGroup('def').func('k').set('arg', 'T');
            self.model.material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
            self.model.material('mat1').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
            self.model.material('mat1').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
            self.model.material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
            self.model.material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
            self.model.material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
            self.model.material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
            self.model.material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
            self.model.material('mat1').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
            self.model.material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
            self.model.material('mat1').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
            self.model.material('mat1').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
            self.model.material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
            self.model.material('mat1').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
            self.model.material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
            self.model.material('mat1').propertyGroup('def').addInput('temperature');
            self.model.material('mat1').propertyGroup('def').addInput('pressure');
            self.model.material('mat2').name('Water_mat');
            self.model.material('mat2').propertyGroup('def').func('eta').set('arg', 'T');
            self.model.material('mat2').propertyGroup('def').func('eta').set('pieces', {'273.15' '413.15' '1.3799566804-0.021224019151*T^1+1.3604562827E-4*T^2-4.6454090319E-7*T^3+8.9042735735E-10*T^4-9.0790692686E-13*T^5+3.8457331488E-16*T^6'; '413.15' '553.75' '0.00401235783-2.10746715E-5*T^1+3.85772275E-8*T^2-2.39730284E-11*T^3'});
            self.model.material('mat2').propertyGroup('def').func('Cp').set('arg', 'T');
            self.model.material('mat2').propertyGroup('def').func('Cp').set('pieces', {'273.15' '553.75' '12010.1471-80.4072879*T^1+0.309866854*T^2-5.38186884E-4*T^3+3.62536437E-7*T^4'});
            self.model.material('mat2').propertyGroup('def').func('rho').set('arg', 'T');
            self.model.material('mat2').propertyGroup('def').func('rho').set('pieces', {'273.15' '553.75' '838.466135+1.40050603*T^1-0.0030112376*T^2+3.71822313E-7*T^3'});
            self.model.material('mat2').propertyGroup('def').func('k').set('arg', 'T');
            self.model.material('mat2').propertyGroup('def').func('k').set('pieces', {'273.15' '553.75' '-0.869083936+0.00894880345*T^1-1.58366345E-5*T^2+7.97543259E-9*T^3'});
            self.model.material('mat2').propertyGroup('def').func('cs').set('table', {'273' '1403'; '278' '1427'; '283' '1447'; '293' '1481'; '303' '1507'; '313' '1526'; '323' '1541'; '333' '1552'; '343' '1555'; '353' '1555';  ...
                '363' '1550'; '373' '1543'});
            self.model.material('mat2').propertyGroup('def').func('cs').set('interp', 'piecewisecubic');
            self.model.material('mat2').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
            self.model.material('mat2').propertyGroup('def').set('ratioofspecificheat', '1.0');
            self.model.material('mat2').propertyGroup('def').set('electricconductivity', {'5.5e-6[S/m]' '0' '0' '0' '5.5e-6[S/m]' '0' '0' '0' '5.5e-6[S/m]'});
            self.model.material('mat2').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
            self.model.material('mat2').propertyGroup('def').set('density', 'rho(T[1/K])[kg/m^3]');
            self.model.material('mat2').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
            self.model.material('mat2').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
            self.model.material('mat2').propertyGroup('def').set('relpermittivity', {'water_mat' '0' '0' '0' 'water_mat' '0' '0' '0' 'water_mat'});
            self.model.material('mat2').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
            self.model.material('mat2').propertyGroup('def').addInput('temperature');
            self.model.material('mat3').name('Silica glass');
            self.model.material('mat3').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
            self.model.material('mat3').propertyGroup('def').set('electricconductivity', {'1e-14[S/m]' '0' '0' '0' '1e-14[S/m]' '0' '0' '0' '1e-14[S/m]'});
            self.model.material('mat3').propertyGroup('def').set('thermalexpansioncoefficient', {'0.55e-6[1/K]' '0' '0' '0' '0.55e-6[1/K]' '0' '0' '0' '0.55e-6[1/K]'});
            self.model.material('mat3').propertyGroup('def').set('heatcapacity', '703[J/(kg*K)]');
            self.model.material('mat3').propertyGroup('def').set('relpermittivity', {'2.09' '0' '0' '0' '2.09' '0' '0' '0' '2.09'});
            self.model.material('mat3').propertyGroup('def').set('density', '2203[kg/m^3]');
            self.model.material('mat3').propertyGroup('def').set('thermalconductivity', {'1.38[W/(m*K)]' '0' '0' '0' '1.38[W/(m*K)]' '0' '0' '0' '1.38[W/(m*K)]'});
            self.model.material('mat3').propertyGroup('Enu').set('youngsmodulus', '73.1e9[Pa]');
            self.model.material('mat3').propertyGroup('Enu').set('poissonsratio', '0.17');
            self.model.material('mat3').propertyGroup('RefractiveIndex').set('n', '');
            self.model.material('mat3').propertyGroup('RefractiveIndex').set('ki', '');
            self.model.material('mat3').propertyGroup('RefractiveIndex').set('n', {'1.45' '0' '0' '0' '1.45' '0' '0' '0' '1.45'});
            self.model.material('mat3').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
            self.model.material('mat4').name('Mist_mat');
            self.model.material('mat4').propertyGroup('def').func('eta').set('arg', 'T');
            self.model.material('mat4').propertyGroup('def').func('eta').set('pieces', {'273.15' '413.15' '1.3799566804-0.021224019151*T^1+1.3604562827E-4*T^2-4.6454090319E-7*T^3+8.9042735735E-10*T^4-9.0790692686E-13*T^5+3.8457331488E-16*T^6'; '413.15' '553.75' '0.00401235783-2.10746715E-5*T^1+3.85772275E-8*T^2-2.39730284E-11*T^3'});
            self.model.material('mat4').propertyGroup('def').func('Cp').set('arg', 'T');
            self.model.material('mat4').propertyGroup('def').func('Cp').set('pieces', {'273.15' '553.75' '12010.1471-80.4072879*T^1+0.309866854*T^2-5.38186884E-4*T^3+3.62536437E-7*T^4'});
            self.model.material('mat4').propertyGroup('def').func('rho').set('arg', 'T');
            self.model.material('mat4').propertyGroup('def').func('rho').set('pieces', {'273.15' '553.75' '838.466135+1.40050603*T^1-0.0030112376*T^2+3.71822313E-7*T^3'});
            self.model.material('mat4').propertyGroup('def').func('k').set('arg', 'T');
            self.model.material('mat4').propertyGroup('def').func('k').set('pieces', {'273.15' '553.75' '-0.869083936+0.00894880345*T^1-1.58366345E-5*T^2+7.97543259E-9*T^3'});
            self.model.material('mat4').propertyGroup('def').func('cs').set('table', {'273' '1403'; '278' '1427'; '283' '1447'; '293' '1481'; '303' '1507'; '313' '1526'; '323' '1541'; '333' '1552'; '343' '1555'; '353' '1555';  ...
                '363' '1550'; '373' '1543'});
            self.model.material('mat4').propertyGroup('def').func('cs').set('interp', 'piecewisecubic');
            self.model.material('mat4').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
            self.model.material('mat4').propertyGroup('def').set('ratioofspecificheat', '1.0');
            self.model.material('mat4').propertyGroup('def').set('electricconductivity', {'5.5e-6[S/m]' '0' '0' '0' '5.5e-6[S/m]' '0' '0' '0' '5.5e-6[S/m]'});
            self.model.material('mat4').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
            self.model.material('mat4').propertyGroup('def').set('density', 'rho(T[1/K])[kg/m^3]');
            self.model.material('mat4').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
            self.model.material('mat4').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
            self.model.material('mat4').propertyGroup('def').set('relpermittivity', {'mist_mat' '0' '0' '0' 'mist_mat' '0' '0' '0' 'mist_mat'});
            self.model.material('mat4').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
            self.model.material('mat4').propertyGroup('def').addInput('temperature');
            
            self.model.physics('emw').feature('port1').set('PortExcitation', 'on');
            self.model.physics('emw').feature('port1').set('Pin', '500');
            self.model.physics('emw').feature('port1').set('PortType', 'Rectangular');
            self.model.physics('emw').feature('port2').set('PortExcitation', 'on');
            self.model.physics('emw').feature('port2').set('Pin', '500');
            self.model.physics('emw').feature('port2').set('PortType', 'Rectangular');
            
            self.model.mesh('mesh1').feature('size').set('hauto', 1);
            self.model.mesh('mesh1').feature('size').set('custom', 'on');
            self.model.mesh('mesh1').feature('size').set('hmax', '24');
            self.model.mesh('mesh1').feature('ftet1').name('mist');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', 3);
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('custom', 'on');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hnarrow', '0.9');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('table', 'cfd');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hmaxactive', true);
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hmin', '1.75');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hgrad', '1.1');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hmax', '17');
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hgradactive', false);
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hcurveactive', false);
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hnarrowactive', false);
            self.model.mesh('mesh1').feature('ftet1').feature('size1').set('hminactive', false);
            self.model.mesh('mesh1').feature('ftet2').name('tube');
            self.model.mesh('mesh1').feature('ftet2').feature('size1').set('hauto', 3);
            self.model.mesh('mesh1').feature('ftet3').name('silica');
            self.model.mesh('mesh1').feature('ftet3').feature('size1').set('hauto', 1);
            self.model.mesh('mesh1').feature('ftet3').feature('size1').set('custom', 'on');
            self.model.mesh('mesh1').feature('ftet3').feature('size1').set('hmaxactive', true);
            self.model.mesh('mesh1').feature('ftet3').feature('size1').set('hmax', '22');
            self.model.mesh('mesh1').run;
            
            self.model.study.create('std1');
            self.model.study('std1').feature.create('freq', 'Frequency');
            
            self.model.sol.create('sol1');
            self.model.sol('sol1').study('std1');
            self.model.sol('sol1').attach('std1');
            self.model.sol('sol1').feature.create('st1', 'StudyStep');
            self.model.sol('sol1').feature.create('v1', 'Variables');
            self.model.sol('sol1').feature.create('s1', 'Stationary');
            self.model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
            self.model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
            self.model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
            self.model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
            self.model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
            self.model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
            self.model.sol('sol1').feature('s1').feature.remove('fcDef');
            
            self.model.study('std1').feature('freq').set('initstudyhide', 'on');
            self.model.study('std1').feature('freq').set('initsolhide', 'on');
            self.model.study('std1').feature('freq').set('notstudyhide', 'on');
            self.model.study('std1').feature('freq').set('notsolhide', 'on');
            
            self.model.study('std1').feature('freq').set('plist', '2.45[GHz]');
            
            self.model.sol('sol1').attach('std1');
            self.model.sol('sol1').feature('st1').name('Compile Equations: Frequency Domain {freq}');
            self.model.sol('sol1').feature('st1').set('studystep', 'freq');
            self.model.sol('sol1').feature('v1').set('control', 'freq');
            self.model.sol('sol1').feature('s1').set('control', 'freq');
            self.model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
            self.model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
            self.model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'2.45[GHz]'});
            self.model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
            self.model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'mod1_E'});
            self.model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'mod1_E'});
            
        end
    end
    
    methods
        % for GA
        function Ret=Code(~, LenChrom,Opts,Bound)
            % In this function ,it converts a set varibles into a chromosome
            % LenChrom   input : length of chromosome
            % Opts       input : tag of coding method
            % Bound      input : boundary of varibles
            % Ret        output: chromosome
            switch Opts
                case 'binary' % binary coding
                    Pick=rand(1,sum(LenChrom));
                    Bits=ceil(Pick-0.5);
                    Temp=sum(LenChrom)-1:-1:0;
                    Ret=sum(Bits.*(2.^Temp));
                case 'grey'   % grey coding
                    Pick=rand(1,sum(LenChrom));
                    Bits=ceil(Pick-0.5);
                    GreyBits=Bits;
                    for i=2:length(GreyBits)
                        GreyBits(i)=bitxor(Bits(i-1),Bits(i));
                    end
                    Temp=sum(LenChrom)-1:-1:0;
                    Ret=sum(GreyBits.*(2.^Temp));
                case 'float'   % float coding
                    Pick=rand(1,length(LenChrom));
                    Ret=Bound(:,1)'+(Bound(:,2)-Bound(:,1))'.*Pick;
            end
        end
        
        function Ret=Decode(~, LenChrom,Bound,Code,Opts)
            % In this function ,it deCode chromosome
            % LenChrom   input : length of chromosome
            % Opts       input : tag of coding method
            % Bound      input : Boundary of varibles
            % Ret        output: value of varibles
            switch Opts
                case 'binary' % binary coding
                    for i=length(LenChrom):-1:1
                        data(i)=bitand(Code,2^LenChrom(i)-1);
                        Code=(Code-data(i))/(2^LenChrom(i));
                    end
                    Ret=Bound(:,1)'+data./(2.^LenChrom-1).*(Bound(:,2)-Bound(:,1))';
                case 'grey'   % grey coding
                    for i=sum(LenChrom):-1:2
                        Code=bitset(Code,i-1,bitxor(bitget(Code,i),bitget(Code,i-1)));
                    end
                    for i=length(LenChrom):-1:1
                        data(i)=bitand(Code,2^LenChrom(i)-1);
                        Code=(Code-data(i))/(2^LenChrom(i));
                    end
                    Ret=Bound(:,1)'+data./(2.^LenChrom-1).*(Bound(:,2)-Bound(:,1))';
                case 'float'  % float coding
                    Ret=Code;
            end
            
        end
        
        function Ret=Select(~, Individuals,SizePop,Opts)
            % In this function,it fulfils a selection among chromosomes
            % Individuals input  : set of Individuals
            % SizePop     input  : size of population
            % Opts        input  : tag for choosing method of selection
            % Ret         output : new set of Individuals
            switch Opts
                case 'roulette'  % roulette wheel model
                    Sumf=Individuals.Fitness./sum(Individuals.Fitness);
                    Index=[];
                    for i=1:SizePop
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        for i=1:SizePop
                            Pick=Pick-Sumf(i);
                            if Pick<0
                                Index=[Index i];
                                break;
                            end
                        end
                    end
                    Individuals.Chrom=Individuals.Chrom(Index,:);
                    Individuals.Fitness=Individuals.Fitness(Index);
                    Ret=Individuals;
                case 'tournament'  % tourment model
                    AllIndex=[];
                    for i=1:SizePop
                        Pick=rand(1,2);
                        while prod(Pick)==0
                            Pick=rand(1,2);
                        end
                        Index=ceil(Pick.*SizePop);
                        if Individuals.Fitness(Index(1))>=Individuals.Fitness(Index(2))
                            AllIndex=[AllIndex Index(1)];
                        else
                            AllIndex=[AllIndex Index(2)];
                        end
                    end
                    Individuals.Chrom=Individuals.Chrom(AllIndex,:);
                    Individuals.Fitness=Individuals.Fitness(AllIndex);
                    Ret=Individuals;
            end
        end
        
        function Ret=Cross(~, PCross,LenChrom,Individuals,SizePop,Opts,Pop)
            % In this function,it fulfils a crossover among Chromosomes
            % PCross    input  : probability of crossover
            % LenChrom  input  : Length of a Chromosome
            % Chrom     input  : set of Ret Chromosomes
            % SizePop   input  : size of population
            % Opts      input  : tag for choosing method of crossover
            % Pop       input  : current serial number of generation and maximum gemeration
            % Ret       output : new set of Chromosome
            switch Opts
                case 'simple'  % cross at single position
                    for i=1:SizePop
                        % select two children at random
                        Pick=rand(1,2);
                        Index=ceil(Pick.*SizePop);
                        while prod(Pick)==0 || Index(1)==Index(2)
                            Pick=rand(1,2);
                            Index=ceil(Pick.*SizePop);
                        end
                        % probability of crossover
                        Pick=rand;
                        if Pick>PCross
                            continue;
                        end
                        % random position of crossover
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Pos=ceil(Pick.*sum(LenChrom));
                        Tail1=bitand(Individuals.Chrom(Index(1)),2.^Pos-1);
                        Tail2=bitand(Individuals.Chrom(Index(2)),2.^Pos-1);
                        Individuals.Chrom(Index(1))=Individuals.Chrom(Index(1))-Tail1+Tail2;
                        Individuals.Chrom(Index(2))=Individuals.Chrom(Index(2))-Tail2+Tail1;
                    end
                    Ret=Individuals.Chrom;
                case 'uniform' % uniform cross
                    for i=1:SizePop
                        % select two children at random
                        Pick=rand(1,2);
                        while prod(Pick)==0
                            Pick=rand(1,2);
                        end
                        Index=ceil(Pick.*SizePop);
                        % random position of crossover
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        if Pick>PCross
                            continue;
                        end
                        % random position of crossover
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Mask=2^ceil(Pick*sum(LenChrom));
                        Chrom1=Individuals.Chrom(Index(1));
                        Chrom2=Individuals.Chrom(Index(2));
                        for j=1:sum(LenChrom)
                            v=bitget(Mask,j);  % from lower  to higher bit
                            if v==1
                                Chrom1=bitset(Chrom1,...
                                    j,bitget(Individuals.Chrom(Index(2)),j));
                                Chrom2=bitset(Chrom2,...
                                    j,bitget(Individuals.Chrom(Index(1)),j));
                            end
                        end
                        Individuals.Chrom(Index(1))=Chrom1;
                        Individuals.Chrom(Index(2))=Chrom2;
                    end
                    Ret=Individuals.Chrom;
                case 'float'
                    for i=1:SizePop
                        % select two children at random
                        Pick=rand(1,2);
                        while prod(Pick)==0
                            Pick=rand(1,2);
                        end
                        Index=ceil(Pick.*SizePop);
                        % random position of crossover
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        if Pick>PCross
                            continue;
                        end
                        % random position of crossover
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Pos=ceil(Pick.*sum(LenChrom));
                        Pick=rand;
                        V1=Individuals.Chrom(Index(1),Pos);
                        V2=Individuals.Chrom(Index(2),Pos);
                        Individuals.Chrom(Index(1),Pos)=Pick*V2+(1-Pick)*V1;
                        Individuals.Chrom(Index(2),Pos)=Pick*V1+(1-Pick)*V2;
                    end
                    Ret=Individuals.Chrom;
            end
        end
        
        function Ret=Mutation(~, PMutation,LenChrom,Individuals,SizePop,Opts,Bound,Pop)
            % In this function,it fulfils a mutation among chromosomes
            % PMutation input  : probability of mutation
            % LenChrom  input  : length of a chromosome
            % Individuals.Chrom     input  : set of all chromosomes
            % SizePop   input  : size of population
            % Opts      input  : tag for choosing method of crossover
            % Pop       input  : current serial number of generation and maximum gemeration
            % Ret       output : new set of chromosome
            switch Opts
                case 'simple' % mutation at single position
                    for i=1:SizePop
                        % select child at random
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Index=ceil(Pick*SizePop);
                        Pick=rand;
                        if Pick>PMutation
                            continue;
                        end
                        % mutation position
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Pos=ceil(Pick*sum(LenChrom));
                        v=bitget(Individuals.Chrom(Index),Pos);
                        v=~v;
                        % Chrom1=bitset(Individuals.Chrom(Index),Pos,v);
                        Individuals.Chrom(Index)=bitset(Individuals.Chrom(Index),Pos,v);
                    end
                    
                    Ret=Individuals.Chrom;
                case 'float'  % multiple position mutation
                    for i=1:SizePop
                        % select child at random
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Index=ceil(Pick*SizePop);
                        Pick=rand;
                        if Pick>PMutation
                            continue;
                        end
                        % mutation position
                        Pick=rand;
                        while Pick==0
                            Pick=rand;
                        end
                        Pos=ceil(Pick*sum(LenChrom));
                        v=Individuals.Chrom(i,Pos);
                        v1=v-Bound(Pos,1);
                        v2=Bound(Pos,2)-v;
                        Pick=rand;
                        if Pick>0.5
                            Delta=v2*(1-Pick^((1-Pop(1)/Pop(2))^2));
                            Individuals.Chrom(i,Pos)=v+Delta;
                        else
                            Delta=v1*(1-Pick^((1-Pop(1)/Pop(2))^2));
                            Individuals.Chrom(i,Pos)=v-Delta;
                        end
                    end
                    Ret=Individuals.Chrom;
            end
        end
        
    end
end


