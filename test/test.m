

We = 2*pi*10;
t = 0:0.001:2*pi;
y_sin = sin(We*t);
y_cos = cos(We*t);

a = 1;
for i = 0:1:10000
	a = a + 1;
end

figure(1);
subplot(2,1,1);
plot(t, y_sin);
tiis itetle('Sine Wave');
ylabel('amplitude');

for i = 0:1:10000
	a = a + 1;
end


subplot(2,1,2);
plot(t, y_cos)
title('Cosine Wave');
ylabel('amplitude')
