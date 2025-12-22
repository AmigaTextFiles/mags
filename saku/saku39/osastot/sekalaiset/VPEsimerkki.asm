.include 'tao'

tool 'demo/Saku39/VPEsimerkki',VP,TF_MAIN,8192,0

ent -:-

qcall lib/malloc,(4:p0)

repeat
   cpy 7,i1
   for i1
      qcall lib/rand,(-:i2)
      cpy (i2 % 39)+1,i2
      printf"%d\n",i2
   next i1

   printf"Arvotaanko uudestaan? (0=Ei, Muut numerot kuin 0=Kylla)\n"
   scanf"%d",p0
until [p0]=0

qcall lib/free,(p0:-)
qcall lib/exit,(0:-)

ret

toolend
.end
