// On importe tous les éléments publics (fonctions, structs) du crate core_logic.
// La syntaxe 'use crate_name::item' est standard pour l'importation.
use core_picture_sorter::{calculate_distance, Point, coefstorage::CoefStorage};

fn main() {
    println!("=============================================");
    println!("🚀 Démarrage de l'application utilisant le workspace.");
    println!("=============================================");

    // 1. Utiliser la fonction pour créer des points
    let p1 = Point::new(10.0, 5.0);
    let p2 = Point::new(20.0, 15.0);

    println!("Point 1 créé : {:?}", p1);
    println!("Point 2 créé : {:?}", p2);

    // 2. Utiliser la fonction publique pour calculer la distance
    // Nous passons les coordonnées des structures que nous venons de créer.
    let distance = calculate_distance(
        p1.x, p1.y,
        p2.x, p2.y
    );

    // 3. Affichage du résultat
    println!("\n--- Résultats ---");
    println!("La distance entre les deux points est : {:.2}", distance);

    // Exemple de démonstration : si le résultat est grand, c'est loin !
    if distance > 15.0 {
        println!("Conclusion : Ces points sont assez éloignés dans l'espace!");
    }
}

