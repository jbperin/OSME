%% [y,Fs,nbit,opt]=audioread('loop_SW.wav');
[y,Fs]=audioread('loop_SW.wav');

%load handel

y = (y-min(y)) /(max(y)-min(y)) * 1.15;                % input tra 0 e 1.15

f = 3579545;
fpcm = Fs;

tp = f/fpcm; % 447 = 8000Hz, 437 = 8192Hz
dt1 = (12+5+14)/tp;
dt2 = (12+14)/tp;
dt3 = 1-dt1-dt2;

N = 3*length(y);

x = zeros(1,N);
x(1:3:end) = y;
x(2:3:end-3) = y(1:end-1)*(1-dt1)+y(2:end)*dt1;
x(3:3:end-3) = y(1:end-1)*(1-dt1-dt2)+y(2:end)*(dt1+dt2);
x(end-2:end)= y(end);

n=[0:15]';
vol=2.^(n/2)/2^7.5;
vol(1)=0;

nxtS = uint8(zeros(256,16));
for i=0:15
    for j=0:15
        for in=0:15
            nxtS(i*16+j+1,in+1) = uint8(j*16 + in);
        end
    end
end

curV = zeros(256,16);
for i=0:15
    for j=0:15
        for in=0:15
            curV(i*16+j+1,in+1) = vol(i+1)+vol(j+1)+vol(in+1);
        end
    end
end    

Stt = uint8(zeros(256,N));
Itt = uint8(zeros(256,N));

L  = zeros(256,1);
St = uint8(ones(256,1));
It = uint8(ones(256,1));

for t =1:N
    Ln = inf*ones(256,1);
    if mod(t-1,1000)==0
        proc = fix(t/N *100)
    end
    for cs=0:255
        for in=0:15
            cv = curV(cs+1,in+1);
            ns = double(nxtS(cs+1,in+1));

            switch mod(t-1,3)
                case 0
                    Ltst = L(cs+1)+dt1*abs(x(t)-cv)^2;
                case 1
                    Ltst = L(cs+1)+dt2*abs(x(t)-cv)^2;
                case 2
                    Ltst = L(cs+1)+dt3*abs(x(t)-cv)^2;
            end

            if  Ln(ns+1) >= Ltst
                Ln(ns+1) = Ltst;
                St(ns+1) = cs;
                It(ns+1) = in;
            end
        end
    end
    L = Ln;
    Stt(:,t) = St;
    Itt(:,t) = It;
end

[l,i] = min(L);

P = uint8(zeros(1,N));
I = uint8(zeros(1,N));

P(N) = Stt(i,N);
I(N) = Itt(i,N);
for t = (N-1):-1:1
   P(t) = Stt(double(P(t+1))+1,t);
   I(t) = Itt(double(P(t+1))+1,t);
end

V = zeros(1,N);
for t = 1:N
   V(t) = curV(double(P(t))+1,double(I(t))+1); 
end

er = sum(abs(x(1:3:end)-V(1:3:end)).^2)*dt1+...
     sum(abs(x(2:3:end)-V(2:3:end)).^2)*dt2+...
     sum(abs(x(3:3:end)-V(3:3:end)).^2)*dt3

en = sum(abs(x(1:3:end)).^2)*dt1+...
     sum(abs(x(2:3:end)).^2)*dt2+...
     sum(abs(x(3:3:end)).^2)*dt3

disp('SNR db=')
SNR = 10*log10(en/er)



j=1; 
A = 0;  
B = 0;  
C = 0;
la = 1; 
lb = 1; 
lc = 1;
ja=1;   
jb=2;   
jc=2;
s = [];

