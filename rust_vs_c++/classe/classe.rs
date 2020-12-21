// Hugo BERANGER - M2 MIAGE IA

struct Rectangle {
    largeur: i32,
    longueur: i32,
}

impl Rectangle {
        fn aire(&self) -> i32 {
            self.largeur * self.longueur
        }
}

fn main() {
    let rectangle_objet = Rectangle {
        largeur: 3,
        longueur: 4,
    };
    println!("rust - rectangle aire: {}", rectangle_objet.aire());
}