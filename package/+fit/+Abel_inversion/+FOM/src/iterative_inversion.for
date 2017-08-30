cc       programma inversie.for; updated dd. 2/8/2001
c
        parameter(nr2=250)
        real*8 targetx
        integer maxhisto
        real*4 histo
        dimension histo(0:20000)
        dimension targetx(-nr2+1:nr2,-nr2+1:nr2)
        character result*8,str*60
        character*1 ci1,cis1,cif1
        character*2 ci2,cis2,cif2
        character*3 ci3,cis3,cif3
        character*4 ci4,cis4,cif4
        character*6 name
        character*10 names,namef
        real*4 exppic,ri,pi,x,y,z,small,r3d,rnr,inversie,
     *     theta,xcenter,ycenter,thetadeg,radial,angular,pic,
     *     fr,ftheta,dz,ang2drpic,pic2,r2dexp,ang2dexp,
     *     picinv,target,target2,r2d,ang2d,radfac,angfac,
     *     sum1old,sum2old,target0,pr,rot
        integer i,j,k,l,m,itmax,nrange,nradius,ixcenter,iycenter,nhor,
     *     nver,ir3d,ithetadeg,isym,icenter,pminhor,pminver,
     *     maxangle,ihf,nmax,itrans,itermode
        parameter(nmax=1250)
        dimension exppic(1:nmax,1:nmax),
     *     target(-nmax/2:nmax/2,-nmax/2:nmax/2),
     *     pic(-nmax/2:nmax/2,-nmax/2:nmax/2),
     *     fr(1:nmax/2),target0(-nmax/2:nmax/2,-nmax/2:nmax/2),
     *     ftheta(1:nmax/2,0:360),r2dexp(1:nmax/2),
     *     ang2dexp(1:nmax/2,0:360),ang2drpic(1:nmax/2,0:360),
     *     picinv(1:nmax,1:nmax),target2(1:nmax,1:nmax),
     *     pic2(1:nmax,1:nmax),r2d(1:nmax/2),ang2d(1:nmax/2,0:360),
     *     inversie(-nmax/2:nmax/2,-nmax/2:nmax/2),pr(1:nmax/2)
        open(unit=20,file='names.dat',status='old')
c        open(unit=10,file='target.dat',status='unknown')
c        open(unit=11,file='targetd.dat',status='unknown')
c        open(unit=12,file='simul.dat',status='unknown')
c        open(unit=13,file='simuld.dat',status='unknown')
c        open(unit=14,file='fourhan.dat',status='unknown')
c        open(unit=16,file='3dverdel.dat',status='unknown')
c        open(unit=17,file='comments.dat',status='unknown')
c        open(unit=18,file='residud.dat',status='unknown')
c        open(unit=20,file='input.dat',status='old')
c        open(unit=21,file='residu.dat',status='unknown')
c        open(unit=22,file='inversie.dat',status='unknown')
c        open(unit=24,file='debug.dat',status='unknown')
c        open(unit=25,file='debug2.dat',status='unknown')
c        open(unit=19,file='pofe.dat',status='unknown')
c
c       ***************************************************************
c
        pi=4.*atan(1.)
        small=1.e-10
c
c       Default stuff
c       *****************************
        icenter = 0
        ihf = 0
        itrans = 1
        nrange = 0
        rot = 0
c
c       Information from the inputfile (names.dat)
c       ******************************
c
        read(20,4)isym,itermode,itmax,radfac,angfac
        write(6,4)isym,itermode,itmax,radfac,angfac
4       format(3i5,2f10.4)

c       ***************************************************************

c 1111    call time(result)
1111	continue
        write(6,*)result

c       ************************************
c       Read the number and the size of the image
c       *************************************

c       Read image number
        read(20,8,end=1000)iloop,str
        write(6,8)iloop,str
8       format(1i5,a)

        read(20,7)nhor,nver
        write(6,7)nhor,nver
7       format(2i5)

        nr = nhor/2;
        xcenter1 = nhor/2+0.5
        ycenter1 = nver/2+0.5

        if(iloop.le.9)write(ci1,'(i1)')iloop
        if(iloop.le.9)ci4='000'//ci1
        if(iloop.ge.10.and.iloop.le.99)write(ci2,'(i2)')iloop
        if(iloop.ge.10.and.iloop.le.99)ci4='00'//ci2
        if(iloop.ge.100.and.iloop.le.999)write(ci3,'(i3)')iloop
        if(iloop.ge.100.and.iloop.le.999)ci4='0'//ci3
        if(iloop.ge.1000)write(ci4,'(i4)')iloop
        str='images'//ci4//'.dat'
6       format('Inverting: ',a20)
        open(unit=9,file=str,status='old')
