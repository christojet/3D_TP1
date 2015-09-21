%% 
% Christopher Bousquet-Jetté (1539167) et Gregoire Germain (1790627)
%
%%
close all;
clear;
clc;

%% Question 1.1 :

% Chargement des fichiers
global P28 Calib_Implicite  % données chargées des fichiers *.mat
load P28
load Calib_Implicite

global PA0 PA20;  % valeurs pour définir les deux vues
PA0 = 1;
PA20 = 2;

% Chargement des coordonnées 3D de 10 billes
% billes A_5_3, A_5_4, B_5_4 et A_3_2 enlevées
billes = ['A_1_1';'A_1_2';'A_1_3';'A_1_4';'A_1_5';'A_1_6';'A_2_1';'A_2_2';...
          'A_2_3';'A_2_4';'A_2_5';'A_2_6';'A_3_1';'A_3_3';'A_3_4';...
          'A_3_5';'A_3_6';'A_4_1';'A_4_2';'A_4_3';'A_4_4';'A_4_5';'A_4_6';...
          'A_5_1';'A_5_2';'A_5_5';'B_1_1';'B_1_2';'B_1_3';...
          'B_1_4';'B_1_5';'B_2_1';'B_2_2';'B_2_3';'B_2_4';'B_2_5';'B_3_1';...
          'B_3_2';'B_3_3';'B_3_4';'B_3_5';'B_4_1';'B_4_2';'B_4_3';'B_4_4';...
          'B_4_5';'B_5_1';'B_5_2';'B_5_3';'B_5_5'];
billes_3D = zeros(length(billes),3);
for k = 1:length(billes)
    obj = GetObjet(Calib_Implicite.Calib.point_4D, billes(k, :));
    billes_3D(k,:) =  obj.coord;
end
clear obj k

% Chargement des coordonnées 2D des projections des 10 billes
billes_2D_PA0 = zeros(length(billes),2);
billes_2D_PA20 = zeros(length(billes),2);
for k = 1:length(billes)
    obj = GetObjet(P28.Calib.point_2D{PA0}, billes(k, :));
    billes_2D_PA0(k,:) =  obj.coord;
    obj = GetObjet(P28.Calib.point_2D{PA20}, billes(k, :));
    billes_2D_PA20(k,:) = obj.coord;
end
clear obj k

% Matrice de calibration implicite DLT PA0
A_0 = zeros(100,11);
for k = 1:50
    A_0(2*k-1:2*k,:) = [billes_3D(k,1) billes_3D(k,2) billes_3D(k,3) 1 0 0 0 0 ...
      -billes_2D_PA0(k,1)*billes_3D(k,1) -billes_2D_PA0(k,1)*billes_3D(k,2) ...
      -billes_2D_PA0(k,1)*billes_3D(k,3) ; 0 0 0 0 billes_3D(k,1) billes_3D(k,2) ...
      billes_3D(k,3) 1 -billes_2D_PA0(k,2)*billes_3D(k,1) -billes_2D_PA0(k,2)*billes_3D(k,2) ...
      -billes_2D_PA0(k,2)*billes_3D(k,3)];
end
b_0 = zeros(100,1);
for k = 1:50
    b_0(2*k-1) = billes_2D_PA0(k,1);
    b_0(2*k) = billes_2D_PA0(k,2);
