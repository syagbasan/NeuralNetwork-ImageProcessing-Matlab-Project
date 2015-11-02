I = imread('ben.jpg');
%okunan resmin boyutu güncellenir
I = imresize(I,[640 480]);

%göz ve burun tespitinde hassasiyet ayari (Visual Computer Toolbox)
sensitivity_nose = 30;
sensitivity_lib = 200;

%göz tespiti
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
EyePosition = step(EyeDetect,I); % Eye Position => [x,y,Height,Width]
figure , imshow(I);
title('göz belirlendi');
rectangle('Position',EyePosition,'LineWidth',1,'LineStyle','-','EdgeColor','g');

%burun tespiti
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',sensitivity_nose);
NosePosition=step(NoseDetect,I);
figure,
imshow(I); hold on
for i = 1:size(NosePosition,1)
    rectangle('Position',NosePosition(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','b');
end
title('Nose Detection');
hold off;

%dudak tespiti
LibDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',sensitivity_lib);
LipPosition=step(LibDetect,I);
figure,imshow(I); hold on
for i = 1:size(LipPosition,1)
    rectangle('Position',LipPosition(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
title('Mouth Detection');
hold off;

% EyePosition(1)=x, EyePosition(2)=y, EyePosition(3)=Height, EyePosition(4)=Width
L_eye_to_R_eye_distance = EyePosition(3);
eye_to_nose_distance = (NosePosition(2) + NosePosition(4)/2)-(EyePosition(2) + EyePosition(4)/2);

Ratio1 = L_eye_to_R_eye_distance / eye_to_nose_distance;

eye_to_lip_distance = (LipPosition(2) + LipPosition(4)/2)-(EyePosition(2) + EyePosition(4)/2);

Ratio2 = L_eye_to_R_eye_distance / eye_to_lip_distance;

eye_to_chin_distance = 640 - (EyePosition(2) + EyePosition(4)/2); 
%yüz olarak gelen resmin yani dikeydeki son pixel ceneyi ifade edecegi
%için(480x640)px olarak gelen resim oldugundan 640 ' dan cikartilmistir.

Ratio3 = eye_to_nose_distance / eye_to_chin_distance;

Ratio4 = eye_to_nose_distance / eye_to_lip_distance;

% Egitim için neural network giris ve hedef verileri
%nn_input = [ giris_11 giris_12 giris_13 giris_14 giris_15 giris_21 giris_22 giris_23 giris_24 giris_25 giris_31 giris_32 giris_33 giris_34 giris_35 ]
%nn_target = [ 001 001 001 010 010 010 011 011 011 100 100 100 101 101 101 ]

%test edinlen bireyin yüz hattindaki oranlarin vektörü
test = [Ratio1; Ratio2 ;Ratio3; Ratio4];

%kullanilancak olan network aginin test cikisi
%burada network4 agi önceden hazirlanmis bir pakettir. ve bu kodun
%çalismasi için workspace'e import edilmelidir.
outputs = network4(test)

%sonuç
if outputs > 0 && outputs < 10
    disp('test 18 ile 25 yas arasindadir')
end
if outputs > 10 && outputs < 80
    disp('test 26 ile 35 yas arasindadir')
end
if outputs > 80 && outputs < 105
    disp('test 36 ile 45 yas arasindadir')
end


