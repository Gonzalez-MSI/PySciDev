a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
u61=8.9390;neff61=sqrt(nc^2-(u61/(2*pi*a/lambda))^2);
w61=sqrt(v^2-u61^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic61(m)=besselj(6,u61*rc(m)/a)/besselj(6,u61);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig61(m)=besselk(6,w61*rg(m)/a)/besselk(6,w61); 
end
psic61t=psic61';
psig61t=psig61';
psic61t = psic61t(end:-1:1);
psig61t=psig61t(end:-1:1);
     PSIC61=repmat(psic61t,1,500);
     PSIG61=repmat(psig61t,1,500);
     SPSIC61=size(PSIC61);
     SPSIG61=size(PSIG61);
     angl = 0:2*pi/(SPSIC61(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG61(2)-1):2*pi;
     COS=cos(6*angl);
     COSg=cos(6*anglg);
     COSMAT=repmat(COS,SPSIC61(1),1);
     COSMATg=repmat(COSg,SPSIG61(1),1);
[Xc,Yc,Zc]=polar3d(PSIC61.*PSIC61.*COSMAT.*COSMAT/max(max(PSIC61))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG61.*PSIG61.*COSMATg.*COSMATg/max(max(PSIC61))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar


fig_s = gcf();
exportgraphics(fig_s, 'LP61.pdf');