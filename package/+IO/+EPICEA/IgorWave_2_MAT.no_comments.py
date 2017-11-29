# -*- coding: utf-8 -*-
"""
Created on Tue Nov  1 09:30:37 2016

@author: tbarillot
"""
# Import the needed packages:
import numpy as np
import scipy.io as sio
import glob
import os
import igor.binarywave as ibw
import argparse

class ConfigParser():
    def __init__(self,path):
        self.path=path
        f=open(self.path,'r')
        self.cfg={}
        for line in f:
            ind=line.find(':cfg:')
            relevant=line[ind+5:]
            if ';' in relevant:
                split=relevant.split(';')
                name=split[0]
                value=split[1:]
            elif '=' in relevant:
                try:
                    name,value=tuple(relevant.split('='))
                    name='nan'
                    value=np.float32(value)
                except:
                    value=np.nan
            else:
                raise ValueError('Not recognized config entry')
            self.cfg[name]=value
        f.close()

    def GetValue(self,name,varname='VAL',default=None):
        value=self.cfg[name]
        if isinstance(value,list):
            for v in value:
                split=v.split(':')
                if split[0]==varname:
                    return np.float32(split[1])
            return default
        else:
            return value


class Client():
    
    def __init__(self,args):
        self.args=args
        
        
        self.maxionhits=4 if self.args.max_ions is None else self.args.max_ions
        self.maxelecthits=2 if self.args.max_electrons is None else self.args.max_electrons
        
        self.basepath='***CHANGE_ME***' if self.args.base_path is None else self.args.base_path
        self.data_path=os.path.join(self.basepath,'RawData',self.args.name,'rawdata')
        
        if self.args.save_path is None:
            self.save_path=os.path.join(self.basepath,'ProcessedData',self.args.name)
        else:
            self.save_path=os.path.join(self.args.save_path)
            
        self.cfg={}
        self.LoadCfg()       
 
#################################################################
   
    def LoadCfg(self):
        
        ## -- load configuration file --
        cfgparser=ConfigParser(os.path.join(self.data_path,'..','cfg.txt'))
        
        self.cfg['ifu']=cfgparser.GetValue('psd:ions:u_conv_factor_in_mm_per_ps')
        self.cfg['ifv']=cfgparser.GetValue('psd:ions:v_conv_factor_in_mm_per_ps')
        self.cfg['ifw']=cfgparser.GetValue('psd:ions:w_conv_factor_in_mm_per_ps')
        self.cfg['efu']=cfgparser.GetValue('psd:electrons:u_conv_factor_in_mm_per_ps')
        self.cfg['efv']=cfgparser.GetValue('psd:electrons:v_conv_factor_in_mm_per_ps')

        self.cfg['ioffsetx']=cfgparser.GetValue('psd:ions:x_offset_in_mm')
        self.cfg['ioffsety']=cfgparser.GetValue('psd:ions:y_offset_in_mm')
        self.cfg['eoffsetx']=cfgparser.GetValue('psd:electrons:x_offset_in_mm')
        self.cfg['eoffsety']=cfgparser.GetValue('psd:electrons:y_offset_in_mm')

        self.cfg['isizex']=cfgparser.GetValue('psd:ions:x_size_in_mm')
        self.cfg['isizey']=cfgparser.GetValue('psd:ions:y_size_in_mm')
        self.cfg['esizex']=cfgparser.GetValue('psd:electrons:x_size_in_mm')
        self.cfg['esizey']=cfgparser.GetValue('psd:electrons:y_size_in_mm')

