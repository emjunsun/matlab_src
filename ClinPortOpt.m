classdef ClinPortOpt < handle
    
    % Clinder cavity Ports Optimise.
    %
    
    properties
        % clinder radius, unit is mm
        clinR = 100;
        % clinder height, unit is mm
        clinH = 200;
        
        % port size in cross section,unit is mm
        portA = 86.36;
        portB = 43.18;
        % port length
        portL = 40;
        
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
            
            Ret = self.Code(self.GAPara.LenChrom,self.GAPara.CodeFcn,self.GAPara.Bound)
            self.Decode(self.GAPara.LenChrom,self.GAPara.Bound,Ret,self.GAPara.CodeFcn)
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