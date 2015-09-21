%% Exemple d'utilisation de la fonction GetObjet()

global P28 Calib_Implicite  % données chargées des fichiers *.mat
load P28
load Calib_Implicite

global PA0 PA20;  % valeurs pour définir les deux vues
PA0 = 1;
PA20 = 2;

%% Récupérer coords. 2D d'une bille numérisée dans les deux vues

bille_2D = zeros(2,2);
nom = 'A_1_1';
for vue = PA0:PA20,
    obj = GetObjet(P28.Calib.point_2D{vue},nom);
    bille_2D(vue,:) = obj.coord;
end
clear obj

%% Récupérer coords. 2D dans les 2 vues des points formant une vertèbre 

nom = 'Vertebre_T1';
vertebre = GetObjet(P28.Objet,nom);
vertebre_PA0  = zeros(6,2);
vertebre_PA20 = zeros(6,2);
for k = 1:6,
    vertebre_PA0(k,:) = vertebre.point_2D{PA0}(k).coord;
    vertebre_PA20(k,:) = vertebre.point_2D{PA20}(k).coord;
end
clear k

%% Récupérer coords. 3D d'un ensemble de billes par leurs noms

billes = ['A_1_1';'A_2_4';'A_3_4';'A_4_3';'A_5_5';...
          'B_1_1';'B_1_5';'B_3_3';'B_4_2';'B_5_3'];
billes_3D = zeros(length(billes),3);
for k = 1:length(billes)
    obj = GetObjet(Calib_Implicite.Calib.point_4D, billes(k,:));
    billes_3D(k,:) =  obj.coord;
end
clear obj k