end
M_0_2 = (A_0'*A_0)\A_0'*b_0;
M_0 = [M_0_2(1,1) M_0_2(2,1) M_0_2(3,1) M_0_2(4,1); M_0_2(5,1) M_0_2(6,1) M_0_2(7,1) M_0_2(8,1); M_0_2(9,1) M_0_2(10,1) M_0_2(11,1) 1];

% Matrice de calibration implicite DLT PA20
A_20 = zeros(100,11);
for k = 1:50
    A_20(2*k-1:2*k,:) = [billes_3D(k,1) billes_3D(k,2) billes_3D(k,3) 1 0 0 0 0 ...
      -billes_2D_PA20(k,1)*billes_3D(k,1) -billes_2D_PA20(k,1)*billes_3D(k,2) ...
      -billes_2D_PA20(k,1)*billes_3D(k,3) ; 0 0 0 0 billes_3D(k,1) billes_3D(k,2) ...
      billes_3D(k,3) 1 -billes_2D_PA20(k,2)*billes_3D(k,1) -billes_2D_PA20(k,2)*billes_3D(k,2) ...
      -billes_2D_PA20(k,2)*billes_3D(k,3)];
end
b_20 = zeros(100,1);
for k = 1:50
    b_20(2*k-1) = billes_2D_PA20(k,1);
    b_20(2*k) = billes_2D_PA20(k,2);
end
%M_20_2 = zeros(11,1);
M_20_2 = (A_20'*A_20)\A_20'*b_20;
M_20 = [M_20_2(1,1) M_20_2(2,1) M_20_2(3,1) M_20_2(4,1); M_20_2(5,1) M_20_2(6,1) M_20_2(7,1) M_20_2(8,1); M_20_2(9,1) M_20_2(10,1) M_20_2(11,1) 1];

%% Question 1.2:

% Pour PA0
% Définition de variables
L0 = M_0(:,1:3);
L0_22 = M_0(:,4);
L0_1 = M_0(1,1); L0_2 = M_0(1,2); L0_3 = M_0(1,3); L0_4 = M_0(1,4);...
    L0_5 = M_0(2,1); L0_6 = M_0(2,2); L0_7 = M_0(2,3); L0_8 = M_0(2,4);...
    L0_9 = M_0(3,1); L0_10 = M_0(3,2); L0_11 = M_0(3,3); L0_12 = M_0(3,4);

% Paramètre intrinsèques
d0 = -1/(sqrt(L0_9^2 + L0_10^2 + L0_11^2));
% coordonnées (u0, v0) de la projection de la source dans le repère local lié àl’image
u0_0 = (L0_1*L0_9+L0_2*L0_10+L0_3*L0_11)*(d0^2);
v0_0 = (L0_5*L0_9+L0_6*L0_10+L0_7*L0_11)*(d0^2);
% coordonnées (u0, v0) de la projection de la source dans le repère local lié àl’image
cu0 = sqrt((d0^2)*((u0_0*L0_9-L0_1)^2 + (u0_0*L0_10-L0_2)^2 + (u0_0*L0_11-L0_3)^2));
cv0 = sqrt((d0^2)*((v0_0*L0_9-L0_5)^2 + (v0_0*L0_10-L0_6)^2 + (v0_0*L0_11-L0_7)^2));

% Paramètre extrinsèques
% les coordonnées (X0, Y0, Z0) de la source dans le repère global;
T = -L0\L0_22;
X0_0 = T(1,1);
Y0_0 = T(2,1);
Z0_0 = T(3,1);
%la matrice de rotation entre les repères local et global.
R11_0 = (d0/cu0)*(u0_0*L0_9-L0_1);
R12_0 = (d0/cu0)*(u0_0*L0_10-L0_2);
R13_0 = (d0/cu0)*(u0_0*L0_11-L0_3);
R21_0 = (d0/cv0)*(v0_0*L0_9-L0_5);
R22_0 = (d0/cv0)*(v0_0*L0_10-L0_6);
R23_0 = (d0/cv0)*(v0_0*L0_11-L0_7);
R31_0 = L0_9*d0;
R32_0 = L0_10*d0;
R33_0 = L0_11*d0;

% Pour PA20
% Définition de variables
L20 = M_20(:,1:3);
L20_22 = M_20(:,4);
L20_1 = M_20(1,1); L20_2 = M_20(1,2); L20_3 = M_20(1,3); L20_4 = M_20(1,4);...
    L20_5 = M_20(2,1); L20_6 = M_20(2,2); L20_7 = M_20(2,3); L20_8 = M_20(2,4);...
    L20_9 = M_20(3,1); L20_10 = M_20(3,2); L20_11 = M_20(3,3); L20_12 = M_20(3,4);

% Paramètre intrinsèques
d20 = -1/(sqrt(L20_9^2 + L20_10^2 + L20_11^2));
% coordonnées (u0, v0) de la projection de la source dans le repère local lié àl’image
u0_20 = (L20_1*L20_9+L20_2*L20_10+L20_3*L20_11)*(d20^2);
v0_20 = (L20_5*L20_9+L20_6*L20_10+L20_7*L20_11)*(d20^2);
% les distances focales
cu20 = sqrt((d20^2)*((u0_20*L20_9-L20_1)^2 + (u0_20*L20_10-L20_2)^2 + (u0_20*L20_11-L20_3)^2));
cv20 = sqrt((d20^2)*((v0_20*L20_9-L20_5)^2 + (v0_20*L20_10-L20_6)^2 + (v0_20*L20_11-L20_7)^2));

% Paramètre extrinsèques
% les coordonnées (X0, Y0, Z0) de la source dans le repère global;
T = -L20\L20_22;
X20_0 = T(1,1);
Y20_0 = T(2,1);
Z20_0 = T(3,1);
%la matrice de rotation entre les repères local et global.
R11_20 = (d20/cu20)*(u0_20*L20_9-L20_1);
R12_20 = (d20/cu20)*(u0_20*L20_10-L20_2);
R13_20 = (d20/cu20)*(u0_20*L20_11-L20_3);
R21_20 = (d20/cv20)*(v0_20*L20_9-L20_5);
R22_20 = (d20/cv20)*(v0_20*L20_10-L20_6);
R23_20 = (d20/cv20)*(v0_20*L20_11-L20_7);
R31_20 = L20_9*d20;
R32_20 = L20_10*d20;
R33_20 = L20_11*d20;

%% Question 1.3

% Récupérer coords. 2D dans les 2 vues des points formant une vertèbre 
nom = 'Vertebre_T1';
vertebre = GetObjet(P28.Objet,nom);
vertebre_PA0  = zeros(6,2);
vertebre_PA20 = zeros(6,2);
for k = 1:6,
    vertebre_PA0(k,:) = vertebre.point_2D{PA0}(k).coord;
    vertebre_PA20(k,:) = vertebre.point_2D{PA20}(k).coord;
end
clear k

























