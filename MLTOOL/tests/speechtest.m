
sig1 = speechget;
sig2 = signorm(sig1,1);
sig3 = sigpreacc(sig2,0.9);

[sig_nbr sig_size] = size(sig3);

fenetre = ones(sig_nbr,1)*hamming(sig_size)';

sig4 = sig3.*fenetre;

plot(1:256,sig1(3,:),1:256,sig2(3,:),1:256,sig3(3,:));

figure(2);
subplot(311);
plot(sig2(3,:));
subplot(312);
plot(sig3(3,:));
subplot(313);
plot(sig4(3,:));


fsig2 = abs(fft(sig2).^2);
fsig3 = abs(fft(sig3).^2);
fsig4 = abs(fft(sig4).^2);

figure(3);
subplot(311);
plot(fsig2(3,:));
subplot(312);
plot(fsig3(3,:));
subplot(313);
plot(fsig4(3,:));


siglpc = lpccod(sig4,12);



