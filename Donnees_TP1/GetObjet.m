function [ obj, index ] = GetObjet( objListe, objNom )
% ------------------------------------------------------------------------	
%																			
% FONCTION: GetObjet()														
%																			
% SYNOPSIS:
%       obj = GetObjet( objListe, objNom )
%																			
% DESCRIPTION:																
%	Recherche un objet dans une liste d'objets par son nom.										
%															
% ARGUMENTS:																
%	objListe  - liste de tous les objets.								        
%	objNom    - nom de l'objet recherché.							            
%																			
% RESULTATS:																	
%   obj - l'objet trouvé (ou un ensemble vide si rien n'est trouvé).
%   index - l'index de l'objet dans la liste (ou zéro si rien n'est trouvé).
%																			
% REMARQUES:	
%   La recherche n'est pas sensible aux majuscules/minuscules.		
%																			
% ------------------------------------------------------------------------	

if nargin < 2
   error ('GetObjet: nombre d''arguments incorrect.');
end

if isempty(objListe)
   obj = [] ;
   index = [] ;
   return ;
end

index = 0;
for i=1:length(objListe)
   if (strcmpi(deblank(objListe(i).name), deblank(objNom))==1)
      index = i;
   end
end
if index == 0
   obj = [] ;
else
   obj = objListe(index);
end