c        open(unit=28,file='back.dat',status='old')
        open(unit=17,file='it_comments'//ci4//'.dat',status='unknown')
        write(6,6)str
        write(17,6)str

c       ***************************************************************
c
c       Read the experimental image and define the center of the image
c       **************************************************************
c
        if(itrans.eq.0)goto 11
        do 10 i=1,nver
        read(9,*)(exppic(i,j),j=1,nhor)
c        read(28,*)(backgr(i,j),j=1,nhor)
c        write(6,*)(exppic(i,j),j=1,nhor)
19       format(480f16.6)
10      continue
        goto 12
11      continue
        do 13 i=1,nhor
        read(9,*)(exppic(j,i),j=1,nver)
cc        read(28,*)(backgr(j,i),j=1,nver)
c        write(6,*)(exppic(j,i),j=1,nver)
13      continue
12      continue
        close(unit=9)
9       format(1200f12.6)
        do 26 k=0,20000
        histo(k)=0
26      continue
        do 18 i=1,nver
        do 17 j=1,nhor
        k=exppic(j,i)
        histo(k)=histo(k)+1
17      continue
18      continue
        maxhisto=0
        do 29 k=0,20000
c        write(24,*)k,histo(k)
        if(histo(k).gt.maxhisto)k0=k
        if(histo(k).gt.sum)maxhisto=histo(k)
29      continue
        write(6,*)k0,maxhisto
c        do 16 i=1,nver
c        do 14 j=1,nhor
c       Constant background subtraction
cc        exppic(i,j)=exppic(i,j)-backgr(i,j)
cccc        if(exppic(i,j).lt.0)exppic(i,j)=0.
cccc        if(exppic(i,j).gt.40000.)exppic(i,j)=0.
14      continue
16      continue
c
        if(icenter.eq.0)goto 1101
c       icenter = 0: use specified center
c       icenter = 1: calculate center from maximum symmetry
c       icenter = 2: calculate center from maximum in radial distribution
c
        iycenter=ycenter1
        ixcenter=xcenter1
        nradius=nr
c
        if(icenter.eq.1)
     *     call center1(nrange,nradius,ixcenter,iycenter,nhor,nver,
     *     exppic,xcenter,ycenter)
c
        if(icenter.eq.2)
     *     call center2(nrange,nradius,ixcenter,iycenter,nhor,nver,
     *     exppic,xcenter,ycenter)
c
        if(icenter.eq.3)
     *     call center3(nrange,nhor,nver,ixcenter,iycenter,
     *     exppic,xcenter,ycenter)
c
1101    continue
        if(icenter.eq.0)ycenter=ycenter1
        if(icenter.eq.0)xcenter=xcenter1
        if(nr.gt.int(xcenter-0.5))nr=int(xcenter-0.5)
        if(nr.gt.int(ycenter-0.5))nr=int(ycenter-0.5)
        if(nr.gt.nhor-1-int(xcenter-0.5))nr=nhor-1-int(xcenter-0.5)
        if(nr.gt.nver-1-int(ycenter-0.5))nr=nver-1-int(ycenter-0.5)
        write(6,15)xcenter,ycenter,nr
        write(17,15)xcenter,ycenter,nr
15      format(2f14.6,i5)
        rnr=nr
        pminhor=-nr+1
        pminver=-nr+1
        if(isym.eq.1)pminhor=1
        if(isym.eq.2)pminhor=1
        if(isym.eq.2)pminver=1

c
c       ***************************************************************
c
c
c       Convert experimental image to (2nr*2nr) size image centered
c       around (xcenter,ycenter)
c       ***********************************************************
c
        do 70 iix=-nr+1,nr
        do 65 iiy=-nr+1,nr
        x=iix-0.5+xcenter
        y=iiy-0.5+ycenter
        ix=int(x)
        iy=int(y)
        target0(iiy,iix)=(1.+ix-x)*
     *      ( (1.+iy-y)*exppic(iy,ix)+(y-iy)*exppic(iy+1,ix) ) +
     *      (x-ix)*
     *      ( (1.+iy-y)*exppic(iy,ix+1)+(y-iy)*exppic(iy+1,ix+1) )
        target(iiy,iix)=0.
65      continue
70      continue
c
        call rotate(target0,rot,nr)
        if(isym.ne.2)goto 81
        do 80 ix=1,nr
        do 75 iy=1,nr
        target(iy,ix)=target0(iy,ix)+target0(1-iy,ix)+target0(iy,1-ix)+
     *      target0(1-iy,1-ix)
75      continue
80      continue
81      continue
        if(isym.ne.1)goto 88
        do 87 ix=1,nr
        do 85 iy=-nr+1,nr
        target(iy,ix)=target0(iy,ix)+target0(iy,1-ix)
85      continue
87      continue
88      continue
        if(isym.ne.0)goto 78
        do 77 ix=-nr+1,nr
        do 76 iy=-nr+1,nr
        target(iy,ix)=target0(iy,ix)
76      continue
77      continue
78      continue
        maxangle=359
        if(isym.eq.1)maxangle=179
        if(isym.eq.2)maxangle=89
c
c       Normalisation of target picture
c       *******************************
c
        sum=0.
        do 310 k=pminver,nr
        do 305 l=pminhor,nr
        sum=sum+target(k,l)
305     continue
310     continue
        open(unit=10,file='it_target'//ci4//'.dat',status='unknown')
        do 340 k=pminver,nr
        do 335 l=pminhor,nr
        target(k,l)=target(k,l)/sum
335     continue
96      format(2000e14.5)
340     continue
        write(17,341)sum
        write(6,341)sum
341     format(e14.7)
c
c
        do 343 i=-nr2+1,nr2
        do 342 j=-nr2+1,nr2
        targetx(i,j)=0.
342     continue
343     continue
c
        do 347 i=-nr+1,nr
        do 344 j=-nr+1,nr
        ri=i
        rj=j
        if(sqrt(ri**2+rj**2).lt.nr)targetx(i,j)=target(i,j)
344     continue
347     continue
        do 348 i=-nr2+1,nr2
        write(10,96)(targetx(i,j),j=-nr2+1,nr2)
348     continue
        close(unit=10)
c




c       Extraction of the radial and the radially dependent angular
c       distribution for the target picture
c       ***********************************************************
c
        do 350 i=1,2*nr
        do 345 j=1,2*nr
        target2(i,j)=target(i-nr,j-nr)
345     continue
350     continue
c
        call radialdist(1,nr,rnr,rnr,nmax,nmax,
     *       target2,ang2drpic,isym)
c
        call separate(nr,ang2drpic,r2dexp,ang2dexp,isym)
c
c        do 172 i=1,nr
c        write(11,171)(1.e6*r2dexp(i)*ang2dexp(i,j),j=0,maxangle)
c172     continue
c
        if(ihf.eq.0)goto 800
c       **************************************************************
c
c       Abel inversion by the Fourier-Hankel method
c       *******************************************
c
        do 98 i=1,2*nr
        do 97 j=1,2*nr
        picinv(i,j)=target(i-nr,j-nr)
97      continue
98      continue
c
        call fh(2*nr,picinv)
c
c       Removal of some of the centerline noise
c       ***************************************
c
        do 103 i=1,2*nr
c        picinv(i,nr)=picinv(i,nr-1)
c        picinv(i,nr+1)=picinv(i,nr+2)
103     continue
c
        do 95 i=1,2*nr
        write(14,96)(1.e6*picinv(i,j),j=1,2*nr)
95      continue
c96      format(1000f12.4)
c
c       Extraction of the radial and the radially dependent
c       angular distribution from the Fourier-Hankel inversion
c       ******************************************************
c
c       N.B. The separation of ang2drpic into fr*ftheta is done so
c       that the sum over the ftheta(i,j) = 1 for a given radius i.
c
        call radialdist(1,nr,rnr,rnr,nmax,nmax,
     *       picinv,ang2drpic,isym)
c
        call separate2(nr,ang2drpic,fr,ftheta,isym)
c
c       Normalisation of the radial distribution so the 3d integral = 1
c       ***************************************************************
c
800     continue
        if(ihf.ge.1)goto 811
c
        do 810 i=1,nr
        ri=i-0.5
        fr(i)=r2dexp(i)/2./pi/ri
        do 805 j=0,maxangle
        ftheta(i,j)=ang2dexp(i,j)
805     continue
810     continue
811     continue
        if(ihf.gt.1)goto 470
c
        call normalize3d(nr,fr,ftheta,isym)
c
        idummy=0
        sum1old=1.e10
        sum2old=1.e10
c
c       idummy is the number of times that the 3d --> 2d --> 3d iteration
c       has been performed
c
215     continue
c
c
        do 216 i=1,nr
c        write(25,171)(1.e6*fr(i)*ftheta(i,j),j=0,maxangle)
216     continue
c
c       projection of 2d image from 3d distribution
c       *******************************************
c
        do 300 k=pminver,nr
        do 290 l=pminhor,nr
c        do 300 k=-100,101,201
c        do 290 l=-100,101,201
        y=k-0.5
        x=l-0.5
c       alpha=atan(x/y)
c       r=sqrt(x**2+y**2)
c
        pic(k,l)=0.
        do 280 m=-nr+1,nr
        z=m-0.5
c       look up value of fr(i)*ftheta(i,j) for corresponding (x,y,z)
        dz=1.
        r3d=sqrt(x**2+y**2+z**2)
        if(r3d.ge.nr)goto 280
        theta=atan(sqrt(x**2+z**2)/y)
        if(theta.lt.0.)theta=theta+pi
        if(x.lt.0.)theta=2.*pi-theta
c
        if(r3d-int(r3d).gt.(0.5))ir3d=int(r3d)+1
        if(r3d-int(r3d).le.(0.5))ir3d=int(r3d)
        if(r3d.ge.(0.5).and.r3d.le.(nr-0.5))
     *      radial=(0.5-r3d+ir3d)*fr(ir3d)+(0.5+r3d-ir3d)*fr(ir3d+1)
        if(r3d.lt.(0.5))radial=fr(1)
        if(r3d.gt.(nr-0.5))radial=fr(nr)
c       MV labbook p. 95
c
        thetadeg=180.*theta/pi
        ithetadeg=int(thetadeg)
        if(ithetadeg.eq.maxangle)goto 270
        if(r3d.ge.(0.5).and.r3d.le.(nr-.5))
     *      angular=(0.5-r3d+ir3d)*
     *      ( (1.-thetadeg+ithetadeg)*ftheta(ir3d,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(ir3d,ithetadeg+1) )+
     *              (0.5+r3d-ir3d)*
     *      ( (1.-thetadeg+ithetadeg)*ftheta(ir3d+1,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(ir3d+1,ithetadeg+1) )
        if(r3d.lt.(0.5))angular=
     *      ( (1.-thetadeg+ithetadeg)*ftheta(1,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(1,ithetadeg+1) )
        if(r3d.gt.(nr-.5))angular=
     *      ( (1.-thetadeg+ithetadeg)*ftheta(nr,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(nr,ithetadeg+1) )
        goto 271
270     continue
        if(r3d.ge.(0.5).and.r3d.le.(nr-.5))
     *  angular=(0.5-r3d+ir3d)*ftheta(ir3d,ithetadeg)+
     *          (0.5+r3d-ir3d)*ftheta(ir3d+1,ithetadeg)
        if(r3d.lt.(0.5))angular=ftheta(1,ithetadeg)
        if(r3d.gt.(nr-.5))angular=ftheta(nr,ithetadeg)
271     continue
c
        pic(k,l)=pic(k,l)+radial*angular*dz
c        write(24,279)x,y,z,radial,angular,theta,pic(k,l)
279     format(3f10.3,e14.5,2f12.4,e14.5)
280     continue
290     continue
c        write(24,96)(1.e6*pic(k,l),l=pminhor,nr)
300     continue
c
c       Extraction of the radial and the radially dependent angular
c       distribution for the target picture
c       ***********************************************************
c
        do 351 i=1,2*nr
        do 346 j=1,2*nr
        pic2(i,j)=pic(i-nr,j-nr)
346     continue
351     continue
c
        call radialdist(1,nr,rnr,rnr,nmax,nmax,
     *       pic2,ang2drpic,isym)
c
        call separate(nr,ang2drpic,r2d,ang2d,isym)
c
c       **************************************************************
c
c       Compare the simulated image to the target image
c       ***********************************************
c
        sum1=0.
        sum2=0.
        do 410 k=pminver,nr
        do 400 l=pminhor,nr
        sum1=sum1+(target(k,l)-pic(k,l))**2
        if(target(k,l).gt.small)sum2=sum2+((target(k,l)-pic(k,l))**2)/
     *     target(k,l)
        if(target(k,l).le.small)sum2=sum2+((target(k,l)-pic(k,l))**2)/
     *     small
400     continue
410     continue
c        write(17,411)idummy,sum1/(4.*(nr**2)),sum2/(4.*(nr**2))
        write(6,411)idummy,sum1/(4.*(nr**2)),sum2/(4.*(nr**2))
411     format(i5,2e12.4)
c
        idummy=idummy+1
c
c       Determine if the iterations need to continue
c       ********************************************
c
        if(idummy.eq.itmax)goto 470
c       stop because the maximum number of iterations has been reached
        if(itermode.eq.2.and.sum1.gt.sum1old)goto 470
c       stop because the absolute sum difference exceeds the previous
c       best result
        if(itermode.eq.3.and.sum2.gt.sum2old)goto 470
c       stop because the relative sum difference exceeds the previous
c       best result
        sum1old=sum1
        sum2old=sum2

c       Apply corrections to the 3D distributions
c       *****************************************
c
        do 460 i=1,nr
        ri=i-0.5
        fr(i)=fr(i)+radfac*(r2dexp(i)-r2d(i))/2./pi/ri
        if(fr(i).lt.0.)fr(i)=0.
c        write(19,*)i,fr(i)
        do 450 j=0,maxangle
        ftheta(i,j)=ftheta(i,j)+angfac*(ang2dexp(i,j)-ang2d(i,j))
        if(ftheta(i,j).lt.0.)ftheta(i,j)=0.
450     continue
460     continue
        call normalize3d(nr,fr,ftheta,isym)
        goto 215
c
c       Output of 3D distribution to file 3dverdel.dat
c       **********************************************
c
470     continue
        open(unit=16,file='it_3dpol'//ci4//'.dat',status='unknown')
        do 170 i=1,nr
        write(16,171)(1.e6*fr(i)*ftheta(i,j),j=0,maxangle)
170     continue
        close(unit=16)
171     format(360f10.3)
        call radial3d(nr,fr,pr,ftheta,isym)
c        do 175 i=1,nr
c        write(19,176)i**2,pr(i)/(i-0.5)
c176     format(i8,e14.5)
c175     continue
c
c       Output of simulated image and residu of simulated image
c       *******************************************************
c
c        do 471 k=pminver,nr
c        write(12,96)(1.e6*pic(k,l),l=pminhor,nr)
c        write(21,96)(1.e6*(pic(k,l)-target(k,l)),l=pminhor,nr)
c471     continue
c        do 173 i=1,nr
c        write(13,171)(1.e6*r2d(i)*ang2d(i,j),j=0,maxangle)
c        write(18,171)(1.e6*(r2d(i)*ang2d(i,j)-r2dexp(i)*
c     *      ang2dexp(i,j)),j=0,maxangle)
c173     continue
c
c       Output of slice through 3D distribution to file inversie.dat
c       ************************************************************
c
        do 600 k=pminver,nr
        do 590 l=pminhor,nr
        y=k-0.5
        x=l-0.5
        r=sqrt(x**2+y**2)
        theta=atan(x/y)
        if(y.lt.0.)theta=theta+pi
        if((x.lt.0.).and.(y.ge.0.))theta=theta+2.*pi

c
        if(r-int(r).gt.(0.5))ir=int(r)+1
        if(r-int(r).le.(0.5))ir=int(r)
        if(r.ge.(0.5).and.r.le.(nr-0.5))
     *      radial=(0.5-r+ir)*fr(ir)+(0.5+r-ir)*fr(ir+1)
        if(r.lt.(0.5))radial=fr(1)
        if(r.gt.(nr-0.5))radial=0.
c       MV labbook p. 95
c
        thetadeg=180.*theta/pi
        ithetadeg=int(thetadeg)
        if(ithetadeg.eq.maxangle)goto 570
        if(r.ge.(0.5).and.r.le.(nr-.5))
     *      angular=(0.5-r+ir)*
     *      ( (1.-thetadeg+ithetadeg)*ftheta(ir,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(ir,ithetadeg+1) )+
     *              (0.5+r-ir)*
     *      ( (1.-thetadeg+ithetadeg)*ftheta(ir+1,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(ir+1,ithetadeg+1) )
        if(r.lt.(0.5))angular=
     *      ( (1.-thetadeg+ithetadeg)*ftheta(1,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(1,ithetadeg+1) )
        if(r.gt.(nr-.5))angular=
     *      ( (1.-thetadeg+ithetadeg)*ftheta(nr,ithetadeg)+
     *        (thetadeg-ithetadeg)*ftheta(nr,ithetadeg+1) )
        goto 571
570     continue
        if(r.ge.(0.5).and.r.le.(nr-.5))
     *  angular=(0.5-r+ir)*ftheta(ir,ithetadeg)+
     *          (0.5+r-ir)*ftheta(ir+1,ithetadeg)
        if(r.lt.(0.5))angular=ftheta(1,ithetadeg)
        if(r.gt.(nr-.5))angular=ftheta(nr,ithetadeg)
571     continue
        inversie(k,l)=radial*angular
590     continue
600     continue
        if(isym.eq.0)goto 620
        do 610 l=pminhor,nr
        do 605 k=pminver,nr
        inversie(k,1-l)=inversie(k,l)
605     continue
610     continue
        if(isym.eq.1)goto 620
        do 630 k=pminver,nr
        do 625 l=-nr+1,nr
        inversie(1-k,l)=inversie(k,l)
625     continue
630     continue
620     continue
c
        open(unit=22,file='it_3dcart'//ci4//'.dat',status='unknown')
        do 640 k=-nr+1,nr
        write(22,96)(1.e6*inversie(k,l),l=-nr+1,nr)
640     continue
        close(unit=22)
c
        goto 1111
c
1000    continue
        stop ' '
        end
c
c*********************************************************************
c*********************************************************************
c*********************************************************************
c
c
c
c
        subroutine center1(nrange,nradius,ixcenter,iycenter,nhor,nver,
     *     exppic,xcenter,ycenter)
        real*4 exppic,xcenter,ycenter
        real*4 summax,sumsym,zmin,znul,zplus
        integer nrange,nradius,ixcenter,iycenter,nhor,nver,ix,iy,iix,
     *     iiy,nmax
        parameter(nmax=1250)
        dimension exppic(1:nmax,1:nmax),sumsym(-50:50,
     *     -50:50)
c
c       (i) Rough determination of center
c
        if(ixcenter-nrange-nradius.lt.1)nradius=ixcenter-nrange-1
        if(iycenter-nrange-nradius.lt.1)nradius=iycenter-nrange-1
        if(ixcenter+nrange+nradius.gt.nhor)
     *     nradius=nhor-ixcenter-nrange
        if(iycenter+nrange+nradius.gt.nver)
     *     nradius=nver-iycenter-nrange
c
15      continue
        summax=1.e10
        if(nrange.ge.50)nrange=50
c
        do 25 iy=-nrange,nrange
        do 20 ix=-nrange,nrange
        sumsym(iy,ix)=0.
c        do 40 iiy=1,nradius
c        do 35 iix=1,nradius
        do 40 iiy=60,nradius
        do 35 iix=60,nradius
        sumsym(iy,ix)=sumsym(iy,ix)
     *    +(exppic(iycenter+iy+iiy,ixcenter+ix+iix)-
     *     exppic(iycenter+iy-iiy,ixcenter+ix-iix))**2
c
35      continue
40      continue
        if(sumsym(iy,ix).lt.summax)iysum=iy
        if(sumsym(iy,ix).lt.summax)ixsum=ix
        if(sumsym(iy,ix).lt.summax)summax=sumsym(iy,ix)
20      continue
25      continue
        iycenter=iycenter+iysum
        ixcenter=ixcenter+ixsum
c
        if(iycenter-nrange-nradius.lt.1)nradius=iycenter-nrange-1
        if(ixcenter-nrange-nradius.lt.1)nradius=ixcenter-nrange-1
        if(iycenter+nrange+nradius.gt.nver)
     *     nradius=nver-iycenter-nrange
        if(ixcenter+nrange+nradius.gt.nhor)
     *     nradius=nhor-ixcenter-nrange
        if(abs(iysum).eq.nrange.or.abs(ixsum).eq.nrange)goto 15
c
c       (ii) Precise determination of center
c
c       determine ycenter
c
        zmin=sumsym(iysum-1,ixsum-1)+sumsym(iysum-1,ixsum)
     *      +sumsym(iysum-1,ixsum+1)
        znul=sumsym(iysum,ixsum-1)+sumsym(iysum,ixsum)
     *      +sumsym(iysum,ixsum+1)
        zplus=sumsym(iysum+1,ixsum-1)+sumsym(iysum+1,ixsum)
     *      +sumsym(iysum+1,ixsum+1)
        ycenter=(zmin-zplus)/2./(zmin+zplus-2.*znul)+iycenter
c
c       bepaling xcenter
c
        zmin=sumsym(iysum-1,ixsum-1)+sumsym(iysum,ixsum-1)
     *      +sumsym(iysum+1,ixsum-1)
        znul=sumsym(iysum-1,ixsum)+sumsym(iysum,ixsum)
     *      +sumsym(iysum+1,ixsum)
        zplus=sumsym(iysum-1,ixsum+1)+sumsym(iysum,ixsum+1)
     *      +sumsym(iysum+1,ixsum+1)
        xcenter=(zmin-zplus)/2./(zmin+zplus-2.*znul)+ixcenter
c
c        write(17,53)xcenter,ycenter
53      format(2f14.5,/)
c
        return
        end
c
c
c
c
c
        subroutine center2(nrange,nradius,ixcenter,iycenter,nhor,nver,
     *     exppic,xcenter,ycenter)
        integer nrange,nradius,ixcenter,iycenter,nhor,nver,innerradius,
     *     ixc,iyc,ixsum,iysum,nmax
        real*4exppic,xcenter,ycenter
        real*4r2drmax,xc,yc,sumsym,r2dr,xmin,xnul,xplus,ymin,ynul,
     *     yplus,ang2dr,angsum
        parameter(nmax=1250)
        dimension exppic(1:nmax,1:nmax),sumsym(-50:50,
     *     -50:50),ang2dr(1:nmax/2,0:360)
c
        if(ixcenter-nrange-nradius.lt.1)nradius=ixcenter-nrange-1
        if(iycenter-nrange-nradius.lt.1)nradius=iycenter-nrange-1
        if(ixcenter+nrange+nradius.gt.nhor)
     *     nradius=nhor-ixcenter-nrange
        if(iycenter+nrange+nradius.gt.nver)
     *     nradius=nver-iycenter-nrange
        innerradius=60
        r2drmax=0.
c
c       (i) Rough determination of center
c
        do 25 ixc=-nrange,nrange
        do 20 iyc=-nrange,nrange
        xc=ixcenter+ixc
        yc=iycenter+iyc
        sumsym(iyc,ixc)=0.
c
c       calculate the radial distribution between an innerradius and
c       radius
c
        call radialdist(innerradius,nradius,xc,yc,nmax,nmax,exppic,
     *      ang2dr,0)
c
        do 51 i=innerradius,nradius
        angsum=0.
        do 55 j=0,359
        angsum=angsum+ang2dr(i,j)
55      continue
        r2dr=angsum
        if(r2dr.gt.sumsym(iyc,ixc))sumsym(iyc,ixc)=r2dr
51      continue
c
        if(sumsym(iyc,ixc).gt.r2drmax)ixsum=ixc
        if(sumsym(iyc,ixc).gt.r2drmax)iysum=iyc
        if(sumsym(iyc,ixc).gt.r2drmax)r2drmax=sumsym(iyc,ixc)
c
20      continue
25      continue
c
c       (ii) Precise determination of center
c
c       determine ycenter
c
        ymin=sumsym(iysum-1,ixsum-1)+sumsym(iysum-1,ixsum)
     *      +sumsym(iysum-1,ixsum+1)
        ynul=sumsym(iysum,ixsum-1)+sumsym(iysum,ixsum)
     *      +sumsym(iysum,ixsum+1)
        yplus=sumsym(iysum+1,ixsum-1)+sumsym(iysum+1,ixsum)
     *      +sumsym(iysum+1,ixsum+1)
        ycenter=(ymin-yplus)/2./(ymin+yplus-2.*ynul)+iycenter+iysum
c
c       determine xcenter
c
        xmin=sumsym(iysum-1,ixsum-1)+sumsym(iysum,ixsum-1)
     *      +sumsym(iysum+1,ixsum-1)
        xnul=sumsym(iysum-1,ixsum)+sumsym(iysum,ixsum)
     *      +sumsym(iysum+1,ixsum)
        xplus=sumsym(iysum-1,ixsum+1)+sumsym(iysum,ixsum+1)
     *      +sumsym(iysum+1,ixsum+1)
        xcenter=(xmin-xplus)/2./(xmin+xplus-2.*xnul)+ixcenter+ixsum
c
c        write(17,53)xcenter,ycenter
53      format(2f14.5)
        return
        end
c
c
c
c
        subroutine center3(nradius,nhor,nver,ixcenter,iycenter,exppic,
     *     xcenter,ycenter)
        real*4 exppic,xcenter,ycenter
        real*4 sum1,sum2,sum3
        integer nhor,nver,ixcenter,iycenter,nradius
        parameter(nmax=1250)
        dimension exppic(1:nmax,1:nmax)
c
        sum1=0.
        sum2=0.
        sum3=0.
        do 100 i=ixcenter-nradius,ixcenter+nradius
        do 90 j=iycenter-nradius,iycenter+nradius
        sum1=sum1+exppic(j,i)*i
        sum2=sum2+exppic(j,i)*j
        sum3=sum3+exppic(j,i)
90      continue
100     continue
        xcenter=sum1/sum3
        ycenter=sum2/sum3
c
        return
        end

c
c
c

c
c
        subroutine radialdist(innerradius,nradius,xc,yc,nhor,
     *       nver,exppic,ang2dr,isym)
        integer innerradius,nradius,maxangle,isym,nmax
        real*4xc,yc,exppic,ang2dr,pi,small
        parameter(nmax=1250)
        dimension exppic(1:nhor,1:nver),ang2dr(1:nmax/2,0:360)
c
c       calculate the radial distribution between an radiusinner and
c       radius
c
        pi=4.*atan(1.)
        small=1.e-10
        maxangle=359
        if(isym.eq.1)maxangle=179
        if(isym.eq.2)maxangle=89
c
        do 50 i=innerradius,nradius
c
        ri=i-0.5
c
        do 49 j=0,maxangle
        rj=j+small
        x=xc+ri*sin(rj*pi/180.)
        y=yc+ri*cos(rj*pi/180.)
        if(x-int(x).gt.(0.5))ix=int(x)+1
        if(x-int(x).le.(0.5))ix=int(x)
        if(y-int(y).gt.(0.5))iy=int(y)+1
        if(y-int(y).le.(0.5))iy=int(y)
        if(y.ge.(0.5).and.y.le.(nver-.5).and.x.ge.(0.5).and.x.le.
     *     (nhor-.5))ang2dr(i,j)=
     *      (0.5+ix-x)*
     *      ( (0.5+iy-y)*exppic(iy,ix)+(0.5+y-iy)*exppic(iy+1,ix) ) +
     *      (0.5+x-ix)*
     *      ( (0.5+iy-y)*exppic(iy,ix+1)+(0.5+y-iy)*exppic(iy+1,ix+1) )
        if(x.lt.(0.5).and.y.ge.(0.5).and.y.le.(nver-.5))
     *      ang2dr(i,j)=
     *      ( (0.5+iy-y)*exppic(iy,ix+1)+(0.5+y-iy)*exppic(iy+1,ix+1) )
        if(x.gt.(nhor-.5).and.y.ge.(0.5).and.y.le.(nver-.5))
     *      ang2dr(i,j)=
     *      ( (0.5+iy-y)*exppic(iy,ix)+(0.5+y-iy)*exppic(iy+1,ix) )
        if(y.lt.(0.5).and.x.ge.(0.5).and.x.le.(nhor-.5))
     *      ang2dr(i,j)=
     *      ( (0.5+ix-x)*exppic(iy+1,ix)+(0.5+x-ix)*exppic(iy+1,ix+1) )
        if(y.gt.(nver-.5).and.x.ge.(0.5).and.x.le.(nhor-.5))
     *      ang2dr(i,j)=
     *      ( (0.5+ix-x)*exppic(iy,ix)+(0.5+x-ix)*exppic(iy,ix+1) )
        if(x.lt.(0.5).and.y.lt.(0.5))ang2dr(i,j)=exppic(iy+1,ix+1)
        if(x.lt.(0.5).and.y.gt.(nver-.5))ang2dr(i,j)=exppic(iy,1)
        if(x.gt.(nhor-.5).and.y.lt.(0.5))ang2dr(i,j)=exppic(1,ix)
        if(x.gt.(nhor-.5).and.y.gt.(nver-.5))ang2dr(i,j)=
     *      exppic(iy,ix)
49      continue
c        write(25,51)(1.e6*ang2dr(i,j),j=0,maxangle)
50      continue
51      format(1024f12.4)
52      format(4f10.3,2i5,e14.7)
        return
        end
c
c
c

c
        subroutine fh(nr,pic)
c
        real*4pic,pi,rnr,alpha,picinv,data,rnpic,xpits,costheta,
     *     temp,inv
        integer nr,i,j,k,npic,nalpha,kil,nmax,nmax2
        parameter(nmax=1250)
        dimension pic(1:nmax,1:nmax),kil(256,0:255),inv(0:511),
     *     picinv(1:nmax,1:1024),data(1:1024)
c
ccc        open(unit=7,file='datain.dat',status='old')
c
        pi=4.*atan(1.)
        rnr=nr
        alpha=log(rnr)/log(2.)
        nalpha=int(alpha)+1
        npic=2**nalpha
        rnpic=npic
c
        do 5 i=1,nr
ccc        read(7,*)(pic(i,j),j=1,nr)
c       de data wordt op dit moment kolom per kolom ingelezen
5       continue
10      format(1024f12.4)
        do 15 i=1,nr
        do 12 k=1,(npic-nr)/2
12      picinv(i,k)=0.
        do 13 k=1,nr
13      picinv(i,(npic-nr)/2+k)=pic(i,k)
        do 14 k=1,(npic-nr)/2
14      picinv(i,(npic+nr)/2+k)=0.
15      continue
c
c
        xpits=pi/npic
        do 17 i=1,npic/2
        costheta=cos((npic/2-i+0.5)*xpits)
        do 18 l=0,npic/2-1
        kil(i,l)=int(costheta*l+0.5)
18      continue
17      continue
c
        do 100 i=1,nr
c       abel inversie voor nr lijnen
c        do 100 i=210,210
c
c       Fourier transformatie
c
        do 20 j=1,npic/2
        data(npic+2*j-1)=picinv(i,j)
        data(npic+2*j)=0.
20      continue
        do 21 j=npic/2+1,npic
        data(2*j-npic-1)=picinv(i,j)
        data(2*j-npic)=0.
21      continue
        call four1(data,npic,1)
        do 25 j=1,npic
        data(2*j-1)=data(2*j-1)/rnpic
        data(2*j)=0.
25      continue
c
c       Inverse Hankel transformatie
c
        data(1)=0.
        data(2)=0.
        nmax2=npic/2-1
        do 30 j=1,nmax2
        ip1=j+1
        dr=data(2*ip1-1)*j
        data(2*ip1-1)=dr
        data(2*ip1)=0.
        data(2*npic-(2*ip1-1)+2)=dr
        data(2*npic-2*ip1+2)=0.
30      continue
        data(npic+1)=data(npic+1)*npic/2
        data(npic+2)=0.
        call four1(data,npic,1)
c
        do 50 l=0,npic/2-1
        temp=0.
        do 40 j=1,npic/2
        temp=temp+data(2*kil(j,l)+1)
40      continue
        inv(l)=temp/rnpic
50      continue
        do 60 l=1,nr/2
60      pic(i,l)=inv(nr/2-l)
        do 61 l=1,nr/2
61      pic(i,l+nr/2)=inv(l-1)
c
99      continue
100     continue
110     continue
c
        return
        end
c
c
c
c
c
        SUBROUTINE four1(data,nn,isign)
        INTEGER isign,nn
        real*4data(2*nn)
        INTEGER i,istep,j,m,mmax,n
        real*4tempi,tempr
        DOUBLE PRECISION theta,wi,wpi,wpr,wr,wtemp
        n=2*nn
        j=1
        do 11 i=1,n,2
          if(j.gt.i)then
            tempr=data(j)
            tempi=data(j+1)
            data(j)=data(i)
            data(j+1)=data(i+1)
            data(i)=tempr
            data(i+1)=tempi
          endif
          m=n/2
1         if ((m.ge.2).and.(j.gt.m)) then
            j=j-m
            m=m/2
          goto 1
          endif
          j=j+m
11      continue
        mmax=2
2       if (n.gt.mmax) then
          istep=2*mmax
          theta=6.28318530717959d0/(isign*mmax)
          wpr=-2.d0*sin(0.5d0*theta)**2
          wpi=sin(theta)
          wr=1.d0
          wi=0.d0
          do 13 m=1,mmax,2
            do 12 i=m,n,istep
              j=i+mmax
              tempr=sngl(wr)*data(j)-sngl(wi)*data(j+1)
              tempi=sngl(wr)*data(j+1)+sngl(wi)*data(j)
              data(j)=data(i)-tempr
              data(j+1)=data(i+1)-tempi
              data(i)=data(i)+tempr
              data(i+1)=data(i+1)+tempi
12          continue
            wtemp=wr
            wr=wr*wpr-wi*wpi+wr
            wi=wi*wpr+wtemp*wpi+wi
13        continue
          mmax=istep
        goto 2
        endif
        return
        END
C       (C) Copr. 1986-92 Numerical Recipes Software v1]3"iA#.
c
c
c
        subroutine separate(nr,ang2dr,fr,ftheta,isym)
        integer nr,i,j,isym,maxangle
        real*4ang2dr,fr,ftheta,small,pi
        parameter(nmax=1250)
        dimension ang2dr(1:nmax/2,0:360),fr(1:nmax/2),
     *      ftheta(1:nmax/2,0:360)
c
        small=1.e-10
        maxangle=359
        if(isym.eq.1)maxangle=179
        if(isym.eq.2)maxangle=89
c
        pi=4.*atan(1.)
        do 120 i=1,nr
        sum2=0.
        do 110 j=0,maxangle
        if(ang2dr(i,j).lt.0.)ang2dr(i,j)=0.
        sum2=sum2+ang2dr(i,j)*pi/180.
110     continue
        if(sum2.lt.small)sum2=small
        fr(i)=sum2
        do 115 j=0,maxangle
        ftheta(i,j)=ang2dr(i,j)/fr(i)
115     continue
120     continue
        return
        end
c
c
c
c
c
        subroutine separate2(nr,ang2dr,fr,ftheta,isym)
c
c       This subroutine is a special version of subroutine separate,
c       in which the angular distribution is taken out of the problem.
c       This is used in the first iteration, since the centerline noise
c       from the Abel transform causes problems ('bad' distribution,
c       even though the image is already close).
c
        integer nr,i,j,isym,maxangle,nmax
        real*4ang2dr,fr,ftheta,small,pi
        parameter(nmax=1250)
        dimension ang2dr(1:nmax/2,0:360),fr(1:nmax/2),
     *     ftheta(1:nmax/2,0:360)
c
        small=1.e-10
        pi=4.*atan(1.)
        maxangle=359
        if(isym.eq.1)maxangle=179
        if(isym.eq.2)maxangle=89
c
        do 120 i=1,nr
        sum2=0.
        do 110 j=0,maxangle
        if(ang2dr(i,j).lt.0.)ang2dr(i,j)=0.
        sum2=sum2+ang2dr(i,j)*pi/180.
110     continue
        if(sum2.lt.small)sum2=small
        fr(i)=sum2
        do 115 j=0,maxangle
        ftheta(i,j)=ang2dr(i,j)/fr(i)
ccc        ftheta(i,j)=1./360.
115     continue
        ftheta(i,maxangle+1)=ftheta(i,0)
120     continue
ccc        call fourier(nr,ftheta)
        return
        end

        subroutine normalize3d(nr,fr,ftheta,isym)
        integer nr,i,j,maxangle,isym,nmax
        real*4sum,ri,rj,dr,dtheta,fr,ftheta,pi
        parameter(nmax=1250)
        dimension fr(1:nmax/2),ftheta(1:nmax/2,0:360)
c
        pi=4.*atan(1.)
        maxangle=359
        if(isym.eq.1)maxangle=179
        if(isym.eq.2)maxangle=89
c
        sum=0.
        do 150 i=1,nr
        do 140 j=0,maxangle
        rj=j
        ri=i-0.5
        dr=1.
        dtheta=1.*pi/180.
        sum=sum+pi*fr(i)*(ri**2)*ftheta(i,j)*abs(sin(rj*pi/180.))*dr*
     *     dtheta
140     continue
150     continue
        sum=abs(sum)
        do 160 i=1,nr
        fr(i)=fr(i)/sum
160     continue
        do 130 i=1,nr
c        write(24,125)(1.e6*fr(i)*ftheta(i,j),j=0,maxangle)
130     continue
125     format(360f14.6)

        return
        end
c
c
c
c
        subroutine radial3d(nr,fr,pr,ftheta,isym)
        integer nr,i,j,maxangle,isym,nmax
        real*4 sum,ri,rj,dtheta,fr,ftheta,pi,pr
        parameter(nmax=1250)
        dimension fr(1:nmax/2),ftheta(1:nmax/2,0:360),pr(1:nmax/2)
c
        pi=4.*atan(1.)
        maxangle=359
        if(isym.eq.1)maxangle=179
        if(isym.eq.2)maxangle=89
c
        do 150 i=1,nr
        sum=0.
        do 140 j=0,maxangle
        rj=j
        ri=i-0.5
        dtheta=1.*pi/180.
        sum=sum+pi*fr(i)*(ri**2)*ftheta(i,j)*abs(sin(rj*pi/180.))*
     *     dtheta
140     continue
        pr(i)=abs(sum)
150     continue
        return
        end
c
c
c
c
c
c
c
        subroutine fourier(nr,ftheta)
        real*4 ftheta
        real*8 pi,fourierc,fouriers,domega,dx,omegaj
        integer i,j,nmax
        parameter(nmax=1250)
        dimension ftheta(1:nmax/2,0:360),fourierc(-100:100),
     *     fouriers(-100:100)
c
        pi=4.*atan(1.)
        domega=.005
        dx=1.
c
        do 100 i=1,nr
c
        do 20 j=-50,50
        fourierc(j)=0.
        fouriers(j)=0.
        omegaj=domega*j
        do 30 k=0,359
        fourierc(j)=fourierc(j)+(1./sqrt(2.*pi))*ftheta(i,k)*
     *      dcos(omegaj*(k-180.))*dx
        fouriers(j)=fouriers(j)+(1./sqrt(2.*pi))*ftheta(i,k)*
     *      dsin(omegaj*(k-180.))*dx
30      continue
20      continue
c
        do 50 k=0,359
        rk=k
        transc=0.
        transs=0.
        do 45 j=-50,50
        roloff=1.
        omegaj=domega*j
        transc=transc+roloff*(1./sqrt(2.*pi))*(fourierc(j)*
     *      dcos(omegaj*(rk-180.))
     *      +fouriers(j)*dsin(omegaj*(rk-180.)))*domega
        transs=transs+roloff*(1./sqrt(2.*pi))*(-fourierc(j)*
     *      dsin(omegaj*(rk-180.))
     *      +fouriers(j)*dcos(omegaj*(rk-180.)))*domega
45      continue
        ftheta(i,k)=sqrt(transc**2+transs**2)
50      continue
c
100     continue
        do 130 i=1,nr
c        write(24,125)(1.e3*ftheta(i,j),j=0,359)
130     continue
125     format(360f14.6)

        return
        end

        subroutine rotate(target,rot,nr)
        real*4 target,target2,rot,pi
        integer nmax,nr
        parameter(nmax=1250)
        dimension target(-nmax/2:nmax/2,-nmax/2:nmax/2),
     *     target2(-nmax/2:nmax/2,-nmax/2:nmax/2)
c
c       alpha=-0.06
        pi=4.*atan(1.)
        alpha=-rot/360.*2.*pi
        do 100 i=-nr+1,nr
        do 90 j=-nr+1,nr
        x=i-0.5
        y=j-0.5
        xp=cos(alpha)*x+sin(alpha)*y+0.5
        yp=-sin(alpha)*x+cos(alpha)*y+0.5
        target2(i,j)=
     *     (int(xp)+1.-xp)*(int(yp)+1.-yp)*target(int(xp),int(yp))+
     *     (int(xp)+1.-xp)*(yp-int(yp))*target(int(xp),int(yp)+1)+
     *     (xp-int(xp))*(yp-int(yp))*target(int(xp)+1,int(yp)+1)+
     *     (xp-int(xp))*(int(yp)+1.-yp)*target(int(xp)+1,int(yp))
        if(target2(i,j).lt.0.)target2(i,j)=0.
90      continue
100     continue
        do 200 i=-nr+1,nr
        do 190 j=-nr+1,nr
        target(i,j)=target2(i,j)
190     continue
200     continue
c
c        write(6,210)
c210     format(' rotated')
        return
        end
