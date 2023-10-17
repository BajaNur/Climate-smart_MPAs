load('maps/kelp_persistence_1km.mat');
satdir='/Users/bwoodson/Documents/UGA/COBIA_LAB/Projects/baja-climate/sat_data/';
yy=2003:2019;

win=0.025;
stvar=nan(size(Latitude));

parfor ii=1:length(Latitude)
    if isfinite(Latitude(ii))
        
        if Latitude(ii)<=32.75
            fn='baja_sst_';
        else
            fn='ca_sst_';
        end   
        
        for jj=1:length(yy)-1

            fname=[satdir,fn,num2str(yy(jj)),'.nc'];

            lon=ncread(fname,'longitude');
            lat=ncread(fname,'latitude');
            %sst=squeeze(ncread(fname,'analysed_sst'));
            sst=squeeze(ncread(fname,'sst'));
            
            [n, m, o]=size(sst);

            if o>365
                o=365;
            end

            temp2=nan(1,365);

            time2=datenum(yy(jj),0,0)+(1:365);

            J=find(lat>=Latitude(ii)-win & lat<=Latitude(ii)+win);
            I=find(lon>=Longitude(ii)-2.*win & lon<=Longitude(ii));

            if numel(I)+numel(J)>=4
                temp2(1:o)=squeeze(mean(mean(sst(I,J,1:o),'omitnan'),'omitnan'));
            else
                temp2(1:o)=squeeze(mean(sst(I,J,1:o),'omitnan'));
            end

            temp2(temp2>40)=NaN;
            temp2(temp2<8)=NaN;

            %TT=smooth(time2,temp2,.2,'rloess')';

            if jj==1
                temperature=temp2;
                mtt=time2;
            else
                temperature=[temperature temp2];
                mtt=[mtt time2];
            end
        end

        tclim=smooth(mtt,temperature,.0156,'rloess')';

        J=find(isfinite(temperature));

        tvar=sum((temperature(J)-tclim(J)).^2)./length(J);
        stvar(ii)=tvar;
        if stvar(ii)>var(tclim)
            stvar(ii)=NaN;

        end
    end
    ii
end

stvar=stvar';

idx=1:1945;
T=table(idx',Latitude(2:end),Longitude(2:end),Persistenc(2:end),stvar(2:end),'VariableNames',{'pontid','Latitude','Longitude','Persistenc','SST_Var'});
writetable(T,'/Users/bwoodson/Desktop/Nur_paper/sstvar_persistence_datar.csv') 

