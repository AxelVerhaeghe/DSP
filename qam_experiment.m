clear();
len = 1800;
n = 4;

input = randi([0,1],1,len);
modulated = qam_mod(input,n);
scatterplot(modulated,1,0,'b*');