for i=1: length (I)
    switch mod(i-1,3)
        case 0
            if A==I(i)
                la=la+1;
                if la==17
                    s(ja)=16*16+double(A);
                    la=1;
                    ja=j;
                    j=j+1;
                end
            else
                s(ja)=16*la+double(A);
                la=1;
                ja=j;
                j=j+1;
                A=I(i);
            end
        case 1
            if B==I(i)
                lb=lb+1;
                if lb==17
                    s(jb)=16*16+double(B);
                    lb=1;
                    jb=j;
                    j=j+1;
                end
            else
                s(jb)=16*lb+double(B);
                lb=1;
                jb=j;
                j=j+1;
                B=I(i);
            end
        case 2
            if C==I(i)
                lc=lc+1;
                if lc==17
                    s(jc)=16*16+double(C);
                    lc=1;
                    jc=j;
                    j=j+1;
                end
            else
                s(jc)=16*lc+double(C);
                lc=1;
                jc=j;
                j=j+1;
                C=I(i);
            end
    end
    
end

disp('actual len=')
disp(length(s))

I0 = I(1:3:end);
I1 = I(2:3:end);
I2 = I(3:3:end);

i0 = find(diff(double(I0)));
str0=[];
for j=0:(length(i0)-1)
    if j==0
        t = I0(1:i0(j+1));
    else
        t = I0(i0(j)+1:i0(j+1));
    end
    str0(j+1,1) = length(t);
    str0(j+1,2) = I0(i0(j+1));
end

i1 = find(diff(double(I1)));
str1=[];
for j=0:(length(i1)-1)
    if j==0
        t = I1(1:i1(j+1));
    else
        t = I1(i1(j)+1:i1(j+1));
    end
    str1(j+1,1) = length(t);
    str1(j+1,2) = I1(i1(j+1));
end

i2 = find(diff(double(I2)));
str2=[];
for j=0:(length(i2)-1)
    if j==0
        t = I2(1:i2(j+1));
    else
        t = I2(i2(j)+1:i2(j+1));
    end
    str2(j+1,1) = length(t);
    str2(j+1,2) = I2(i2(j+1));
end
disp('best len=')
disp(length(str0)+length(str1)+length(str2))
disp ('ratio =')
disp(length(s)/(length(str0)+length(str1)+length(str2)))

% i=20 ; [  bitand(s(1:i)',240)/16 bitand(s(1:i)',15) ]
% [ str0(1:10,:) str1(1:10,:) str2(1:10,:) ]


t = zeros(N,1);

t(1:3:end) = 0   +       [1:N/3];
t(2:3:end) = dt1 +       [1:N/3];
t(3:3:end) = dt1 + dt2 + [1:N/3];

figure(1)
subplot(2,1,1)
plot(t,V,t,x,'r',t,x,'.g')
subplot(2,1,2)
plot(t,V-x)

np = fix(sum(fix(s/16))/3)-6;

[fid, MESSAGE] = fopen('out.txt','W');
fprintf(fid,'   dw    %6d\n',np);
fprintf(fid,'   db    %3d\n',s);
fclose(fid);

% ASM replayer simulator

Vp=[];t=1;
ChA=0;ChB=0;ChC=0;

b=1;d=1;e=1;
hl=1;
hlp = np;
while (hlp>0)
	b=b-1;
	if b==0
        b = fix(s(hl)/16);
        bp = bitand(s(hl),15);
        hl=hl+1;
	end
	d=d-1;
	if  d==0
        d = fix(s(hl)/16);
        dp = bitand(s(hl),15);
        hl=hl+1;
	end
	e=e-1;
	if  e==0
        e = fix(s(hl)/16);
        ep = bitand(s(hl),15);
        hl=hl+1;
    end

	ChA = bp;
	Vp(t) = vol(ChA+1)+vol(ChB+1)+vol(ChC+1); t=t+1;
	ChB = dp;
	Vp(t) = vol(ChA+1)+vol(ChB+1)+vol(ChC+1); t=t+1;
	ChC = ep;
	Vp(t) = vol(ChA+1)+vol(ChB+1)+vol(ChC+1); t=t+1;
    hlp = hlp-1;
end

figure(2)
plot(V)
hold on;
plot(Vp,'.r')