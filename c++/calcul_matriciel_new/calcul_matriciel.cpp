//Hugo BERANGER - M2 MIAGE IA

#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char* argv[]){

    int dim = std::atoi(argv[3]);

    //cout << argv[1] << std::endl;
    //cout << argv[2] << std::endl;
    //cout << argv[3] << std::endl;
    
    string myText;
    ifstream matrice1file(argv[1]);
    ifstream matrice2file(argv[2]);

    float matrice1[dim][dim];
    float matrice2[dim][dim];

    for(int z = 0; z < dim; z++){
        for(int t = 0; t < dim; t++){
            getline(matrice1file, myText);
            matrice1[z][t] = stof(myText);
            getline(matrice2file, myText);
            matrice2[z][t] = stof(myText);
        }
    }

    matrice1file.close(); 
    matrice2file.close(); 

    float produit[dim][dim];

    float temp = 0;

    for(int x = 0; x <dim; x++){
        for(int y = 0; y <dim; y++){
            for(int z = 0; z <dim; z++){
                temp = temp + matrice1[x][z] * matrice2[z][y];
            }
            produit[x][y] = temp;
            temp = 0;
        }
    }
    
    /*for(int x = 0; x <dim; x++){
        for(int y = 0; y <dim; y++){
            cout << produit[x][y] << " ";
        }
        cout << endl; 
    }*/

    cout.precision(32);
    cout << std::fixed;
    cout << "produit[0,0] : " << produit[0][0] << endl;
    
    return 0;
}