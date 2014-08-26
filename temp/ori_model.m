function out = model
%
% ori_model.m
%
% Model exported on Aug 26 2014, 06:11 by COMSOL 4.3.2.189.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/media/sda6/opt/micro_opt/matlab_src/temp');

model.modelNode.create('mod1');

model.geom.create('geom1', 3);

model.mesh.create('mesh1', 'geom1');

model.physics.create('emw', 'ElectromagneticWaves', 'geom1');

model.study.create('std1');
model.study('std1').feature.create('freq', 'Frequency');
model.study('std1').feature('freq').activate('emw', true);

model.geom('geom1').lengthUnit('mm');
model.geom('geom1').feature.create('cyl1', 'Cylinder');

model.param.set('clinR', '300');
model.param.set('clinH', '1000');
model.param.set('portA', '86.36');
model.param.set('portB', '43.18');
model.param.set('portL', '40');

model.geom('geom1').feature('cyl1').set('r', 'clinR');
model.geom('geom1').feature('cyl1').set('h', 'clinH');
model.geom('geom1').run('cyl1');
model.geom('geom1').feature.create('blk1', 'Block');
model.geom('geom1').feature('blk1').set('base', 'center');
model.geom('geom1').feature('blk1').setIndex('pos', '1.836970198721030e-14', 0);
model.geom('geom1').feature('blk1').setIndex('pos', '300', 1);
model.geom('geom1').feature('blk1').setIndex('pos', '50', 2);
model.geom('geom1').feature('blk1').set('rot', '90');
model.geom('geom1').feature('blk1').setIndex('size', 'portL', 0);
model.geom('geom1').feature('blk1').setIndex('size', 'portA', 1);
model.geom('geom1').feature('blk1').setIndex('size', 'portB', 2);
model.geom('geom1').run('blk1');

model.view('view1').set('renderwireframe', true);
model.view('view1').set('transparency', 'on');
model.view('view1').set('renderwireframe', true);
model.view('view1').set('transparency', 'off');

model.geom('geom1').run('blk1');
model.geom('geom1').feature.create('blk2', 'Block');
model.geom('geom1').feature('blk2').set('base', 'center');
model.geom('geom1').feature('blk2').setIndex('pos', '2.598076211353316e+02', 0);
model.geom('geom1').feature('blk2').setIndex('pos', '400', 2);
model.geom('geom1').feature('blk2').setIndex('pos', '1.500000000000000e+02', 1);
model.geom('geom1').feature('blk2').setIndex('size', 'portL', 0);
model.geom('geom1').feature('blk2').setIndex('size', 'portA', 1);
model.geom('geom1').feature('blk2').setIndex('size', 'portB', 2);
model.geom('geom1').feature('blk2').set('rot', '30');
model.geom('geom1').run('blk2');

model.view('view1').set('renderwireframe', false);

model.geom('geom1').feature('blk2').set('rot', '0');
model.geom('geom1').run('blk2');
model.geom('geom1').feature('blk2').set('rot', '30');
model.geom('geom1').run('blk2');
model.geom('geom1').feature('blk2').setIndex('size', 'portA', 2);
model.geom('geom1').feature('blk2').setIndex('size', 'portB', 1);
model.geom('geom1').run('blk2');

model.view('view1').set('renderwireframe', false);

model.geom('geom1').run('blk2');
model.geom('geom1').feature.create('uni1', 'Union');
model.geom('geom1').feature('uni1').set('intbnd', 'off');
model.geom('geom1').feature('uni1').selection('input').set({'blk1' 'blk2' 'cyl1'});
model.geom('geom1').run('uni1');

model.view('view1').set('transparency', 'on');

model.geom('geom1').run('uni1');
model.geom('geom1').feature.create('blk3', 'Block');
model.geom('geom1').feature('blk3').set('base', 'center');
model.geom('geom1').feature('blk3').setIndex('size', '100', 0);
model.geom('geom1').feature('blk3').setIndex('size', '100', 1);
model.geom('geom1').feature('blk3').setIndex('size', '100', 2);
model.geom('geom1').run('blk3');
model.geom('geom1').feature('blk3').setIndex('pos', '500', 2);
model.geom('geom1').run('blk3');
model.geom('geom1').run;

