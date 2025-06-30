a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
umax=v;umin=0;wmax=v;wmin=0;
u=[0:0.1:v];
Su=size(u);
for m=1:Su(2);
    J(m)=u(m)*besselj(1,u(m))/besselj(0,u(m));
end
for m=1:Su(2);
    w(m)=sqrt(v^2-u(m)*u(m));
    K(m)=w(m)*besselk(1,w(m))/besselk(0,w(m));
end
 %plot(u,J);hold on;plot(w,K);
u01=2.1845;neff01=sqrt(nc^2-(u01/(2*pi*a/lambda))^2);
u02=4.9966;neff02=sqrt(nc^2-(u02/(2*pi*a/lambda))^2);
u03=7.7642;neff03=sqrt(nc^2-(u03/(2*pi*a/lambda))^2);
w01=sqrt(v^2-u01^2);
w02=sqrt(v^2-u02^2);
w03=sqrt(v^2-u03^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic01(m)=besselj(0,u01*rc(m)/a)/besselj(0,u01);
end
rg=[a:0.1:2*a];
Srg=size(rg);
for m=1:Srg(2);
    psig01(m)=besselk(0,w01*rg(m)/a)/besselk(0,w01); 
end
psic01t=psic01';
psig01t=psig01';
psic01t = psic01t(end:-1:1);
psig01t=psig01t(end:-1:1);
     PSIC01=repmat(psic01t,1,500);
     PSIG01=repmat(psig01t,1,500);
[Xc,Yc,Zc]=polar3d(PSIC01.^2/max(max(PSIC01))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG01.^2/max(max(PSIC01))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP01.pdf');
