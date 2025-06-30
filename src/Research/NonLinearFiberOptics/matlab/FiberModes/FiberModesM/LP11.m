a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
umax=v;umin=0;wmax=v;wmin=0;
u=[0:0.1:v];
Su=size(u);
for m=1:Su(2);
    J(m)=u(m)*besselj(2,u(m))/besselj(1,u(m));
end
for m=1:Su(2);
    w(m)=sqrt(v^2-u(m)*u(m));
    K(m)=w(m)*besselk(2,w(m))/besselk(1,w(m));
end
 %plot(u,J);hold on;plot(w,K);
u11=3.4770;neff11=sqrt(nc^2-(u11/(2*pi*a/lambda))^2);
u12=6.3310;neff12=sqrt(nc^2-(u12/(2*pi*a/lambda))^2);
u13=9.0463;neff13=sqrt(nc^2-(u13/(2*pi*a/lambda))^2);
w11=sqrt(v^2-u11^2);
w12=sqrt(v^2-u12^2);
w13=sqrt(v^2-u13^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic11(m)=besselj(1,u11*rc(m)/a)/besselj(1,u11);
end
rg=[a:0.1:2*a];
Srg=size(rg);
for m=1:Srg(2);
    psig11(m)=besselk(1,w11*rg(m)/a)/besselk(1,w11); 
end
psic11t=psic11';
psig11t=psig11';
psic11t = psic11t(end:-1:1);
psig11t=psig11t(end:-1:1);
     PSIC11=repmat(psic11t,1,500);
     PSIG11=repmat(psig11t,1,500);
     SPSIC11=size(PSIC11);
     SPSIG11=size(PSIG11);
     angl = 0:2*pi/(SPSIC11(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG11(2)-1):2*pi;
     COS=cos(angl);
     COSg=cos(anglg);
     COSMAT=repmat(COS,SPSIC11(1),1);
     COSMATg=repmat(COSg,SPSIG11(1),1);
[Xc,Yc,Zc]=polar3d(PSIC11.*PSIC11.*COSMAT.*COSMAT/max(max(PSIC11))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG11.*PSIG11.*COSMATg.*COSMATg/max(max(PSIC11))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP11.pdf');