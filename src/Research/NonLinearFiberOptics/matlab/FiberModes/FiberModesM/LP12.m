a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
umax=v;umin=0;wmax=v;wmin=0;
u=[0:0.1:v];
Su=size(u);
for m=1:Su(2);
    J(m)=u(m)*besselj(3,u(m))/besselj(2,u(m));
end
for m=1:Su(2);
    w(m)=sqrt(v^2-u(m)*u(m));
    K(m)=w(m)*besselk(3,w(m))/besselk(2,w(m));
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
    psic12(m)=besselj(1,u12*rc(m)/a)/besselj(1,u12);
end
rg=[a:0.1:2*a];
Srg=size(rg);
for m=1:Srg(2);
    psig12(m)=besselk(1,w12*rg(m)/a)/besselk(1,w12); 
end
psic12t=psic12';
psig12t=psig12';
psic12t = psic12t(end:-1:1);
psig12t=psig12t(end:-1:1);
     PSIC12=repmat(psic12t,1,500);
     PSIG12=repmat(psig12t,1,500);
     SPSIC12=size(PSIC12);
     SPSIG12=size(PSIG12);
     angl = 0:2*pi/(SPSIC12(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG12(2)-1):2*pi;
     COS=cos(angl);
     COSg=cos(anglg);
     COSMAT=repmat(COS,SPSIC12(1),1);
     COSMATg=repmat(COSg,SPSIG12(1),1);
[Xc,Yc,Zc]=polar3d(PSIC12.*PSIC12.*COSMAT.*COSMAT/min(min(PSIC12))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG12.*PSIG12.*COSMATg.*COSMATg/min(min(PSIC12))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP12.pdf');