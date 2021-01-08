// Hugo BERANGER - M2 MIAGE IA

#include <iostream>

using namespace std;

class Forme {
    private:
        string nom;
    public:
        Forme(string n){
            nom = n;
        };
        string who_am_i() const{
            return nom; 
        }
};

class Rectangle : public Forme {
    public:
        Rectangle (string n) : Forme(n){}
};

class Carre : public Forme {
    public:
        Carre (string n) : Forme(n){}
};

int main () {
    Rectangle rectangleObjet("rectangle");
    cout << "c++  - rectangle : " << rectangleObjet.who_am_i() << endl;
    Carre carreObjet("carré");
    cout << "c++  - carre : " << carreObjet.who_am_i() << endl;
    return 0;
}

