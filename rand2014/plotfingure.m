% for f=1
% figure(f);
p2=zeros(1,30);
s2=zeros(1,30);
b2=zeros(1,30);

p=mean(popUnupdate);
s=mean(succUpdate);
b= mean(baseUnupdate);
for i=0:29
p2(i+1)=mean(p(100*i+1:100*i+100 ));
s2(i+1)=mean(s(100*i+1:100*i+100 ));
b2(i+1)=mean(b(100*i+1:100*i+100 ));
end
x=1:30;
y1=p2(x);

y2=s2(x);

y3=b2(x);

% semilogy(x,y1,'r^','MarkerIndices', round(linspace(1,length(x),10)),'linewidth',1.5);

% semilogy(x,y1,'r^-','linewidth',1.5);
% hold on
% semilogy(x,y2,'bo-','linewidth',1.5);
% hold on
% semilogy(x,y3,'k*-','linewidth',1.5);
bar(x,y2,'r');
hold on
bar(x,y1,'c');
hold on
bar(x,y3,'b');

legend('target vector','population', 'base vector','Location','SouthEast');%'DE_ sort','JADE_ sort'
% title(['F',num2str(f)]);

axis([  0 31 -inf inf]);%限定纵坐标范围，前两个限定横坐标，后两个限定纵坐标
gtext('\times 10^{2}')

xlabel('Generations','FontName','Times New Roman','FontSize',15);
ylabel('Unupdated number','FontName','Times New Roman','FontSize',15);

% end


