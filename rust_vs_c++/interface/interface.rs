// Hugo BERANGER - M2 MIAGE IA

trait Forme {
    fn aire(&self) -> i32;
}

struct Rectangle {
    largeur: i32,
    longueur: i32,
}

struct Carre {
    cote: i32,
}

impl Forme for Rectangle {
        fn aire(&self) -> i32 {
            self.largeur * self.longueur
        }
}

impl Forme for Carre {
    fn aire(&self) -> i32 {
        self.cote * self.cote
    }
}

fn main() {
    let rectangle_objet = Rectangle {
        largeur: 3,
        longueur: 4,
    };
    println!("rust - rectangle aire: {}", rectangle_objet.aire());

    let carre_objet = Carre {
        cote:3,
    };
    println!("rust - carre aire: {}", carre_objet.aire());
}