#################################################################
    
    def Run(self):
        
        rawdata_list=glob.glob(os.path.join(self.data_path,'tm_*.ibw'))
        rawsig_list=glob.glob(os.path.join(self.data_path,'sg_*.ibw'))
        
        Evt_Sig_list=[]
        Evt_Data_list=[]
        
        MIH=self.maxionhits
        MEH=self.maxelecthits
        
        ## -- Chunck the raw data in events -- 
        index=0
        
        maxFile=len(rawdata_list) if self.args.n_files is None else self.args.n_files
        
        for j in range(0,maxFile):
            DataArray=ibw.load(rawdata_list[j])
            SigArray=ibw.load(rawsig_list[j])
            Data=np.array(DataArray['wave']['wData'])
            Sig=np.array(SigArray['wave']['wData'])

            del DataArray
            del SigArray
            
            MaxNions=0
            MaxNelectrons=0
            index1=0
            
            maxInd=len(Sig) if self.args.max_n is None else self.args.max_n
            for i in range(1,maxInd):
                if Sig[i]<Sig[i-1]:
                    index2=i-1  
                    tmpSig=np.concatenate(([-1],Sig[index1:index2+1]))
                    Evt_Sig_list.append(tmpSig)
                    tmpData=np.concatenate(([index],Data[index1:index2+1]))
                    Evt_Data_list.append(tmpData)
                    
                    Nions=len(np.argwhere(Sig[index1:index2+1]==2))
                    Nelectrons=len(np.argwhere(Sig[index1:index2+1]==12))
                    
                    MaxNions=max(Nions,MaxNions)  
                    MaxNelectrons=max(Nelectrons,MaxNelectrons)                    
 
                    index+=1
                    index1=i

            del Data
            del Sig
            
        Nevt=len(Evt_Data_list)
        print Nevt
       
        ## -- Fill lists with ions and electrons measurements -- ##

        evt_idx=np.zeros((Nevt),dtype=np.int32)    
        evt_rand=np.zeros((Nevt),dtype=np.bool_)     
        evt_ts=np.zeros((Nevt),dtype=np.int64)*np.nan   
        
        itofp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan

        # Initialize the empty X, Y matrices:
        iXuvp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan
        iXuwp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan
        iXvwp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan
        iYuvp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan
        iYuwp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan
        iYvwp=np.zeros((Nevt,MIH),dtype=np.float32)*np.nan
        eXp=np.zeros((Nevt,MEH),dtype=np.float32)*np.nan
        eYp=np.zeros((Nevt,MEH),dtype=np.float32)*np.nan
        eRp=np.zeros((Nevt,MEH),dtype=np.float32)*np.nan
        ePhip=np.zeros((Nevt,MEH),dtype=np.float32)*np.nan


    
        count=0
        for i in range(0,Nevt):
           if i%10000 == 0:
               print i
           
           if len(Evt_Sig_list[i])<=2:
               continue
               
          
           evt=[Evt_Sig_list[i],Evt_Data_list[i]]
           
           #Extract general information
           ind=self.GetIndex(evt)
           if ind is None:
               continue
               
           evt_idx[count]=ind
           
           isrand=any(Evt_Sig_list[i]==18)
           evt_rand[count]=isrand
           evt_ts[count]=self.GetTimestamp(evt)
           
           def insert(array,index,data):
               ind=min([array.shape[1],len(data)])
               array[index,:ind]=data[:ind]
           
           #Extract ion information
           if MIH>0:
               itof, iXuv, iXuw, iXvw, iYuv, iYuw, iYvw = self.GetIons(evt)
               
               insert(itofp,count,itof)
               insert(iXuvp,count,iXuv)
               insert(iXuwp,count,iXuw)
               insert(iXvwp,count,iXvw)
               insert(iYuvp,count,iYuv)
               insert(iYuwp,count,iYuw)
               insert(iYvwp,count,iYvw)
           
           #Extract electron information, or copy previous information for randoms
           if MEH>0:
               if isrand and i>0:
                   eXp[count]=eXp[count-1]
                   eYp[count]=eYp[count-1]
                   eRp[count]=eRp[count-1]
                   ePhip[count]=ePhip[count-1]
              
               else:
                   eX, eY, eR, ePhi = self.GetElectrons(evt)
                   insert(eXp,count,eX)
                   insert(eYp,count,eY)
                   insert(eRp,count,eR)
                   insert(ePhip,count,ePhi)
              
           count+=1
               
        print 'process done'
 
        if not os.path.exists(self.save_path):
            os.makedirs(self.save_path)
        

        data={'idx':evt_idx[:count],\
              'itof':itofp[:count], \
              'iXuv':iXuvp[:count], \
              'iXuw':iXuwp[:count], \
              'iXvw':iXvwp[:count], \
              'iYuv':iYuvp[:count], \
              'iYuw':iYuwp[:count], \
              'iYvw':iYvwp[:count], \
              'eX':eXp[:count], \
              'eY':eYp[:count], \
              'eR':eRp[:count], \
              'ePhi':ePhip[:count], \
              'rand':evt_rand[:count],
              'timestamps':evt_ts[:count]}
        sio.savemat(os.path.join(self.save_path,'data.mat'),data)
        np.savez(os.path.join(self.save_path,'data.npz'),**data)
        
