// On importe tous les éléments publics (fonctions, structs) du crate core_logic.
// La syntaxe 'use crate_name::item' est standard pour l'importation.
use core_picture_sorter::{search_image, plan_sort, coefstorage, execute_plan};
use std::path::PathBuf;

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(author, version, about = "Outil de tri d'images en CLI", long_about = None)]
pub struct Cli {
    /// Dossier contenant les images à trier
    #[arg(short, long, value_name = "DOSSIER")]
    pub input: Option<PathBuf>,

    #[arg(short, long, value_name = "DOSSIER")]
    pub output: Option<PathBuf>,

    #[command(subcommand)]
    pub add_coef: Option<Commands>,

    #[arg(short, long, default_value_t = false)]
    pub show_conf: bool,

    /// Exécution à blanc sans déplacer de fichiers
    #[arg(short, long, default_value_t = false)]
    pub dry_run: bool,

    #[arg(short, long, default_value_t = false)]
    pub recursif: bool,
}

#[derive(Subcommand)]
pub enum Commands {
    AddCoef {
        #[arg(long)]
        name: String,

        #[arg(long)]
        min: f32,
        #[arg(long)]
        max: f32,
    },

    RemoveCoef {
        #[arg(long)]
        name: String
    }
}

fn main() {
    let cli = Cli::parse();



    let mut coef_storage = coefstorage::CoefStorage::load_or_create().unwrap_or_else(|err| {
        eprintln!("Attention: Impossible de charger la configuration ({err}). Utilisation des valeurs par défaut.");
        coefstorage::CoefStorage::default()
    });

    if cli.show_conf {

        println!("{}", coef_storage);
        return;
    }


    if let Some(command) = cli.add_coef {
        match command {
            Commands::AddCoef { name, min, max } => {
                let range = coefstorage::CoefRange::new(min, max);
                coef_storage.add_coef(&name, range);

                if let Err(errors) = coef_storage.verify() {
                    eprintln!("❌ Configuration invalide après l'ajout :");
                    for err in errors {
                        eprintln!("  - {err}");
                    }
                    std::process::exit(1);
                }

                if let Err(err) = coef_storage.save() {
                    eprintln!("❌ Erreur lors de la sauvegarde : {err}");
                    std::process::exit(1);
                }

                println!("✅ Coefficient '{name}' [{min}, {max}] ajouté et sauvegardé avec succès.");
            }
            Commands::RemoveCoef { name } => {
                if coef_storage.remove_coef(&name) {
                    if let Err(err) = coef_storage.save() {
                        eprintln!("❌ Erreur lors de la sauvegarde : {err}");
                        std::process::exit(1);
                    }
                    println!("✅ Coefficient '{name}' supprimé avec succès.");
                } else {
                    eprintln!("⚠️ Le coefficient '{name}' n'existe pas.");
                }
            }
        }
        // Fin d'exécution si une sous-commande a été exécutée
        return;
    }

    match coef_storage.verify() {
        Ok(()) => {
            println!("Configuration des coefficients valide.");
        }
        Err(errors) => {
            eprintln!("Erreur(s) dans la configuration des coefficients :");
            for err in errors {
                eprintln!("  - {err}");
            }
        }
    }

    let images_path = cli.input.unwrap_or_else(|| {
        eprintln!("❌ L'option -i/--input est requise pour effectuer le tri.");
        std::process::exit(1);
    });

    let output_path = cli.output.unwrap_or_else(|| {
        eprintln!("❌ L'option -o/--output est requise pour effectuer le tri.");
        std::process::exit(1);
    });

    println!("=============================================");
    println!("🚀 Recherche d'image en cours...");
    println!("=============================================");

    let list_images = search_image(images_path, cli.recursif);

    println!("Image trouver : {}", list_images.len());

    println!("=============================================");
    println!("🚀 Trie d'image en cours...");
    println!("=============================================");

    let result = plan_sort(&list_images, coef_storage);


    println!("Catégorie trouvé {}", result.len());

    for (categorie, list) in &result {
        println!("--- {} ---", categorie);
        println!("Image trouver {}", list.len());
    }

    // TODO Verbose mode ou juste dernier
    let _ = execute_plan(&result, false,  output_path, |action, index, total| {
        println!("[{}/{}] Traitement de {:?}", index, total, action);
    });

}



