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
    psic03(m)=besselj(0,u03*rc(m)/a)/besselj(0,u03);
end
rg=[a:0.1:2*a];
Srg=size(rg);
for m=1:Srg(2);
    psig03(m)=besselk(0,w03*rg(m)/a)/besselk(0,w03); 
end
psic03t=psic03';
psig03t=psig03';
psic03t = psic03t(end:-1:1);
psig03t=psig03t(end:-1:1);
     PSIC03=repmat(psic03t,1,500);
     PSIG03=repmat(psig03t,1,500);
[Xc,Yc,Zc]=polar3d(PSIC03.^2/max(max(PSIC03))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG03.^2/max(max(PSIC03))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP03.pdf');