################################################################# 
    
    def GetIndex(self,evt):
        try:            
            evt_idx=evt[1][evt[0]==-1]
        except:
            print 'error'
            return None
        return evt_idx
        
    def GetTimestamp(self,evt):
        try:            
            evt_ts=evt[1][evt[0]==0][0]
        except:
            evt_ts=np.nan
        return evt_ts
        
    def GetIons(self,evt):
        ifu=self.cfg['ifu']
        ifv=self.cfg['ifv']
        ifw=self.cfg['ifw']
        ioffsetx=self.cfg['ioffsetx']
        ioffsety=self.cfg['ioffsety']
        MIH=self.maxionhits
        
        try:
            itof=evt[1][evt[0]==2]
            
        except:
            print 'error itof'
            itof=np.zeros((MIH))*np.nan

        try:  
            iTU1=evt[1][evt[0]==6]   

            iTU2=evt[1][evt[0]==7]
            iTV1=evt[1][evt[0]==8]
            iTV2=evt[1][evt[0]==9]
            iTW1=evt[1][evt[0]==10]
            iTW2=evt[1][evt[0]==11]

            # Time to position conversion HEX (ion) detector:
            iXuv=(iTU1-iTU2)*ifu+ioffsetx
            iXuw=(iTU1-iTU2)*ifu+ioffsetx
            iXvw=(iTV1-iTV2)*ifv + (iTW1-iTW2)*ifw+ioffsetx
            iYuv=((iTU1-iTU2)*ifu - 2.0*(iTV1-iTV2)*ifv)/np.sqrt(3.0)+ioffsety
            iYuw=(2.0*(iTW1-iTW2)*ifw - (iTU1-iTU2)*ifu)/np.sqrt(3.0)+ioffsety
            iYvw=((iTW1-iTW2)*ifw - (iTV1-iTV2)*ifv)/np.sqrt(3.0)+ioffsety
            
        except:
            #print 'error iXY'
            iXuv=np.zeros((MIH))*np.nan
            iXuw=np.zeros((MIH))*np.nan
            iXvw=np.zeros((MIH))*np.nan
            iYuv=np.zeros((MIH))*np.nan
            iYuw=np.zeros((MIH))*np.nan
            iYvw=np.zeros((MIH))*np.nan 
            
        return itof, iXuv, iXuw, iXvw, iYuv, iYuw, iYvw
    
    
    def GetElectrons(self,evt):
     
        efu=self.cfg['efu']
        efv=self.cfg['efv']
        eoffsetx=self.cfg['eoffsetx']
        eoffsety=self.cfg['eoffsety']
        
        MEH=self.maxelecthits
            
        try:     
            eTU1=evt[1][evt[0]==12]
            eTU2=evt[1][evt[0]==13]
            eTV1=evt[1][evt[0]==14]
            eTV2=evt[1][evt[0]==15]
            
             # Time to position conversion DLD (electron) detector:           
            eX=(eTU1-eTU2)*efu+eoffsetx
            eY=(eTV1-eTV2)*efv+eoffsety
            eR=np.sqrt(eX**2+eY**2)
            ePhi=np.arctan2(eY,eX)
            
        except:
            #print 'error eXY'
            eX=np.zeros((MEH))*np.nan
            eY=np.zeros((MEH))*np.nan
            eR=np.zeros((MEH))*np.nan
            ePhi=np.zeros((MEH))*np.nan
        
        return eX, eY, eR, ePhi
  

#################################################################
#################################################################    

def runclient(args):
    
    client=Client(args)
    client.Run()


if __name__=='__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("--name","-n",type=str, required=True)
    parser.add_argument("--base-path","-b",type=str, required=False)
    parser.add_argument("--save-path","-s",type=str, required=False)
    parser.add_argument("--max-n",type=int, required=False)
    parser.add_argument("--n-files",type=int, required=False)
    parser.add_argument("--max-ions","-mi",type=int, required=False)
    parser.add_argument("--max-electrons","-me",type=int, required=False)
    args=parser.parse_args()
    runclient(args) 



    
