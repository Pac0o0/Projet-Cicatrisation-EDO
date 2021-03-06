%% Turing 2D: FitzHugh-Nagumo 

% parametre des equations
%epsilon = 0.08;
%b = 0.7;
%c = 0.8;
D = 0.0005;
Dc = 0.45;
c0 = 5;
n0 = 5;
a = 5; % facteur de croissance des cellules
lambda = 2;
alpha = 1;
cm = 10;
k = 3;
H = 2*k;
%I = 0.32;


beta = (c0*c0+cm*cm-2*h*c0*cm)/((c0-cm)*(c0-cm));

% parametres de simulation, espace
s = 20; % taille domaine (carre sxs)
h = 10;
x0 = 0;
x1 = s;
y0 = 0;
y1 = s;
x = x0:h:x1;
y = y0:h:y1;
[X,Y] = meshgrid(x,y);
J = length(x);
J2 = J*J;
C1 = 2; %Taille de la cicatrice
C2 = 5;

% variable dynamiques
n = zeros(J2,1); % stocke seulement l'etat au temps t
c = zeros(J2,1);
newn = zeros(J2,1);
newc = zeros(J2,1);


% Condition periodiques
L = sparse(1:J2,1:J2,-4); % matrice creuse, compacte en memoire
coinhautgauche = 1;
coinbasgauche = J;
coinhautdroit = J*(J-1)+1;
coinbasdroit = J2;
bordgauche = 2:J-1;
bordhaut = J+1:J:J*(J-2)+1;
bordbas = 2*J:J:J*(J-1);
borddroit = J*(J-1)+2:J2-1;
bord = [coinhautgauche, coinhautdroit, coinbasgauche, coinbasdroit, ...
    bordgauche, bordhaut, bordbas, borddroit];
interieur = setdiff(1:J2, bord);

% interieur
L = L + sparse(interieur,interieur+1,1,J2,J2);
L = L + sparse(interieur,interieur-1,1,J2,J2);
L = L + sparse(interieur,interieur+J,1,J2,J2);
L = L + sparse(interieur,interieur-J,1,J2,J2);

% bords
L = L + sparse(bordhaut,bordhaut+1,1,J2,J2);
L = L + sparse(bordhaut,bordhaut+J-1,1,J2,J2);
L = L + sparse(bordhaut,bordhaut+J,1,J2,J2);
L = L + sparse(bordhaut,bordhaut-J,1,J2,J2);


L = L + sparse(bordgauche,bordgauche+1,1,J2,J2);
L = L + sparse(bordgauche,bordgauche-1,1,J2,J2);
L = L + sparse(bordgauche,bordgauche+J,1,J2,J2);
L = L + sparse(bordgauche,bordgauche+J*(J-1),1,J2,J2);

L = L + sparse(bordbas,bordbas-(J-1),1,J2,J2);
L = L + sparse(bordbas,bordbas-1,1,J2,J2);
L = L + sparse(bordbas,bordbas+J,1,J2,J2);
L = L + sparse(bordbas,bordbas-J,1,J2,J2);

L = L + sparse(borddroit,borddroit+1,1,J2,J2);
L = L + sparse(borddroit,borddroit-1,1,J2,J2);
L = L + sparse(borddroit,borddroit-J*(J-1),1,J2,J2);
L = L + sparse(borddroit,borddroit-J,1,J2,J2);

% coins
L(coinhautgauche,coinhautgauche+1) = 1;
L(coinhautgauche,coinhautgauche+J-1) = 1;
L(coinhautgauche,coinhautgauche+J) = 1;
L(coinhautgauche,coinhautgauche+J*(J-1)) = 1;


L(coinbasgauche,coinbasgauche-(J-1)) = 1;
L(coinbasgauche,coinbasgauche-1) = 1;
L(coinbasgauche,coinbasgauche+J) = 1;
L(coinbasgauche,coinbasgauche+J*(J-1)) = 1;

L(coinhautdroit,coinhautdroit+1) = 1;
L(coinhautdroit,coinhautdroit+J-1) = 1;
L(coinhautdroit,coinhautdroit-J*(J-1)) = 1;
L(coinhautdroit,coinhautdroit-J) = 1;

L(coinbasdroit,coinbasdroit-(J-1)) = 1;
L(coinbasdroit,coinbasdroit-1) = 1;
L(coinbasdroit,coinbasdroit-J*(J-1)) = 1;
L(coinbasdroit,coinbasdroit-J) = 1;

% condition initiales

n = -1 + 0.1*(-1 + 2*rand(J^2,1)); 
c = -0.3 + 0.1*(-1 + 2*rand(J^2,1));


% parametres de simulation, temps
t0 = 0;
tfinal = 200; 
t = t0;
% dt doit etre < a h^2/2/d/D ou dim d = 2+
dt = min(1,0.2*( h^2/4/max(D,Dc) ));
 

figure(1); clf;
surf(X,Y,reshape(n,J,J),'EdgeColor','none');
view(2)
drawnow;
tk = 0;


% BOUCLE PRINCIPALE
while t < tfinal
    drawnow;
    newn = D*dt/(h^2)*L*n; + k*((2*cm*(h-beta)*c)/(cm*cm)+c*c) - k*n;
    newc = Dc*dt/(h^2)*L*c; + lambda*c0*n/n0*((n0*n0+alpha*alpha)/(n*n+alpha*alpha)) - lambda * c;
    n = newn;
    c = newc;
    if tk > 1 
        t
        surf(X,Y,reshape(n,J,J),'EdgeColor','none');
        view(2)
        drawnow;
        tk = 0;
        
    end
    t = t + dt;
    tk = tk + dt;
end