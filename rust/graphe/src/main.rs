//Hugo BERANGER - M2 MIAGE IA

use std::collections::HashMap;

fn initialisation(mut graphe: HashMap<String, HashMap<String, i32>>) -> HashMap<String, HashMap<String, i32>> {
    let mut chemins: HashMap<String, i32> = HashMap::new();
    chemins.insert(String::from("B"),1);
    chemins.insert(String::from("C"),1);
    graphe.insert(String::from("A"), chemins);
    let mut chemins: HashMap<String, i32> = HashMap::new();
    chemins.insert(String::from("A"),1);
    chemins.insert(String::from("C"),3);
    chemins.insert(String::from("F"),10);
    graphe.insert(String::from("B"),chemins);
    let mut chemins: HashMap<String, i32> = HashMap::new();
    chemins.insert(String::from("A"),1);
    chemins.insert(String::from("B"),3);
    chemins.insert(String::from("D"),2);
    chemins.insert(String::from("E"),4);
    graphe.insert(String::from("C"),chemins);
    let mut chemins: HashMap<String, i32> = HashMap::new();
    chemins.insert(String::from("C"),2);
    chemins.insert(String::from("F"),4);
    graphe.insert(String::from("D"),chemins);
    let mut chemins: HashMap<String, i32> = HashMap::new();
    chemins.insert(String::from("C"),4);
    chemins.insert(String::from("F"),1);
    graphe.insert(String::from("E"),chemins);
    let mut chemins: HashMap<String, i32> = HashMap::new();
    chemins.insert(String::from("B"),10);
    chemins.insert(String::from("D"),4);
    chemins.insert(String::from("E"),1);
    graphe.insert(String::from("F"),chemins);

    graphe
}

fn dijkstra(graphe: HashMap<String, HashMap<String, i32>>, depart: String, arrive: String) {
    let inf = f32::INFINITY;
    let mut distance_mini: i32 = inf as i32;
    let mut noeud_visite: HashMap<String, bool> = HashMap::new();                            //aucun noeud visité
    let mut distance: HashMap<String, i32> = HashMap::new();
    let mut chemins:HashMap<String, String> = HashMap::new();
    let mut noeud_courant:String = String::from(&depart);   //le noeud courant est le départ
    let mut noeud_mini: String = String::from("");

    for (key, _value) in &graphe {
        distance.insert(String::from(key),inf as i32 - 100);                                              //les distance pour chaque noeuds sont infinis
        chemins.insert(String::from(key),String::from(""));
    }

    distance.insert(depart,0);                                                                      //la distance du départ au départ est nulle

    loop {
        noeud_visite.insert(String::from(&noeud_courant), true);                                //on visite le noeud courant

        for(key,value) in &graphe{                                                              //on parcours le graphe
            if *key == noeud_courant{                                                           //quand on atteind le noeud courant
                for(key2, value2) in value {                                                    //on parcours les noeuds adjacents
                    if value2 <= &distance_mini && !noeud_visite.contains_key(key2) {                                         //sinon on selectionne le noeud de distance minimale
                        noeud_mini = String::from(key2);
                        distance_mini = *value2;
                    }

                    if distance.contains_key(key2){                                                     //d(debut,adjacents) > distance(debut,courant) + distance(courant,adjacents)
                        if distance.get(key2).unwrap() > &(*distance.get(key).unwrap() + *value2)  {
                            distance.insert(String::from(key2),*value2 + distance.get(key).unwrap());
                            chemins.insert(String::from(key2),String::from(key));
                        }
                    }
                    if noeud_visite.contains_key(&noeud_mini) &&  noeud_visite.len() != graphe.len() {
                        noeud_mini = String::from(key2);
                    }
                     
                }
            }
        }
        noeud_courant = String::from(&noeud_mini);                                              //on se déplace vers le noeud de distance minimale
        distance_mini = inf as i32;

        if noeud_visite.len() == graphe.len() {     //quand tout les noeuds on été visité on s'arrête
            break;
        }

    }
    println!("Distances : ");
    for (key, value) in &distance {
        println!("{} - {}",key,value);
    }

    noeud_courant = arrive;
    print!("Solution : {} ",noeud_courant);
    loop{
        noeud_courant = chemins.get(&noeud_courant).unwrap().to_string();
        print!("- {} ",noeud_courant);
        if noeud_courant == String::from("A"){
            break;
        }
    }
}

fn main() {
    let mut graphe: HashMap<String, HashMap<String, i32>> = HashMap::new();
    graphe = initialisation(graphe);
    dijkstra(graphe, String::from("A"), String::from("F"));
}