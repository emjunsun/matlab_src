function out = model
%
% model_rot.m
%
% Model exported on Aug 18 2014, 01:20 by COMSOL 4.3.2.189.

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('/media/sda6/opt/micro_opt');

model.modelNode.create('mod1');

model.geom.create('geom1', 3);

model.mesh.create('mesh1', 'geom1');

model.physics.create('emw', 'ElectromagneticWaves', 'geom1');

model.study.create('std1');
model.study('std1').feature.create('freq', 'Frequency');
model.study('std1').feature('freq').activate('emw', true);

model.geom('geom1').lengthUnit('mm');
model.geom('geom1').feature.create('blk1', 'Block');
model.geom('geom1').feature('blk1').set('rot', '10');
model.geom('geom1').runAll;

out = model;
