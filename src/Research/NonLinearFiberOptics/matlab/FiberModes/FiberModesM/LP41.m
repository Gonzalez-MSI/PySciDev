a=8.335;lambda=0.6328;nc=1.462420;ng=1.457420;
v=(2*pi*a/lambda)*sqrt(nc^2-ng^2);
umax=v;umin=0;wmax=v;wmin=0;
u41=6.8560;neff41=sqrt(nc^2-(u41/(2*pi*a/lambda))^2);
w41=sqrt(v^2-u41^2);
rc=[0:0.1:a];
Src=size(rc);
for m=1:Src(2);
    psic41(m)=besselj(4,u41*rc(m)/a)/besselj(4,u41);
end
rg=[a:0.1:3*a];
Srg=size(rg);
for m=1:Srg(2);
    psig41(m)=besselk(4,w41*rg(m)/a)/besselk(4,w41); 
end
psic41t=psic41';
psig41t=psig41';
psic41t = psic41t(end:-1:1);
psig41t=psig41t(end:-1:1);
     PSIC41=repmat(psic41t,1,500);
     PSIG41=repmat(psig41t,1,500);
     SPSIC41=size(PSIC41);
     SPSIG41=size(PSIG41);
     angl = 0:2*pi/(SPSIC41(2)-1):2*pi;
     anglg= 0:2*pi/(SPSIG41(2)-1):2*pi;
     COS=cos(4*angl);
     COSg=cos(4*anglg);
     COSMAT=repmat(COS,SPSIC41(1),1);
     COSMATg=repmat(COSg,SPSIG41(1),1);
[Xc,Yc,Zc]=polar3d(PSIC41.*PSIC41.*COSMAT.*COSMAT/max(max(PSIC41))^2,0,2*pi,0,a,2,'off');
[Xg,Yg,Zg]=polar3d(PSIG41.*PSIG41.*COSMATg.*COSMATg/max(max(PSIC41))^2,0,2*pi,a,2*a,2,'off');
subplot(2,1,1);
surf(Xc,Yc,Zc); hold on;surf(Xg,Yg,Zg);axis([-20 20 -20 20]);shading interp;colorbar;
subplot(2,1,2);
pcolor(Xc,Yc,Zc);hold on;pcolor(Xg,Yg,Zg);axis([-10 10 -10 10]);shading interp
colorbar

fig_s = gcf();
exportgraphics(fig_s, 'LP41.pdf');