model.view('view1').set('transparency', 'off');

model.selection.create('sel1', 'Explicit');
model.selection('sel1').geom(2);
model.selection('sel1').set([13]);
model.selection('sel1').name('port1');
model.selection.create('sel2', 'Explicit');
model.selection('sel2').geom(2);
model.selection('sel2').set([21]);
model.selection('sel2').name('port2');

model.material.create('mat1');
model.material('mat1').name('Air');
model.material('mat1').set('family', 'air');
model.material('mat1').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.material('mat1').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.material('mat1').propertyGroup('def').set('electricconductivity', '0[S/m]');
model.material('mat1').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.material('mat1').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.material('mat1').propertyGroup('def').set('thermalconductivity', 'k(T[1/K])[W/(m*K)]');
model.material('mat1').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.material('mat1').propertyGroup('def').func.create('eta', 'Piecewise');
model.material('mat1').propertyGroup('def').func('eta').set('funcname', 'eta');
model.material('mat1').propertyGroup('def').func('eta').set('arg', 'T');
model.material('mat1').propertyGroup('def').func('eta').set('extrap', 'constant');
model.material('mat1').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.material('mat1').propertyGroup('def').func.create('Cp', 'Piecewise');
model.material('mat1').propertyGroup('def').func('Cp').set('funcname', 'Cp');
model.material('mat1').propertyGroup('def').func('Cp').set('arg', 'T');
model.material('mat1').propertyGroup('def').func('Cp').set('extrap', 'constant');
model.material('mat1').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.material('mat1').propertyGroup('def').func.create('rho', 'Analytic');
model.material('mat1').propertyGroup('def').func('rho').set('funcname', 'rho');
model.material('mat1').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.material('mat1').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
model.material('mat1').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.material('mat1').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
model.material('mat1').propertyGroup('def').func.create('k', 'Piecewise');
model.material('mat1').propertyGroup('def').func('k').set('funcname', 'k');
model.material('mat1').propertyGroup('def').func('k').set('arg', 'T');
model.material('mat1').propertyGroup('def').func('k').set('extrap', 'constant');
model.material('mat1').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.material('mat1').propertyGroup('def').func.create('cs', 'Analytic');
model.material('mat1').propertyGroup('def').func('cs').set('funcname', 'cs');
model.material('mat1').propertyGroup('def').func('cs').set('args', {'T'});
model.material('mat1').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.material('mat1').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.material('mat1').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.material('mat1').propertyGroup('def').addInput('temperature');
model.material('mat1').propertyGroup('def').addInput('pressure');
model.material('mat1').set('family', 'air');
model.material('mat1').propertyGroup('def').set('relpermittivity', {'1'});
model.material('mat1').propertyGroup('def').set('relpermeability', {'1'});

model.view('view1').set('transparency', 'on');

