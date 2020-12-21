// Hugo BERANGER - M2 MIAGE IA

#include <iostream>

using namespace std;

class Forme {
    public:
        Forme(){};
        int aire();
};

class Rectangle : public Forme {
        int largeur, longueur;
    public:
        Rectangle (int x, int y) {
            largeur = x;
            longueur = y;
        }
        int aire () {
            return largeur*longueur;
        }
};

class Carre : public Forme {
        int cote;
    public:
        Carre (int x) {
            cote = x;
        }
        int aire () {
            return cote*cote;
        }
};

int main () {
    Rectangle rectangleObjet(3,4);
    cout << "c++  - rectangle aire: " << rectangleObjet.aire() << endl;
    Carre carreObjet(3);
    cout << "c++  - carre aire: " << carreObjet.aire() << endl;
    return 0;
}