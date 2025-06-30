a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
u71=9.9451;neff71=sqrt(nc^2-(u71/(2*pi*a/lambda))^2);
w71=sqrt(v^2-u71^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic71(m)=besselj(7,u71*rc(m)/a)/besselj(7,u71);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig71(m)=besselk(7,w71*rg(m)/a)/besselk(7,w71); 
end
psic71t=psic71';
psig71t=psig71';
psic71t = psic71t(end:-1:1);
psig71t=psig71t(end:-1:1);
     PSIC71=repmat(psic71t,1,500);
     PSIG71=repmat(psig71t,1,500);
     SPSIC71=size(PSIC71);
     SPSIG71=size(PSIG71);
     angl = 0:2*pi/(SPSIC71(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG71(2)-1):2*pi;
     COS=cos(7*angl);
     COSg=cos(7*anglg);
     COSMAT=repmat(COS,SPSIC71(1),1);
     COSMATg=repmat(COSg,SPSIG71(1),1);
[Xc,Yc,Zc]=polar3d(PSIC71.*PSIC71.*COSMAT.*COSMAT/max(max(PSIC71))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG71.*PSIG71.*COSMATg.*COSMATg/max(max(PSIC71))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar


fig_s = gcf();
exportgraphics(fig_s, 'LP71.pdf');