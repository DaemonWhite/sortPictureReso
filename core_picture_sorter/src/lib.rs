pub mod coefstorage;

use std::io::Read;
use std::fs::{self, File};
use std::path::PathBuf;
use image::guess_format;

pub fn search_image(path: PathBuf, recursif: bool) -> Vec<PathBuf> {
    let mut picture_paths = Vec::new();

    let entries = match fs::read_dir(&path) {
        Ok(entries) => entries,
        Err(_) => return picture_paths,
    };

    for entry in entries.flatten() {
        let entry_path = entry.path();

        if entry_path.is_file() {
            if is_image(&entry_path) {
                picture_paths.push(entry_path);
            }
        } else if recursif && entry_path.is_dir() {
            picture_paths.append(&mut search_image(entry_path, recursif));
        }
    }

    picture_paths
}

fn is_image(path: &PathBuf) -> bool {
    // Lecture des 16 premiers octets seulement (Magic Numbers)
    let mut file = match File::open(path) {
        Ok(f) => f,
        Err(_) => return false,
    };

    // Taille du buffer qui représente les 16 premier octets
    let mut buffer = [0u8; 16];
    if file.read(&mut buffer).is_err() {
        return false;
    }

    guess_format(&buffer).is_ok()
}