model.material('mat1').selection.set([1]);
model.material.create('mat2');
model.material('mat2').name('Water, liquid');
model.material('mat2').set('family', 'water');
model.material('mat2').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.material('mat2').propertyGroup('def').set('ratioofspecificheat', '1.0');
model.material('mat2').propertyGroup('def').set('electricconductivity', '5.5e-6[S/m]');
model.material('mat2').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.material('mat2').propertyGroup('def').set('density', 'rho(T[1/K])[kg/m^3]');
model.material('mat2').propertyGroup('def').set('thermalconductivity', 'k(T[1/K])[W/(m*K)]');
model.material('mat2').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.material('mat2').propertyGroup('def').func.create('eta', 'Piecewise');
model.material('mat2').propertyGroup('def').func('eta').set('funcname', 'eta');
model.material('mat2').propertyGroup('def').func('eta').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('eta').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('eta').set('pieces', {'273.15' '413.15' '1.3799566804-0.021224019151*T^1+1.3604562827E-4*T^2-4.6454090319E-7*T^3+8.9042735735E-10*T^4-9.0790692686E-13*T^5+3.8457331488E-16*T^6'; '413.15' '553.75' '0.00401235783-2.10746715E-5*T^1+3.85772275E-8*T^2-2.39730284E-11*T^3'});
model.material('mat2').propertyGroup('def').func.create('Cp', 'Piecewise');
model.material('mat2').propertyGroup('def').func('Cp').set('funcname', 'Cp');
model.material('mat2').propertyGroup('def').func('Cp').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('Cp').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('Cp').set('pieces', {'273.15' '553.75' '12010.1471-80.4072879*T^1+0.309866854*T^2-5.38186884E-4*T^3+3.62536437E-7*T^4'});
model.material('mat2').propertyGroup('def').func.create('rho', 'Piecewise');
model.material('mat2').propertyGroup('def').func('rho').set('funcname', 'rho');
model.material('mat2').propertyGroup('def').func('rho').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('rho').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('rho').set('pieces', {'273.15' '553.75' '838.466135+1.40050603*T^1-0.0030112376*T^2+3.71822313E-7*T^3'});
model.material('mat2').propertyGroup('def').func.create('k', 'Piecewise');
model.material('mat2').propertyGroup('def').func('k').set('funcname', 'k');
model.material('mat2').propertyGroup('def').func('k').set('arg', 'T');
model.material('mat2').propertyGroup('def').func('k').set('extrap', 'constant');
model.material('mat2').propertyGroup('def').func('k').set('pieces', {'273.15' '553.75' '-0.869083936+0.00894880345*T^1-1.58366345E-5*T^2+7.97543259E-9*T^3'});
model.material('mat2').propertyGroup('def').func.create('cs', 'Interpolation');
model.material('mat2').propertyGroup('def').func('cs').set('sourcetype', 'user');
model.material('mat2').propertyGroup('def').func('cs').set('source', 'table');
model.material('mat2').propertyGroup('def').func('cs').set('funcname', 'cs');
model.material('mat2').propertyGroup('def').func('cs').set('table', {'273' '1403'; '278' '1427'; '283' '1447'; '293' '1481'; '303' '1507'; '313' '1526'; '323' '1541'; '333' '1552'; '343' '1555'; '353' '1555';  ...
'363' '1550'; '373' '1543'});
model.material('mat2').propertyGroup('def').func('cs').set('interp', 'piecewisecubic');
model.material('mat2').propertyGroup('def').func('cs').set('extrap', 'const');
model.material('mat2').propertyGroup('def').addInput('temperature');
model.material('mat2').set('family', 'water');
model.material('mat2').selection.set([2]);
model.material('mat2').propertyGroup('def').set('relpermittivity', {'65-20*j'});
model.material('mat2').propertyGroup('def').set('relpermeability', {'1'});

model.physics('emw').feature.create('port1', 'Port', 2);
model.physics('emw').feature('port1').selection.named('sel1');
model.physics('emw').feature('port1').set('PortType', 1, 'Rectangular');
model.physics('emw').feature('port1').set('PortExcitation', 1, 'on');
model.physics('emw').feature('port1').set('Pin', 1, '500');
model.physics('emw').feature.create('port2', 'Port', 2);
model.physics('emw').feature('port2').selection.named('sel2');
model.physics('emw').feature('port2').set('PortType', 1, 'Rectangular');
model.physics('emw').feature('port2').set('PortExcitation', 1, 'on');
model.physics('emw').feature('port2').set('Pin', 1, '500');

model.mesh('mesh1').feature.create('ftet1', 'FreeTet');
model.mesh('mesh1').feature('size').set('custom', 'off');
model.mesh('mesh1').feature('size').set('hauto', '3');
model.mesh('mesh1').feature('ftet1').feature.create('size1', 'Size');
model.mesh('mesh1').feature('ftet1').feature('size1').selection.geom('geom1', 3);
model.mesh('mesh1').feature('ftet1').feature('size1').selection.set([2]);
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '2');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('hauto', '1');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('ftet1').feature('size1').set('table', 'cfd');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '2');
model.mesh('mesh1').run;
model.mesh('mesh1').feature('size').set('hauto', '1');
model.mesh('mesh1').run;

