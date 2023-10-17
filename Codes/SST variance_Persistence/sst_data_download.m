yy=[2003:2019];

%website='https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMEchlamday.mat?chlorophyll[(2002-07-16T12:00:00Z):1:(2012-06-16T00:00:00Z)][(0.0):1:(0.0)][(30):1:(32.2)][(-81.2):1:(-78.8)]'

for ii=(1:length(yy)-1)
    urlwrite(['https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdMWsstd1day_LonPM180.nc?sst[(',num2str(yy(ii)),'-01-01T12:00:00Z):1:(',num2str(yy(ii)),'-12-31T12:00:00Z)][(0.0):1:(0.0)][(27.0):1:(34.6.0)][(-121.0):1:(-114.0)]'],['baja_sst_',num2str(yy(ii)),'.nc']);
    disp([num2str(yy(ii)),' done..']);
end