// Hugo BERANGER - M2 MIAGE IA

trait Forme {
    fn get_nom(&self) -> &'static str;
    fn who_am_i(&self) -> &'static str {
        self.get_nom()
    }
}

struct Rectangle {
    nom: &'static str,
}

struct Carre {
    nom: &'static str,
}

impl Forme for Rectangle {
    fn get_nom(&self) -> &'static str {
        &self.nom
    }
}

impl Forme for Carre {
    fn get_nom(&self) -> &'static str {
        &self.nom
    }
}

fn main() {
    let rectangle_objet = Rectangle {
        nom: "rectangle",
    };
    println!("rust  - rectangle nom : {}",rectangle_objet.who_am_i());

    let carre_objet = Carre {
        nom: "carré",
    };
    println!("rust  - carré nom : {}",carre_objet.who_am_i());
}

