a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
umax=v;umin=0;wmax=v;wmin=0;
u=[0:0.1:v];
Su=size(u);
for m=1:Su(2);
    J(m)=u(m)*besselj(4,u(m))/besselj(3,u(m));
end
for m=1:Su(2);
    w(m)=sqrt(v^2-u(m)*u(m));
    K(m)=w(m)*besselk(4,w(m))/besselk(3,w(m));
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
    psic13(m)=besselj(1,u13*rc(m)/a)/besselj(1,u13);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig13(m)=besselk(1,w13*rg(m)/a)/besselk(1,w13); 
end
psic13t=psic13';
psig13t=psig13';
psic13t = psic13t(end:-1:1);
psig13t=psig13t(end:-1:1);
     PSIC13=repmat(psic13t,1,500);
     PSIG13=repmat(psig13t,1,500);
     SPSIC13=size(PSIC13);
     SPSIG13=size(PSIG13);
     angl = 0:2*pi/(SPSIC13(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG13(2)-1):2*pi;
     COS=cos(angl);
     COSg=cos(anglg);
     COSMAT=repmat(COS,SPSIC13(1),1);
     COSMATg=repmat(COSg,SPSIG13(1),1);
[Xc,Yc,Zc]=polar3d(PSIC13.*PSIC13.*COSMAT.*COSMAT/max(max(PSIC13))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG13.*PSIG13.*COSMATg.*COSMATg/max(max(PSIC13))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP13.pdf');
