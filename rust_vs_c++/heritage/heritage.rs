// Hugo BERANGER - M2 MIAGE IA

trait Forme {
    fn aire(&self) -> i32;
    fn get_nom(&self) -> &'static str;
    fn who_am_i(&self) -> String {
        format!("Je suis un {} !", self.get_nom())
    }
}

struct Rectangle {
    nom: String,
    largeur: i32,
    longueur: i32,
}

struct Carre {
    nom: String,
    cote: i32,
}

impl Forme for Rectangle {
    fn aire(&self) -> i32 {
        self.largeur * self.longueur
    }

    fn get_nom(&self) -> &'static str {
        &self.nom
    }
}

impl Forme for Carre {
    fn aire(&self) -> i32 {
        self.cote * self.cote
    }

    fn get_nom(&self) -> &'static str {
        &self.nom
    }
}

fn main() {
    let rectangle_objet = Rectangle {
        nom: String::from("Rectangle"),
        largeur: 3,
        longueur: 4,
    };
    rectangle_objet.who_am_i();

    let carre_objet = Carre {
        nom: String::from("Carré"),
        cote:3,
    };
    carre_objet.who_am_i();
}