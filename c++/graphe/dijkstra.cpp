//Hugo BERANGER - M2 MIAGE IA

#include <iostream>
#include <unordered_map>

using namespace std;

unordered_map<string, unordered_map<string, int>> initialisation(unordered_map<string, unordered_map<string, int>> graphe){
    unordered_map<string, int> chemins;
    chemins.insert({"B",1});
    chemins.insert({"C",1});
    graphe.insert({"A",chemins});
    chemins.clear();
    chemins.insert({"A",1});
    chemins.insert({"C",3});
    chemins.insert({"F",10});
    graphe.insert({"B",chemins});
    chemins.clear();
    chemins.insert({"A",1});
    chemins.insert({"B",3});
    chemins.insert({"D",2});
    chemins.insert({"E",4});
    graphe.insert({"C",chemins});
    chemins.clear();
    chemins.insert({"C",2});
    chemins.insert({"F",4});
    graphe.insert({"D",chemins});
    chemins.clear();
    chemins.insert({"C",4});
    chemins.insert({"F",1});
    graphe.insert({"E",chemins});
    chemins.clear();
    chemins.insert({"B",10});
    chemins.insert({"D",4});
    chemins.insert({"E",1});
    graphe.insert({"F",chemins});

    return graphe;
}

void dijkstra(unordered_map<string, unordered_map<string, int>> graphe, string depart, string arrive){
    int inf = numeric_limits<int>::max();
    int distance_mini = inf;
    unordered_map<string, bool> noeud_visite;
    unordered_map<string, int> distance;
    unordered_map<string, string> chemins;
    string noeud_courant = depart;
    string noeud_mini;

    distance.insert({depart,0});

    for (unordered_map<string, unordered_map<string, int>>:: iterator  itr = graphe.begin(); itr != graphe.end(); itr++) { 
        distance.insert({itr->first, inf});
        chemins.insert({itr->first, ""});
    }

    while (noeud_visite.size() != graphe.size()){
        noeud_visite.insert({noeud_courant,true});
        for(unordered_map<string, unordered_map<string, int>>:: iterator  itr = graphe.begin(); itr != graphe.end(); itr++){
            if (itr->first == noeud_courant){
                for(unordered_map<string, int>:: iterator  itr2 = (itr->second).begin(); itr2 != (itr->second).end(); itr2++){
                    if ((itr2->second) <= distance_mini){
                        if (noeud_visite.find(itr2->first) ==  noeud_visite.end()){
                            noeud_mini = itr2->first;
                            distance_mini = itr2->second;
                        }
                    }
                    if (distance.at(itr2->first)){
                        if ((distance.at(itr2->first)) > (itr2->second + (distance.at(itr->first)))) {
                            distance.at(itr2->first) = itr2->second + (distance.at(itr->first));
                            chemins.at(itr2->first) = itr->first;
                        }
                    }
                    if (noeud_visite.find(noeud_mini) != noeud_visite.end() && noeud_visite.size() != graphe.size()){
                        noeud_mini = itr2->first;
                    }
                }
            }
        }
        noeud_courant = noeud_mini;
        distance_mini = inf;
    }
    /*cout << "Distances : " << endl;
    for(unordered_map<string, int>:: iterator  itr = distance.begin(); itr != distance.end(); itr++){
        cout << itr->first << " - " << itr->second << endl;
    }*/

    noeud_courant = arrive;
    //cout << "Solution : " << noeud_courant;
    while(noeud_courant != depart){
        noeud_courant = chemins.at(noeud_courant);
        //cout << " - " <<noeud_courant;
    }
}

int main(){
    unordered_map<string, unordered_map<string, int>> graphe;
    graphe = initialisation(graphe);
    dijkstra(graphe,"A","F");
}