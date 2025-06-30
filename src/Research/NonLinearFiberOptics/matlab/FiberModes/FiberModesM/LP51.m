a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
u51=7.9096;neff51=sqrt(nc^2-(u51/(2*pi*a/lambda))^2);
w51=sqrt(v^2-u51^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic51(m)=besselj(5,u51*rc(m)/a)/besselj(5,u51);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig51(m)=besselk(5,w51*rg(m)/a)/besselk(5,w51); 
end
psic51t=psic51';
psig51t=psig51';
psic51t = psic51t(end:-1:1);
psig51t=psig51t(end:-1:1);
     PSIC51=repmat(psic51t,1,500);
     PSIG51=repmat(psig51t,1,500);
     SPSIC51=size(PSIC51);
     SPSIG51=size(PSIG51);
     angl = 0:2*pi/(SPSIC51(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG51(2)-1):2*pi;
     COS=cos(5*angl);
     COSg=cos(5*anglg);
     COSMAT=repmat(COS,SPSIC51(1),1);
     COSMATg=repmat(COSg,SPSIG51(1),1);
[Xc,Yc,Zc]=polar3d(PSIC51.*PSIC51.*COSMAT.*COSMAT/max(max(PSIC51))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG51.*PSIG51.*COSMATg.*COSMATg/max(max(PSIC51))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP51.pdf');