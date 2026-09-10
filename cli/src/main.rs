// On importe tous les éléments publics (fonctions, structs) du crate core_logic.
// La syntaxe 'use crate_name::item' est standard pour l'importation.
use core_picture_sorter::search_image;
use std::path::PathBuf;

use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(author, version, about = "Outil de tri d'images en CLI", long_about = None)]
pub struct Cli {
    /// Dossier contenant les images à trier
    #[arg(short, long, value_name = "DOSSIER")]
    pub input: PathBuf,

    /// Exécution à blanc sans déplacer de fichiers
    #[arg(short, long, default_value_t = false)]
    pub dry_run: bool,

    #[arg(short, long, default_value_t = false)]
    pub recursif: bool,

    #[command(subcommand)]
    pub command: Option<Commands>,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Trier par date EXIF
    ByDate {
        #[arg(short, long, default_value = "%Y/%m")]
        format: String,
    },
    /// Trier par résolution ou ratio
    ByResolution,
}

fn main() {
    let cli = Cli::parse();

    let images_path: PathBuf = PathBuf::from(cli.input);

    let result = search_image(images_path, cli.recursif);

    println!("=============================================");
    println!("🚀 Recherche d'image en cours...");
    println!("=============================================");

    println!("{:?}", result);
}

