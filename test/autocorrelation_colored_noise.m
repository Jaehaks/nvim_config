% 2���� �ٸ� �뿪���� ���� band limited (colored) noise�� �����
% autocorrelation���� ����� ����.
close all; clear all;

N = 1024; % size of array
L = 100; % FIR filter length
w = pi / 20; % LPF cutoff frequency
randseed(123);
noise = randn(N, 1); % noise generate

test
tset

setset
wetwe
% LPF impulse response compute
wn = pi * [1/20 1/8]; % BPF cut off frequency
hn = zeros(1, 100);

for k = 1:2 % 2���� fc ���� �ݺ�
    wc = wn(k); % ���� �Ҵ�

    for i = 1:L + 1 % sinc function�� ����� symmetrical
        % 1~49, 50, 51~101 3 ������ ��� ����.
        n = i - L / 2;

        if n == 0
            hn(i) = wc / pi; % �� 1�� �ƴ϶� wc/pi����?...?
        else
            hn(i) = (sin(wc * (n)) / pi * n); % filter impulse response
            % sin(w*n)/(pi/n)
        end

    end % ������� sinc/pi �Լ� ����� (�� cut off frequency��

    % sinc �Լ��� system ���� �ϴ� �ý����� �����
    % noise�� �Է����� �ϴ� �ý����� ����� ����� ����.

    out = conv(hn, noise); % noise �� conv ��Ų ���
    [cor, lags] = xcorr(out, 'coeff'); % ��¹� �������� auto correlation
    % normalized

    subplot(1, 2, k);
    plot(lags(1, :), cor(:, 1), 'k'); % shift �ϴ� ����� ���� auto
    % auto correlation ��� ����
    axis([-50 50 -0.5 1.1]);
    ylabel('Rxx');
    xlabel('Lags(n)');
    title(['Bandwidth = ', num2str(wc)]);
end
