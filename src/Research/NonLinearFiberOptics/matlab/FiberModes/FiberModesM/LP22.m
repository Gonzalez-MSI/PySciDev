a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
u22=7.5677;neff22=sqrt(nc^2-(u22/(2*pi*a/lambda))^2);
w22=sqrt(v^2-u22^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic22(m)=besselj(2,u22*rc(m)/a)/besselj(2,u22);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig22(m)=besselk(2,w22*rg(m)/a)/besselk(2,w22); 
end
psic22t=psic22';
psig22t=psig22';
psic22t = psic22t(end:-1:1);
psig22t=psig22t(end:-1:1);
     PSIC22=repmat(psic22t,1,500);
     PSIG22=repmat(psig22t,1,500);
     SPSIC22=size(PSIC22);
     SPSIG22=size(PSIG22);
     angl = 0:2*pi/(SPSIC22(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG22(2)-1):2*pi;
     COS=cos(2*angl);
     COSg=cos(2*anglg);
     COSMAT=repmat(COS,SPSIC22(1),1);
     COSMATg=repmat(COSg,SPSIG22(1),1);
[Xc,Yc,Zc]=polar3d(PSIC22.*PSIC22.*COSMAT.*COSMAT/min(min(PSIC22))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG22.*PSIG22.*COSMATg.*COSMATg/min(min(PSIC22))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP22.pdf');