model.study('std1').feature('freq').set('plist', '2.45[GHz]');

model.sol.create('sol1');
model.sol('sol1').study('std1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'2.45[GHz]'});
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'mod1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'mod1_E'});
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');

model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').name('Electric Field (emw)');
model.result('pg1').set('oldanalysistype', 'noneavailable');
model.result('pg1').set('frametype', 'spatial');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('mslc1', 'Multislice');
model.result('pg1').feature('mslc1').name('Multislice');
model.result('pg1').feature('mslc1').set('oldanalysistype', 'noneavailable');
model.result('pg1').feature('mslc1').set('data', 'parent');

model.mesh('mesh1').feature('size').set('hauto', '2');
model.mesh('mesh1').run('size');
model.mesh('mesh1').run;

model.sol('sol1').study('std1');
model.sol('sol1').feature.remove('s1');
model.sol('sol1').feature.remove('v1');
model.sol('sol1').feature.remove('st1');
model.sol('sol1').feature.create('st1', 'StudyStep');
model.sol('sol1').feature('st1').set('study', 'std1');
model.sol('sol1').feature('st1').set('studystep', 'freq');
model.sol('sol1').feature.create('v1', 'Variables');
model.sol('sol1').feature('v1').set('control', 'freq');
model.sol('sol1').feature.create('s1', 'Stationary');
model.sol('sol1').feature('s1').feature.create('p1', 'Parametric');
model.sol('sol1').feature('s1').feature.remove('pDef');
model.sol('sol1').feature('s1').feature('p1').set('pname', {'freq'});
model.sol('sol1').feature('s1').feature('p1').set('plistarr', {'2.45[GHz]'});
model.sol('sol1').feature('s1').feature('p1').set('plot', 'off');
model.sol('sol1').feature('s1').feature('p1').set('plotgroup', 'pg1');
model.sol('sol1').feature('s1').feature('p1').set('probesel', 'all');
model.sol('sol1').feature('s1').feature('p1').set('probes', {});
model.sol('sol1').feature('s1').feature('p1').set('control', 'freq');
model.sol('sol1').feature('s1').set('control', 'freq');
model.sol('sol1').feature('s1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('s1').feature.create('fc1', 'FullyCoupled');
model.sol('sol1').feature('s1').feature.create('i1', 'Iterative');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').feature('s1').feature('fc1').set('linsolver', 'i1');
model.sol('sol1').feature('s1').feature('i1').feature.create('mg1', 'Multigrid');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('prefun', 'sorvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('pr').feature('sv1').set('sorvecdof', {'mod1_E'});
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature.create('sv1', 'SORVector');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('prefun', 'soruvec');
model.sol('sol1').feature('s1').feature('i1').feature('mg1').feature('po').feature('sv1').set('sorvecdof', {'mod1_E'});
model.sol('sol1').feature('s1').feature.remove('fcDef');
model.sol('sol1').attach('std1');
model.sol('sol1').feature('s1').feature('i1').set('linsolver', 'fgmres');

model.mesh('mesh1').feature('size').set('hauto', '1');
model.mesh('mesh1').feature('size').set('custom', 'on');
model.mesh('mesh1').feature('size').set('hmax', '30');
model.mesh('mesh1').feature('ftet1').feature('size1').set('custom', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmaxactive', 'on');
model.mesh('mesh1').feature('ftet1').feature('size1').set('hmax', '6');
model.mesh('mesh1').run;

model.view('view1').set('transparency', 'on');

model.name('ori.mph');

model.sol('sol1').runAll;

model.result('pg1').run;
model.result('pg1').run;
model.result('pg1').run;

model.name('ori.mph');

model.result('pg1').run;

out = model;
