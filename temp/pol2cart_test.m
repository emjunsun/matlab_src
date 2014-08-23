function out = model
%
% pol2cart_test.m
%
% Model exported on Aug 24 2014, 04:22 by COMSOL 4.3.2.189.

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

model.geom('geom1').feature.create('cyl1', 'Cylinder');
model.geom('geom1').run;
model.geom('geom1').lengthUnit('mm');
model.geom('geom1').feature('cyl1').set('r', '300');
model.geom('geom1').feature('cyl1').set('h', '1000');
model.geom('geom1').run('cyl1');

model.param.set('port_l', '86.36');
model.param.set('port_w', '43.18');

model.geom('geom1').run('cyl1');
model.geom('geom1').feature.create('blk1', 'Block');
model.geom('geom1').feature('blk1').set('base', 'center');
model.geom('geom1').feature('blk1').set('axistype', 'z');
model.geom('geom1').feature('blk1').setIndex('size', '40', 2);
model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 0);
model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 1);
model.geom('geom1').feature('blk1').setIndex('size', '1', 2);
model.geom('geom1').run('blk1');

model.view('view1').set('transparency', 'on');
model.view('view1').set('renderwireframe', true);

model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 2);
model.geom('geom1').feature('blk1').setIndex('size', '1', 1);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('pos', '300', 0);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 1);
model.geom('geom1').feature('blk1').setIndex('size', '1', 0);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('size', 'port_wport_l', 2);
model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 2);
model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 1);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('size', 'port_w', 2);
model.geom('geom1').feature('blk1').setIndex('size', 'port_l', 1);
model.geom('geom1').run('blk1');

model.view('view1').set('renderwireframe', false);

model.geom('geom1').feature('blk1').setIndex('size', '40', 0);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('pos', '1.8370e-14', 0);
model.geom('geom1').feature('blk1').setIndex('pos', '300', 1);
model.geom('geom1').run('blk1');

model.view('view1').set('renderwireframe', true);
model.view('view1').set('transparency', 'off');

model.geom('geom1').feature('blk1').set('rot', '90');
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('pos', '-5.5109e-14', 0);
model.geom('geom1').feature('blk1').setIndex('pos', '-300', 1);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').set('rot', '270');
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').setIndex('pos', '-5.5109e-14', 1);
model.geom('geom1').feature('blk1').setIndex('pos', '-300', 0);
model.geom('geom1').run('blk1');
model.geom('geom1').feature('blk1').set('rot', '180');
model.geom('geom1').run('blk1');

out = model;
