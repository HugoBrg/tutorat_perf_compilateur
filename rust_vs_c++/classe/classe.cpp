// Hugo BERANGER - M2 MIAGE IA

#include <iostream>

using namespace std;

class Rectangle {
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

int main () {
    Rectangle rectangleObjet(3,4);
    cout << "c++  - rectangle aire: " << rectangleObjet.aire() << endl;
    return 0;
}