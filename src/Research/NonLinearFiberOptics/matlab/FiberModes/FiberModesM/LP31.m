a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
u31=5.7740;neff31=sqrt(nc^2-(u31/(2*pi*a/lambda))^2);
w31=sqrt(v^2-u31^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic31(m)=besselj(3,u31*rc(m)/a)/besselj(3,u31);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig31(m)=besselk(3,w31*rg(m)/a)/besselk(3,w31); 
end
psic31t=psic31';
psig31t=psig31';
psic31t = psic31t(end:-1:1);
psig31t=psig31t(end:-1:1);
     PSIC31=repmat(psic31t,1,500);
     PSIG31=repmat(psig31t,1,500);
     SPSIC31=size(PSIC31);
     SPSIG31=size(PSIG31);
     angl = 0:2*pi/(SPSIC31(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG31(2)-1):2*pi;
     COS=cos(3*angl);
     COSg=cos(3*anglg);
     COSMAT=repmat(COS,SPSIC31(1),1);
     COSMATg=repmat(COSg,SPSIG31(1),1);
[Xc,Yc,Zc]=polar3d(PSIC31.*PSIC31.*COSMAT.*COSMAT/max(max(PSIC31))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG31.*PSIG31.*COSMATg.*COSMATg/max(max(PSIC31))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP31.pdf');