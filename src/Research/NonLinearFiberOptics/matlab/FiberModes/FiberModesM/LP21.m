a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
u21=4.6544;neff22=sqrt(nc^2-(u21/(2*pi*a/lambda))^2);
w21=sqrt(v^2-u21^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic21(m)=besselj(2,u21*rc(m)/a)/besselj(2,u21);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig21(m)=besselk(2,w21*rg(m)/a)/besselk(2,w21); 
end
psic21t=psic21';
psig21t=psig21';
psic21t = psic21t(end:-1:1);
psig21t=psig21t(end:-1:1);
     PSIC21=repmat(psic21t,1,500);
     PSIG21=repmat(psig21t,1,500);
     SPSIC21=size(PSIC21);
     SPSIG21=size(PSIG21);
     angl = 0:2*pi/(SPSIC21(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG21(2)-1):2*pi;
     COS=cos(2*angl);
     COSg=cos(2*anglg);
     COSMAT=repmat(COS,SPSIC21(1),1);
     COSMATg=repmat(COSg,SPSIG21(1),1);
[Xc,Yc,Zc]=polar3d(PSIC21.*PSIC21.*COSMAT.*COSMAT/max(max(PSIC21))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG21.*PSIG21.*COSMATg.*COSMATg/max(max(PSIC21))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP21.pdf');